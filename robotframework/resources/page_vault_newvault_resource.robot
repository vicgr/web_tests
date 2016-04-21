*** Settings ***
Library           Selenium2Library
Library           storedsafe_robot_lib/storedsafe_lib.py

*** Variables ***
${newvaultbutton}    id=newgroup
${field name}     id=groupname
${dropdown policy}    id=policy
${field info}     id=info
${submitbutton}    id=submitbutton
${newvault popup}    id=popupwindow

*** Keywords ***
create new vault
    [Arguments]    ${vaultname}
    ${vaultpolicy}=    get newvault policy    ${vaultname}
    ${vaultinfo}=    get newvault info    ${vaultname}
    click button    ${newvaultbutton}
    focus    ${newvault popup}
    Input Text    ${field name}    ${vaultname}
    Input Text    ${field info}    ${vaultinfo}
    Select From List    ${dropdown policy}    ${vaultpolicy}
    Click Button    ${submitbutton}
