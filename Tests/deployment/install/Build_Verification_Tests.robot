*** Settings ***
Suite Setup       SetupBrowsingEnv
Suite Teardown    DestroyBrowsingEnv
Resource          certifications_resources.txt
Resource          ../../../lib/web/WebLib.txt

*** Variables ***
${NODE_IP}        plaban-lenovo
${Username}       plaban
${User_Key}       /home/${Username}/.ssh/id_rsa
${dt_version}      3.8.0
${download_link}    https://www.datatorrent.com/downloads/${dt_version}/datatorrent-rts-${dt_version}.bin
${installer}      datatorrent-rts-${dt_version}.bin
${DT_PORT}        9090    #Assuming DT gateway running on default port
${Hadoop_Executable_Location}     /home/${Username}/hadoop/bin/hadoop
${DFS_Location}             /user/${Username}/datatorrent                                     #/user/${Username}/datatorrent
${Installer_Dir}    /home/${Username}/datatorrent

*** Test Cases ***
1_DT_Installation_Configuration     
    Login    ${NODE_IP}    ${Username}    ${User_Key}
    ${out}    ${rc}=    Execute Command    ${Installer_Dir}/current/uninstall.sh    return_stdout=true    return_rc=true
    ${out}    ${rc}=    Execute Command    rm -rf ${Installer_Dir}/releases    return_stdout=true    return_rc=true
    #Download DT Build    ${download_link}    ${installer}
    ${out}    ${rc}=    Execute Command    ./${installer}   return_stdout=true    return_rc=true
    Should Be Equal As Integers    0    ${rc}
    ${out}=    Execute Command    ./datatorrent/current/bin/dtgateway status
    Should Contain    ${out}    running
    Configure_DT    http://${NODE_IP}:${DT_PORT}/static/#/welcome    ${Hadoop_Executable_Location}    ${DFS_Location}

DT_Uninstallation
    Login    ${NODE_IP}    ${Username}    ${User_Key}
    ${out}    ${rc}=    Execute Command    ${Installer_Dir}/current/uninstall.sh    return_stdout=true    return_rc=true
    Should Be Equal As Integers    0    ${rc}
    log             ${out}
    ${out}    ${rc}=    Execute Command    rm -rf ${Installer_Dir}    return_stdout=true    return_rc=true 
    Should Be Equal As Integers    0    ${rc}

#paramiko.util.log_to_file("filename.log") add this to remove No handlers could be found for logger "paramiko.transport"
