*** Settings ***
Library           Selenium2Library
Library           storedsafe_robot_lib/storedsafe_lib.py
Resource          storedsafe_url_resources.robot
Resource          page_vault_newitem_resource.robot
Resource          page_vault_newvault_resource.robot

*** Variables ***
${vault list}     id=objectlistwindow
${vault bar}      bartitle
${vault_open_class}    bars _on
${vault_closed_class}    bars _off
${button copy}    id=copy_
${button move}    id=move_
${button paste}    id=paste_
${button delete}    id=delete_

*** Keywords ***
verify on vaults page
    location should contain    ${url vaults}
    Page Should Contain Element    ${vault list}

Open Vault
    [Arguments]    ${vaultname}
    ${vault id}=    Get Vault Id    ${vaultname}
    Open Vault by Id    ${vault id}

Open Vault by Name
    [Arguments]    ${vaultname}
    ${vault id}=    Get Vault Id By Name    ${vaultname}
    Open Vault by Id    ${vault id}

Open Vault by Id
    [Arguments]    ${vault id}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Run Keyword if    '${class}'=='${vault_closed_class}'    Click Element    ${vault bar}${vault id}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Should Be Equal As Strings    ${class}    ${vault_open_class}

Close Vault
    [Arguments]    ${vaultname}
    ${vault id}=    Get Vault Id    ${vaultname}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Run Keyword Unless    '${class}'=='${vault_open_class}'    Click Element    ${vault bar}${vault id}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Should Be Equal As Strings    ${class}    ${vault_closed_class}

New Server Item In Vault
    [Arguments]    ${name of vault}    ${item name}
    Open Vault    ${name of vault}
    ${vault id}=    Get Vault Id    ${name of vault}
    Click Button    bar${vaultid}add
    Wait Until Element Is Visible    ${newitem popup}
    Focus    ${newitem popup}
    Click Element    ${radio server}
    Click Button    ${newitem continue}${vault id}
    Focus    ${newitem popup}
    ${host}=    item server get host    ${item name}
    ${username}=    item server get username    ${item name}
    ${alert}=    item server get alert    ${item name}
    ${info}=    item server get info    ${item name}
    ${sens info}=    item server get sens info    ${item name}
    ${password}=    item server get password    ${item name}
    Input Text    ${newitem host}    ${item name}
    Input Text    ${newitem username}    ${username}
    Run Keyword If    '${password}'=='${empty}'    Click Button    ${newitem password generator}
    Run Keyword Unless    '${password}'=='${empty}'    Input Password    ${newitem password}    ${password}
    Run Keyword If    ${alert}    Select Checkbox    ${newitem alarm}
    Input Text    ${newitem info}    ${info}
    Input Text    ${newitem sensitive info}    ${sens info}
    Click Button    ${newitem submit}

Create Vault
    [Arguments]    ${username}    ${vaultname}
    create new vault    ${vaultname}
    ${bool}=    Audit Event Vault Created    ${username}    ${vaultname}
    Should Be True    ${bool}    No vault created event found in audit log for ${vaultname}
    ${vault id}=    Get VaultID by name    ${vaultname}
    Page Should Contain Element    bar${vault id}    Expected to find ${vaultname} in the list of vaults. Could not.

Copy Object
    [Arguments]    ${user}    ${vault from}    ${vault to}    ${objectname}
    ${id from}=    Get Vault Id    ${vault from}
    ${id to}=    Get Vault Id By Name    ${vault to}
    ${bool}=    Get Object Id By Name    ${vault from}    ${objectname}
    Should Be True    ${bool}    no active object with name ${objectname} exists in ${vault from}
    Open Vault by Id    ${id from}
    Open Vault by Id    ${id to}
    ${object id}=    Get Object Id By Name    ${vault from}    ${objectname}
    ${o type}=    Get Object Type    ${objectname}
    Wait Until Element Is Visible    id=mod_${id from}_${o type}_${object id}
    Select Checkbox    id=mod_${id from}_${o type}_${object id}
    Click Element    ${button copy}${id from}
    Click Element    ${button paste}${id to}
    Confirm Action
    ${userid}=    Get User Id    ${user}
    ${bool}=    Audit Event Object Copied    ${userid}    ${id from}    ${id to}    ${object id}
    Should Be True    ${bool}    could not find audit log event of moving object ${objectname}
    Wait Until Element Is Not Visible    id=waitwindow
    Wait Until Element Contains    id=bar${id to}    ${objectname}
    ${bool}=    Get Object Id By Name    ${vault to}    ${objectname}
    Should Be True    ${bool}    no active object with name ${objectname} exists in ${vault to}
    ${bool}=    Objects Should Be Similar    ${vault to}    ${objectname}    ${vault from}    ${objectname}
    Should Be True    ${bool}    object ${objectname} in ${vault from} and ${vault to} does not seem to be similar

Decrypt Object Information
    [Arguments]    ${username}    ${vaultname}    ${objectname}
    Wait Until Element Is Not Visible    waitwindow    10
    Open Vault by Name    ${vaultname}
    ${object id}=    Get Object Id By Name    ${vaultname}    ${objectname}
    Wait Until Page Contains Element    xpath=//*[contains(@id,":${object id}:")]
    Click Element    xpath=//*[contains(@id,":${object id}:")]
    Wait Until Page Contains Element    xpath=//*[contains(@id,":${object id}:")]/span
    ${content}=    Get Text    xpath=//*[contains(@id,":${object id}:")]/span
    Return From Keyword    ${content}
