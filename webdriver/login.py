"from web_test import WebTest"
from pageobjects import page_login
from selenium import webdriver
import sys
import test_reporter


def test():
    driver = webdriver.Firefox()
    driver.get("https://t1.storedsafe.com/")
    page = loginfailtest(driver,page_login.PageLogin(driver), "a", "b")
    u= str(input('username: '))
    p= str(input('password+yubikey: '))
    page = logintest(driver,page,u,p)
    reporter.printreport()

def loginfailtest(driver, page, username, password):
    page = page_login.PageLogin.login_incorrectly(page, username, password)
    try:
        assert str(driver.current_url) == 'https://t1.storedsafe.com/'
    except AssertionError:
        reporter.add_failure(1,"loginfailuretest","is at: "+driver.current_url,"expected to be at: https://t1.storedsafe.com/")
        #print ('Test failed: expected to reach login page. Is at '+driver.current_url)
        return page
    #print("test successful: incorrect login failed")
    reporter.add_success(1,"loginfailuretest","did not login")
    return page


def logintest(driver, page, username,password):
    page = page_login.PageLogin.login_correctly(page, username, password)
    try:
        assert str(driver.current_url).startswith('https://t1.storedsafe.com/groups.php')
    except AssertionError:
        reporter.add_failure(2,"logintest","is at: "+driver.current_url,"expected to be at: https://t1.storedsafe.com/groups.php")
        #print('Test failed: expected to reach vaultpage. Is at '+driver.current_url)
        #print ('Could not login, exiting')
        return page

    reporter.add_success(2,"logintest","correct login successful - logged in")

    #print("test successful: logged in")
    check_login = True

    return page

reporter = test_reporter.testreporter()
check_login = False

test()


