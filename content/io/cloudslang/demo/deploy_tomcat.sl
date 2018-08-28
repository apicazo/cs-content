########################################################################################################################
#!!
#! @description: Generated flow description.
#!
#! @input input_1: Generated description.
#! @input input_2: Generated description.
#!
#! @output output_1: Generated description.
#!
#! @result SUCCESS: Flow completed successfully.
#! @result FAILURE: Failure occurred during execution.
#!!#
########################################################################################################################

namespace: content.io.cloudslang.demo
imports:
 base: io.cloudslang.base
 vm: io.cloudslang.vmware.vcenter.virtual_machines

flow:
  name: deploy_tomcat

  inputs:
    - hostname: "10.0.46.10"
    - username: "CAPA1\\1047-capa1user"
    - password: "Automation123"
    - image: "Ubuntu"
    - folder: "Students"

  workflow:
    - uuid_generator:
        do:
          base.utils.uuid_generator:
        publish:
          - uuid: '${new_uuid}'
        navigate:
          - SUCCESS: trim
    - trim:
        do:
          base.strings.substring:
            - origin_string: '${"ex-"+uuid}'
            - end_index: '13'
        publish:
          - id: '${new_string}'
        navigate:
          - SUCCESS: clone_vm
          - FAILURE: FAILURE
    - clone_vm:
        do:
          vm.clone_virtual_machine:
            - host: '${hostname}'
            - hostname: '10.0.44.8'
            - username: '${username}'
            - password: '${password}'
            - clone_host: '10.0.44.8'
            - clone_data_store: 'datastore2'
            - data_center_name: 'CAPA1 Datacenter'
            - is_template: 'false'
            - virtual_machine_name: '${image}'
            - clone_name: '${id}'
            - folder_name: '${folder}'
        navigate:
          - SUCCESS: power_on
          - FAILURE: FAILURE
    - power_on:
        do:
          vm.power_on_virtual_machine:
            - host: '${hostname}'
            - username: '${username}'
            - password: '${password}'
            - virtual_machine_name: '${id}'
        navigate:
          - SUCCESS: sleep
          - FAILURE: FAILURE
    - sleep:
            do:
              base.utils.sleep:
                - seconds: '30'

            navigate:
              - SUCCESS: get_details
              - FAILURE: FAILURE
    - get_details:
        do:
          vm.get_virtual_machine_details:
            - host: '${hostname}'
            - username: '${username}'
            - password: '${password}'
            - hostname: '10.0.44.8'
            - virtual_machine_name: '${id}'
        publish:
            - details : '${return_result}'
        navigate:
            - SUCCESS: parse_IP
            - FAILURE: FAILURE
    - parse_IP:
        do:
          base.json.get_value:
            - json_input: '${details}'
            - json_path: 'ipAddress'
        publish:
            - ip : '${return_result}'
        navigate:
            - SUCCESS: deploy_tomcat
            - FAILURE: FAILURE
    - deploy_tomcat:
        do:
          base.os.linux.samples.deploy_tomcat_on_ubuntu:
            - host: ${ip}
            - root_password: 'admin@123'
            - user_password: 'admin@123'
            - java_version: "openjdk-7-jdk"
            - download_url: "http://www-us.apache.org/dist/tomcat/tomcat-8/v8.0.53/bin/apache-tomcat-8.0.53.tar.gz"
            - file_name: "apache-tomcat-8.0.53.tar.gz"
            - source_path: "/opt/apache-tomcat/bin"
            - script_file_name: "startup.sh"
        publish:
            - tomcat_url: '${"http://" + host + ":8080"}'
        navigate:
            - SUCCESS: verify_url
            - INSTALL_JAVA_FAILURE: FAILURE
            - SSH_VERIFY_GROUP_EXIST_FAILURE: FAILURE
            - CHECK_GROUP_FAILURE: FAILURE
            - ADD_GROUP_FAILURE: FAILURE
            - ADD_USER_FAILURE: FAILURE
            - CREATE_DOWNLOADING_FOLDER_FAILURE: FAILURE
            - UNTAR_TOMCAT_APPLICATION_FAILURE: FAILURE
            - DOWNLOAD_TOMCAT_APPLICATION_FAILURE: FAILURE
            - CREATE_SYMLINK_FAILURE: FAILURE
            - INSTALL_TOMCAT_APPLICATION_FAILURE: FAILURE
            - CHANGE_TOMCAT_FOLDER_OWNERSHIP_FAILURE: FAILURE
            - CHANGE_DOWNLOAD_TOMCAT_FOLDER_OWNERSHIP_FAILURE: FAILURE
            - CREATE_INITIALIZATION_FOLDER_FAILURE: FAILURE
            - UPLOAD_INIT_CONFIG_FILE_FAILURE: FAILURE
            - CHANGE_PERMISSIONS_FAILURE: FAILURE
            - START_TOMCAT_APPLICATION_FAILURE: FAILURE
    - verify_url:
        do:
          verify_url:
            - tomcat_url
        publish:
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE
