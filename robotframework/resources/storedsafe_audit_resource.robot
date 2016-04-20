*** Settings ***
Library           storedsafe_robot_lib/storedsafe_lib.py

*** Keywords ***
audit log object created
    [Arguments]    ${username}    ${vaultname}    ${objectname}
    ${event id}=    audit event object created    ${username}    ${vaultname}    ${objectname}
    Should Be True    ${event id}
