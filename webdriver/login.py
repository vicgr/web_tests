"from web_test import WebTest"
from pageobjects import page_login
from selenium import webdriver
import sys
import test_reporter


check_loginfail= False
check_login = False

def test():

    driver = webdriver.Firefox()
    driver.get("https://t1.storedsafe.com/")
    page = loginfailtest(driver,page_login.PageLogin(driver), "a", "b")
    if not check_loginfail:
        end_Tests()
        exit(1)
    u= str(input('username: '))
    p= str(input('password+yubikey: '))
    page = logintest(driver,page,u,p)
    if not check_login:
        end_Tests()
        exit(1)

    print(check_loginfail +""+check_login)
    end_Tests()


def loginfailtest(driver, page, username, password):
    page = page_login.PageLogin.login_incorrectly(page, username, password)
    try:
        assert str(driver.current_url) == 'https://t1.storedsafe.com/'
    except AssertionError:
        reporter.add_failure(1,"loginfailuretest","is at: "+driver.current_url,"expected to be at: https://t1.storedsafe.com/")
        return page
    reporter.add_success(1,"loginfailuretest","did not login")
    global check_loginfail
    check_loginfail= True
    return page


def logintest(driver, page, username,password):
    page = page_login.PageLogin.login_correctly(page, username, password)
    try:
        assert str(driver.current_url).startswith('https://t1.storedsafe.com/groups.php')
    except AssertionError:
        reporter.add_failure(2,"logintest","is at: "+driver.current_url,"expected to be at: https://t1.storedsafe.com/groups.php")
        return page

    reporter.add_success(2,"logintest","correct login successful - logged in")
    global check_login
    check_login = True

    return page

def end_Tests():
    reporter.printreport()

reporter = test_reporter.testreporter()

test()


