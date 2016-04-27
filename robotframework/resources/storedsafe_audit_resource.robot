*** Settings ***
Library           storedsafe_robot_lib/storedsafe_lib.py

*** Keywords ***
audit log object created
    [Arguments]    ${username}    ${vaultname}    ${objectname}
    ${event id}=    audit event object created    ${username}    ${vaultname}    ${objectname}
    Should Be True    ${event id}

audit log object decrypted
    [Arguments]    ${username}    ${vault}    ${objectname}
    ${id vault}=    Get Vault Id By Name    ${vault}
    ${id user}=    Get User Id    ${username}
    ${id object}=    Get Object Id By Name    ${vault}    ${objectname}
    ${bool}=    Audit Event Object Decryption    ${id user}    ${id vault}    ${id object}
    Should Be True    ${bool}    expected to find an audit log event of ${objectname} being decrypted, but did not

audit log object copied
    [Arguments]    ${user}    ${vault from}    ${vault to}    ${object}
    ${id user}=    Get User Id    ${user}
    ${id from}=    Get Vault Id By Name    ${vault from}
    ${id to}=    Get Vault Id By Name    ${vault to}
    ${id object}=    Get Object Id By Name    ${vault from}    ${object}
    ${bool}=    Audit Event Object Copied    ${id user}    ${id from}    ${id to}    ${id object}
    Should Be True    ${bool}    expected copy event for ovject ${object} from ${vault from} to ${vault to} in audit log, but could not find one
