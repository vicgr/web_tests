*** Settings ***
Library           Selenium2Library
Library           storedsafe_robot_lib/storedsafe_lib.py
Resource          storedsafe_url_resources.robot

*** Variables ***
${vault list}     id=objectlistwindow

*** Keywords ***
verify on vaults page
    location should contain    ${url vaults}
    Page Should Contain Element    ${vault list}
