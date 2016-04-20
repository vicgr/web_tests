*** Settings ***
Library           Selenium2Library
Library           storedsafe_robot_lib/storedsafe_lib.py
Resource          page_login_resource.robot

*** Variables ***
${logout button}    id=logouttop
${bragwindow}     id=bragwindow
${userimg}        img/ico/user/user.png

*** Keywords ***
is logged in
    page should contain button    ${logout button}
    Page Should Contain Image    ${userimg}

is logged in as
    [Arguments]    ${username}
    is logged in
    ${user full name}=    Get User Fullname    ${username}
    Page Should Contain    ${user full name}

logout user from storedsafe
    [Arguments]    ${username}
    [Documentation]    Logs out from storedsafe. Requires the username in order to verify that the logout event is logged in the database
    Click Button    ${logout button}
    Confirm Action
    Audit Event Logout    ${username}
