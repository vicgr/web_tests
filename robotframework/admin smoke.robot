*** Settings ***
Documentation     A smoke test suite for testing vault and object operations for admin users
Suite Teardown
Resource          Resources/page_login_resource.robot
Resource          Resources/page_vaults_resource.robot
Resource          Resources/page_logged_in_resource.robot
Library           OperatingSystem
Resource          resources/storedsafe_audit_resource.robot
Resource          resources/page_vault_newvault_resource.robot
Resource          Resources/page_vault_newitem_resource.robot
Resource          Resources/page_vault_delete_vault_resource.robot

*** Variables ***

*** Test Cases ***
login logout test
    [Setup]    open browser    ${url base}    browser=gc
    verify on login page
    login to storedsafe    test_admin
    is logged in as    test_admin
    verify on vaults page
    [Teardown]    close browser

test open browsers
    Open Browser    ${url base}    browser=gc
    close browser
    Open Browser    ${url base}    browser=ie
    close browser

create vault test
    [Setup]    open browser    ${url base}
    login to storedsafe    test_admin
    verify on vaults page
    create vault    test_admin    v_test_vault_2
    ${bool}=    Audit Event Vault Created    test_admin    v_test_vault_2
    [Teardown]    close browser

Create object in vault test
    [Setup]    open browser    ${url base}
    login to storedsafe    test_admin
    ${userid}=    Get User Id    test_admin
    ${vaultid}=    Get Vault Id By Name    v_test_vault_2
    ${v}=    verify member of vault    ${userid}    ${vaultid}
    Should Be True    ${v}
    Open Vault by Name    v_test_vault_2
    New Server Item In Vault    v_test_vault_2    v_test_object_2
    Wait Until Page Contains    v_test_object_2
    ${v}=    get object id by name    v_test_vault_2    v_test_object_2
    Should Be True    ${v}
    audit log object created    test_admin    v_test_vault_2    v_test_object_2
    [Teardown]    close browser

copy object
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    ${cont1}=    Decrypt Object Information    test_admin    v_test_vault_1    v_test_object_1.pdf
    audit log object decrypted    test_admin    v_test_vault_1    v_test_object_1.pdf
    Copy Object    test_admin    v_test_vault_1    v_test_vault_2    v_test_object_1.pdf
    audit log object copied    test_admin    v_test_vault_1    v_test_vault_2    v_test_object_1.pdf
    ${cont2}=    Decrypt Object Information    test_admin    v_test_vault_2    v_test_object_1.pdf
    audit log object decrypted    test_admin    v_test_vault_2    v_test_object_1.pdf
    Should Be Equal As Strings    ${cont1}    ${cont2}    Encrypted information of copied objects has changed
    [Teardown]    close browser

move object
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    Move Object    test_admin    v_test_vault_1    v_test_vault_2    v_test_object_2
    [Teardown]

delete object
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    Delete Object    test_admin    v_test_vault_2    v_test_object_2
    [Teardown]

try to delete nonempty vault
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    Try to Delete non-empty Vault    test_admin    v_test_vault_2
    [Teardown]    close browser

try to leave vault as last admin
    [Documentation]    open browser | ${url base} | browser=ff
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    Try to Leave Vault as Last Admin    test_admin    v_test_vault_2
    [Teardown]

Delete Vault With Content
    [Setup]    open browser    ${url base}    browser=ff
    #login
    login to storedsafe    test_admin
    #verify login
    #Verify admin member of vault
    #get number of objects in vault
    #if nr>0, run delete all objects
    #..verify object deletion
    Empty Vault    test_admin    v_test_vault_2
    #delete vault
    Delete Empty Vault    test_admin    v_test_vault_2
    #verify vault deletion
    audit log vault deleted    test_admin    v_test_vault_2
    [Teardown]

read encrypted info
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    ${val}=    Decrypt Object Information    test_admin    v_test_vault_2    v_test_object_2
    Should Be Equal    ${val}    JgKU36[:g,7EmWW3gbOR
    audit log object decrypted    test_admin    v_test_vault_2    v_test_object_2

copy object with decryption
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    ${cont1}=    Decrypt Object Information    test_admin    v_test_vault_2    v_test_object_2
    audit log object decrypted    test_admin    v_test_vault_2    v_test_object_2
    Copy Object    test_admin    v_test_vault_2    v_test_vault_1    v_test_object_2
    audit log object copied    test_admin    v_test_vault_2    v_test_vault_1    v_test_object_2
    ${cont2}=    Decrypt Object Information    test_admin    v_test_vault_1    v_test_object_2
    audit log object decrypted    test_admin    v_test_vault_1    v_test_object_2
    Should Be Equal As Strings    ${cont1}    ${cont2}    Encrypted information of copied objects has changed

move object with decryption
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    ${cont1}=    Decrypt Object Information    test_admin    v_test_vault_1    v_test_object_2
    audit log object decrypted    test_admin    v_test_vault_1    v_test_object_2
    Move Object    test_admin    v_test_vault_1    v_test_vault_2    v_test_object_2
    ${cont2}=    Decrypt Object Information    test_admin    v_test_vault_2    v_test_object_2
    audit log object decrypted    test_admin    v_test_vault_2    v_test_object_2
    Should Be Equal As Strings    ${cont1}    ${cont2}    Encrypted information of copied objects has changed
