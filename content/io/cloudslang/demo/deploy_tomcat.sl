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
            - hostname: 'trnesxi3.eswdc.net'
            - username: '${username}'
            - password: '${password}'
            - clone_host: 'trnesxi3.eswdc.net'
            - clone_data_store: 'datastore2'
            - data_center_name: 'CAPA1 Datacenter'
            - is_template: 'false'
            - virtual_machine_name: '${image}'
            - clone_name: '${id}'
            - folder_name: '${folder}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
