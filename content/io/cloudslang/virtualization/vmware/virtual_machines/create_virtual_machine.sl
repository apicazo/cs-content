#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs a VMware vSphere command in order to create a new virtual machine.
#!
#! @prerequisites: vim25.jar
#!   How to obtain the vim25.jar:
#!     1. Go to https://my.vmware.com/web/vmware and register.
#!     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600 and download the VMware-vSphere-SDK-6.0.0-2561048.zip.
#!     3. Locate the vim25.jar in ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib.
#!     4. Copy the vim25.jar into the ClodSlang CLI folder under /cslang/lib.
#!
#! @input host: VMware host or IP
#!              example: 'vc6.subdomain.example.com'
#! @input port: port to connect through
#!              optional
#!              examples: '443', '80'
#!              default: '443'
#! @input protocol: connection protocol
#!                  optional
#!                  valid: 'http', 'https'
#!                  default: 'https'
#! @input username: VMware username to connect with
#! @input password: password associated with <username> input
#! @input trust_everyone: if 'True', will allow connections from any host, if 'False', connection will be
#!                        allowed only using a valid vCenter certificate
#!                        optional
#!                        default: True
#!                        Check https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#!                        to see how to import a certificate into Java Keystore and
#!                        https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#!                        to see how to obtain a valid vCenter certificate.
#! @input data_center_name: data center name where host system is
#!                          example: 'DataCenter2'
#! @input hostname: name of target host to be queried to retrieve supported guest OSs
#!                  example: 'host123.subdomain.example.com'
#! @input virtual_machine_name: name of virtual machine that will be created
#!                              optional
#! @input description: description of virtual machine that will be created
#!                     default: ''
#! @input data_store: datastore where disk of newly created virtual machine will reside
#!                    example: 'datastore2-vc6-1'
#! @input num_cpus: number that indicates how many processors the newly created virtual machine will have
#!                  optional
#!                  default: '1'
#! @input vm_disk_size: disk capacity (in Mb) attached to virtual machine that will be created
#!                      optional
#!                      default: '1024'
#! @input vm_memory_size: amount of memory (in Mb) attached to virtual machine that will be created
#!                        optional
#!                        default: '1024'
#! @input guest_os_id: operating system associated with newly created virtual machine; value for this input can
#!                     be obtained by running utils/get_os_descriptors operation
#!                     examples: 'winXPProGuest', 'win95Guest', 'centosGuest', 'fedoraGuest', 'freebsd64Guest'
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: virtual machine was successfully created
#! @result FAILURE: an error occurred when trying to create a new virtual machine
#!!#
########################################################################################################################

namespace: io.cloudslang.virtualization.vmware.virtual_machines

operation:
  name: create_virtual_machine
  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username
    - password
    - trust_everyone:
        required: false
    - trustEveryone:
        default: ${get("trust_everyone", "true")}
        overridable: false
    - data_center_name
    - dataCenterName:
        default: ${get("data_center_name")}
        overridable: false
    - hostname:
        default: ''
        required: false
    - virtual_machine_name
    - virtualMachineName:
        default: ${get("virtual_machine_name")}
        overridable: false
    - description:
        default: ''
        required: false
    - data_store
    - dataStore:
        default: ${get("data_store", "")}
        overridable: false
    - num_cpus:
        required: false
    - numCPUs:
        default: ${get("num_cpus", "1")}
        overridable: false
    - vm_disk_size:
        required: false
    - vmDiskSize:
        default: ${get("vm_disk_size", "1024")}
        overridable: false
    - vm_memory_size:
        required: false
    - vmMemorySize:
        default: ${get("vm_memory_size", "1024")}
        overridable: false
    - guest_os_id
    - guestOsId:
        default: ${get("guest_os_id")}
        overridable: false

  action:
    java_action:
      className: io.cloudslang.content.vmware.actions.vm.CreateVM
      methodName: createVM

  outputs:
    - return_result: ${get("returnResult", "")}
    - error_message: ${get("exception", returnResult if returnCode != '0' else '')}
    - return_code: ${returnCode}

  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE
