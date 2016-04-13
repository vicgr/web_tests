*** Settings ***
Library           Selenium2Library
Library           storedsafe_robot_lib/storedsafe_lib.py

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
