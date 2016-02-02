"from web_test import WebTest"
from pageobjects import page_login
from selenium import webdriver
import sys
import os
import test_reporter


check_login_fail= False
check_login = False

def test_login():
#    test_ff()
    test_ch()
    end_tests()

def test_ff():
    driver = webdriver.Firefox()
    reporter.log_webdriver("firefox")
    test(driver)
    driver.close()

def test_ch():
    chrome_path = "/Users/Victor/works/storedsafe_webtests/chromedriver"
    driver = webdriver.Chrome(executable_path=chrome_path)
    reporter.log_webdriver("chrome")
    test(driver)
    driver.close()


def test(driver):

    #driver = webdriver.Firefox()
    driver.get("https://t1.storedsafe.com/")
    page = loginfailtest(driver,page_login.PageLogin(driver), "a", "b")
    if not check_login_fail:
        return
    u= str(input('username: '))
    p= str(input('password+yubikey: '))
    page = logintest(driver,page,u,p)
    if not check_login:
        return


def loginfailtest(driver, page, username, password):
    page = page_login.PageLogin.login_incorrectly(page, username, password)
    try:
        assert str(driver.current_url) == 'https://t1.storedsafe.com/'
    except AssertionError:
        reporter.add_failure(1,"loginfailuretest","is at: "+driver.current_url,"expected to be at: https://t1.storedsafe.com/")
        return page
    reporter.add_success(1,"loginfailuretest","did not login")
    global check_login_fail
    check_login_fail= True
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

def end_tests():
    reporter.printreport()

reporter = test_reporter.testreporter()
test_login()
#test_2()


