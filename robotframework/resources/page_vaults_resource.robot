*** Settings ***
Library           Selenium2Library
Library           storedsafe_robot_lib/storedsafe_lib.py
Resource          storedsafe_url_resources.robot
Resource          page_vault_newitem_resource.robot
Resource          page_vault_newvault_resource.robot
Library           Collections

*** Variables ***
${vault list}     id=objectlistwindow
${vault bar}      bartitle
${vault_open_class}    bars _on
${vault_closed_class}    bars _off
${button copy}    id=copy_
${button move}    id=move_
${button paste}    id=paste_
${button delete}    id=delete_
${id bar}         id=bar
${edit}           edit
${errorwindow}    id=errorwindow
${v_usrs}         users2
${waitwindow}     id=waitwindow
${usr tbl}        id=usertable
${error last admin leave vault}    Last admin cannot be deleted - all object will be lost forever
${btnid}          id=btnid
${checkall}       css=[id^=checkall_
${infowindow}     id=infowindow

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
    Run Keyword If    '${class}'=='${vault_closed_class}'    Wait Until Element Is Not Visible    id=waitwindow
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Should Be Equal As Strings    ${class}    ${vault_open_class}

Close Vault
    [Arguments]    ${vaultname}
    ${vault id}=    Get Vault Id By Name    ${vaultname}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Run Keyword Unless    '${class}'=='${vault_closed_class}'    Click Element    ${vault bar}${vault id}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Should Be Equal As Strings    ${class}    ${vault_closed_class}

New Server Item In Vault
    [Arguments]    ${name of vault}    ${item name}
    Open Vault by Name    ${name of vault}
    ${vault id}=    Get Vault Id By Name    ${name of vault}
    Click Button    bar${vaultid}add
    Wait Until Element Is Visible    ${newitem popup}
    Wait Until Element Is Visible    ${radio server}
    Click Element    ${radio server}
    Click Button    ${newitem continue}${vault id}
    Wait Until Element Is Visible    ${newitem host}
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
    Wait Until Element Is Not Visible    ${newitem popup}

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
    Close Vault    ${vault from}
    Close Vault    ${vault to}
    Open Vault by Id    ${id from}
    Open Vault by Id    ${id to}
    ${object id}=    Get Object Id By Name    ${vault from}    ${objectname}
    ${o type}=    Get Object Type    ${objectname}
    Wait Until Element Is Visible    id=mod_${id from}_${o type}_${object id}
    Select Checkbox    id=mod_${id from}_${o type}_${object id}
    Click Element    ${button copy}${id from}
    Click Element    ${button paste}${id to}
    Confirm Action
    Wait Until Element Is Not Visible    id=waitwindow
    ${userid}=    Get User Id    ${user}
    Wait Until Element Contains    id=bar${id to}    ${objectname}
    ${bool}=    Get Object Id By Name    ${vault to}    ${objectname}
    Should Be True    ${bool}    no active object with name ${objectname} exists in ${vault to}
    ${bool}=    Objects Should Be Similar    ${vault to}    ${objectname}    ${vault from}    ${objectname}
    Should Be True    ${bool}    object ${objectname} in ${vault from} and ${vault to} does not seem to be similar

Decrypt Object Information
    [Arguments]    ${username}    ${vaultname}    ${objectname}
    Wait Until Element Is Not Visible    waitwindow    10
    Open Vault by Name    ${vaultname}
    ${type}=    Get Object Type    ${objectname}
    Return From Keyword If    ${type}==2 or ${type}==3 or ${type}==5 or ${type}==7    ${False}
    ${object id}=    Get Object Id By Name    ${vaultname}    ${objectname}
    Wait Until Page Contains Element    xpath=//*[contains(@id,":${object id}:")]
    Click Element    xpath=//*[contains(@id,":${object id}:")]
    Wait Until Page Contains Element    xpath=//*[contains(@id,":${object id}:")]/span
    ${content}=    Get Text    xpath=//*[contains(@id,":${object id}:")]/span
    Return From Keyword    ${content}

Move Object
    [Arguments]    ${user}    ${vault from}    ${vault to}    ${objectname}
    ${id from}=    Get Vault Id    ${vault from}
    ${id to}=    Get Vault Id By Name    ${vault to}
    ${bool}=    Get Object Id By Name    ${vault from}    ${objectname}
    Should Be True    ${bool}    no active object with name ${objectname} exists in ${vault from}
    Close Vault    ${vault from}
    Close Vault    ${vault to}
    Open Vault by Id    ${id from}
    Open Vault by Id    ${id to}
    ${object id}=    Get Object Id By Name    ${vault from}    ${objectname}
    ${o type}=    Get Object Type    ${objectname}
    Wait Until Element Is Visible    id=mod_${id from}_${o type}_${object id}
    Select Checkbox    id=mod_${id from}_${o type}_${object id}
    Click Element    ${button move}${id from}
    Click Element    ${button paste}${id to}
    Confirm Action
    ${userid}=    Get User Id    ${user}
    ${bool}=    Audit Event Object Moved    ${userid}    ${id from}    ${id to}    ${object id}
    Should Be True    ${bool}    could not find audit log event of moving object ${objectname}
    Wait Until Element Is Not Visible    id=waitwindow    10

Delete Object
    [Arguments]    ${username}    ${vaultname}    ${objectname}
    ${type}=    Get Object Type    ${objectname}
    ${objectid}=    Get Object Id By Name    ${vaultname}    ${objectname}
    ${vaultid}=    Get Vault Id By Name    ${vaultname}
    Open Vault by Id    ${vaultid}
    Wait Until Element Is Not Visible    waitwindow
    Click Element    link-${objectid}
    Run Keyword If    ${type}!='8' and ${type}!='9'    Click Button    editbtn#${objectid}
    Wait Until Element Is Visible    popupwindow
    Click Button    deletebutton
    Confirm Action
    verify on vaults page
    Open Vault by Id    ${vaultid}
    ${userid}=    Get User Id    ${username}
    ${bool}=    Audit Event Object Deleted    ${userid}    ${vaultid}    ${objectname}
    Should Be True    ${bool}

Try to Leave Vault as Last Admin
    [Arguments]    ${username}    ${vaultname}
    ${userid}=    Get User Id    ${username}
    ${vaultid}=    Get Vault Id By Name    ${vaultname}
    ${bool}=    Verify Admin Member Of Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Could not verify that ${username} is an admin level member of ${vaultname}
    ${vaultmems}=    Count members of Vault    ${vaultid}    admin
    Should Be Equal As Integers    ${vaultmems}    1    Could not verify that ${username} is the only admin in ${vaultname}
    ${bool}=    Leave Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Could not verify that the leave-vault function has been completed
    ${bool}=    Verify Admin Member Of Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Could not verify that ${username} is still an admin level member of ${vaultname}
    Should Be Equal As Integers    ${vaultmems}    1    Could not verify that ${username} is still the only admin in ${vaultname}
    ${bool}=    Leave Vault    ${userid}    ${vaultid}
    verify on vaults page
    ${error}=    Get Text    ${errorwindow}
    Should Be Equal    ${error}    ${error last admin leave vault}    The displayed error is missing, or not correct

Leave Vault
    [Arguments]    ${userid}    ${vaultid}
    Open Vault by Id    ${vaultid}
    Click Button    ${id bar}${vaultid}${v_usrs}
    Wait Until Element Is Visible    ${usr tbl}
    Click Button    ${btnid}${userid}
    Confirm Action
    Wait Until Element Is Not Visible    ${waitwindow}
    Return From Keyword    ${True}

Empty Vault
    [Arguments]    ${username}    ${vaultname}
    [Documentation]    Deletes all objects in a vault and verifies that they have been deleted (if any)
    ${userid}=    Get User Id    ${username}
    ${vaultid}=    Get Vault Id By Name    ${vaultname}
    @{objlist}=    Get Active Objects In Vault    ${vaultid}
    Run Keyword Unless    ${objlist}==${False}    Delete all Objects in Vault    ${vaultid}
    : FOR    ${object}    IN    @{objlist}
    \    ${name}=    Get From List    ${object}    1
    \    Audit Event Object Deleted    ${userid}    ${vaultid}    ${name}

Delete all Objects in Vault
    [Arguments]    ${vaultid}
    [Documentation]    Deletes all objects in the vault with the provided id.
    ...    Opens it, checks the boxes and clicks the delete button.
    ...    Accepts the alert.
    ...    Returns true
    Open Vault by Id    ${vaultid}
    Wait Until Element Is Not Visible    ${waitwindow}
    @{checkboxes}=    Get Webelements    ${checkall}${vaultid}]
    : FOR    ${box}    IN    @{checkboxes}
    \    Select Checkbox    ${box}
    Click Element    ${button delete}${vaultid}
    Confirm Action
