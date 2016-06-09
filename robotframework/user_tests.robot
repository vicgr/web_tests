*** Settings ***
Library           Selenium2Library
Library           resources/storedsafe_robot_lib/storedsafe_lib.py

*** Test Cases ***
user login logout test
    [Setup]
    Open Browser    https://t1.storedsafe.com/    browser=gc
    ${keys}=    Get User Keys    test_admin
    Input Text    id=uname    test_admin
