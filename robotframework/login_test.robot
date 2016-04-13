*** Settings ***
Documentation     A test suite with a single test for valid login.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Suite Teardown
Resource          Resources/page_login_resource.robot
Resource          Resources/page_vaults_resource.robot
Resource          Resources/page_logged_in_resource.robot

*** Test Cases ***
test1
    [Setup]    open browser    ${url base}
    verify on login page
    login to storedsafe    test_admin
    is logged in as    test_admin
    verify on vaults page
    [Teardown]
