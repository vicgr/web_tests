*** Settings ***
Library           storedsafe_robot_lib/storedsafe_lib.py
Library           Selenium2Library
Resource          page_vaults_resource.robot

*** Variables ***
${edit vault popup}    id=popupwindow
${button delete vault}    id=deletebutton
${error delete non empty vault}    Vault cannot be deleted with active items
${vault deleted msg}    Vault deleted

*** Keywords ***
Delete Vault
    [Arguments]    ${userid}    ${vaultid}
    [Documentation]    Tries to go through the process of trying to delete a vault.
    ...    Verifies that the user has the right privilegies.
    ...    Does not verify that the vault is deleted or not, only that the actions of vault deletion are done.
    verify on vaults page
    ${bool}=    Verify Admin Member of Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Expected user to be an admin member of vault, but could not verify this.
    Open Vault by Id    ${vaultid}
    Click Button    ${id bar}${vaultid}${edit}
    Wait Until Element Is Visible    ${edit vault popup}
    Wait Until Element Is Visible    ${button delete vault}
    Click Button    ${button delete vault}
    Confirm Action
    verify on vaults page
    Return From Keyword    ${True}

Try to Delete non-empty Vault
    [Arguments]    ${username}    ${vaultname}
    [Documentation]    Tries to delete a vault that is not empty.
    ...    Verifys that the vault has not been deleted at the end.
    ${userid}=    Get User Id    ${username}
    ${vaultid}=    Get Vault Id By Name    ${vaultname}
    Should Be True    ${userid}    Could not find the user ${username} in the database
    Should Be True    ${vaultid}    Could not find the vault ${vaultname} in the database
    ${bool}=    Verify Member Of Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Expected ${username} to be a member of ${vaultname} but could not verify this.
    ${bool}=    Count Objects In Vault    ${vaultid}
    Should Be True    ${bool}    Expected vault to not be empty, but found no objects in it.
    ${bool}=    Delete Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Could not perform the delete vault function
    ${bool}=    Get Vault Id By Name    ${vaultname}
    Should Be True    ${bool}    Expected ${vaultname} to be active. Could not verify this.
    ${bool}=    Verify admin Member Of Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Could not verify that ${username} still was an admin level member of ${vaultname}
    ${error}=    Get Text    ${errorwindow}
    Should Be Equal    ${error}    ${error delete non empty vault}

Delete Empty Vault
    [Arguments]    ${username}    ${vaultname}
    ${userid}=    Get User Id    ${username}
    ${vaultid}=    Get Vault Id By Name    ${vaultname}
    ${bool}=    Verify Member Of Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Expected ${username} to be a member of ${vaultname} but could not verify this.
    ${bool}=    Count Objects In Vault    ${vaultid}
    Should Not Be True    ${bool}    Expected vault to be empty, but found objects in it.
    ${bool}=    Delete Vault    ${userid}    ${vaultid}
    Should Be True    ${bool}    Could not perform the delete vault function
    #verify vault no longer active?
    ${text}=    Get Text    ${infowindow}
    Should Contain    ${text}    ${vault deleted msg}
