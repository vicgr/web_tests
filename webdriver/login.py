"from web_test import WebTest"
from pageobjects import page_login
from selenium import webdriver
import sys


def test():
    driver = webdriver.Firefox()
    driver.get("https://t1.storedsafe.com/")
    page = loginfailtest(driver,page_login.PageLogin(driver), "a", "b")
    u= str(input('username: '))
    p= str(input('password+yubikey: '))
    page = logintest(driver,page,u,p)


def loginfailtest(driver, page, username, password):
    page = page_login.PageLogin.login_incorrectly(page, username, password)
    try:
        assert str(driver.current_url) == 'https://t1.storedsafe.com/'
    except AssertionError:
        print 'Test failed: expected to reach login page. Is at '+driver.current_url
        exit(1)

    print("test successful: incorrect login failed")
    return page


def logintest(driver, page, username,password):
    page = page_login.PageLogin.login_correctly(page, username, password)
    try:
        assert str(driver.current_url).startswith('https://t1.storedsafe.com/groups.php')
    except AssertionError:
        print 'Test failed: expected to reach vaultpage. Is at '+driver.current_url
        print 'Could not login, exiting'
        exit(1)
    print("test successful: logged in")
    return page


test()


