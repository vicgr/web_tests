*** Settings ***
Library           Selenium2Library
Library           storedsafe_robot_lib/storedsafe_lib.py
Resource          storedsafe_url_resources.robot

*** Variables ***
${username field}    id=username
${password field}    id=keys
${login button}    id=savebutton

*** Keywords ***
verify on login page
    Go To    ${url index}
    Location Should Be    ${url index}
    Page should contain element    ${username field}
    page should contain element    ${password field}
    page should contain button    ${login button}

login to storedsafe
    [Arguments]    ${username}
    ${keys}=    Get User Keys    ${username}
    Input Text    ${username field}    ${username}
    Input Password    ${password field}    ${keys}
    Click Button    ${login button}

fail login to stored safe
