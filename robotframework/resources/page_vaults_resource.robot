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

*** Keywords ***
verify on vaults page
    location should contain    ${url vaults}
    Page Should Contain Element    ${vault list}

open vault
    [Arguments]    ${vaultname}
    ${vault id}=    Get Vault Id    ${vaultname}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Run Keyword if    '${class}'=='${vault_closed_class}'    Click Element    ${vault bar}${vault id}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Should Be Equal As Strings    ${class}    ${vault_open_class}

close vault
    [Arguments]    ${vaultname}
    ${vault id}=    Get Vault Id    ${vaultname}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Run Keyword Unless    '${class}'=='${vault_open_class}'    Click Element    ${vault bar}${vault id}
    ${class}=    Get Element Attribute    ${vault bar}${vault id}@class
    Should Be Equal As Strings    ${class}    ${vault_closed_class}

New Server Item In Vault
    [Arguments]    ${name of vault}    ${item name}
    open vault    ${name of vault}
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
