*** Settings ***
Documentation     A test suite with a single test for valid login.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Suite Teardown
Resource          Resources/page_login_resource.robot
Resource          Resources/page_vaults_resource.robot
Resource          Resources/page_logged_in_resource.robot
Library           OperatingSystem
Resource          resources/storedsafe_audit_resource.robot
Resource          resources/page_vault_newvault_resource.robot

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
    open vault    v_test_vault_1
    New Server Item In Vault    v_test_vault_1    v_test_object_2
    ${v}=    get object id by name    v_test_vault_1    v_test_object_2
    Should Be True    ${v}
    audit log object created    test_admin    v_test_vault_1    v_test_object_2

test open browsers
    Open Browser    ${url base}    browser=gc
    close browser
    Open Browser    ${url base}    browser=ie
    close browser

test 3
    [Setup]    open browser    ${url base}
    login to storedsafe    test_admin
    verify on vaults page
    create vault    test_admin    v_test_vault_2
