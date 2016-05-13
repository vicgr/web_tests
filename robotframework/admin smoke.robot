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
test1
    [Setup]    open browser    ${url base}
    verify on login page
    login to storedsafe    test_admin
    is logged in as    test_admin
    verify on vaults page
    logout user from storedsafe    test_admin
    verify on login page
    [Teardown]

test2
    [Documentation]    ${v}= verify object in vault v_test_vault_1 v_test_object_2
    [Setup]    open browser    ${url base}
    login to storedsafe    test_admin
    ${v}=    verify member of vault    test_admin    v_test_vault_1
    Should Be True    ${v}
    Open Vault    v_test_vault_1
    New Server Item In Vault    v_test_vault_1    v_test_object_2
    ${v}=    get object id by name    v_test_vault_1    v_test_object_2
    Should Be True    ${v}
    audit log object created    test_admin    v_test_vault_1    v_test_object_2

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
    [Teardown]    close browser

copy object
    [Setup]    open browser    ${url base}    browser=gc
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
    [Setup]    open browser    ${url base}    browser=gc
    login to storedsafe    test_admin
    Move Object    test_admin    v_test_vault_1    v_test_vault_2    v_test_object_2

delete object
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    Delete Object    test_admin    v_test_vault_2    v_test_object_2

try to delete nonempty vault
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    Try to Delete non-empty Vault    test_admin    v_test_vault_2

try to leave vault as last admin
    [Documentation]    open browser | ${url base} | browser=ff
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
    Try to Leave Vault as Last Admin    test_admin    v_test_vault_2

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

lll
    [Setup]    open browser    ${url base}    browser=ff
    login to storedsafe    test_admin
