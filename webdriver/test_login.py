from pageobjects import page_login
from selenium import webdriver
import test_reporter
import storedsafe_driver_values as constants
#import web_test

'''
All login-related tests should be handled in this file
'''

class login_test:
    def loginfailtest(driver, page, reporter, username, password):
        page = page_login.PageLogin.login_incorrectly(page, username, password)
        try:
            assert page.verify_on_login_page() is True
        except AssertionError:
            reporter.add_failure(1,"loginfailuretest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_login)
            return page
        reporter.add_success(1,"loginfailuretest","did not login")
        constants.check_login_fail= True
        return page


    def logintest(driver, page, reporter, username, password):
        page = page_login.PageLogin.login_correctly(page, username, password)
        try:
            #assert str(driver.current_url).startswith('https://t1.storedsafe.com/groups.php')
            assert page.verify_on_vaults_page() is True
        except AssertionError:
            reporter.add_failure(2,"logintest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_vault)
            return page

        reporter.add_success(2,"logintest","correct login successful - logged in")
        constants.check_login = True

        return page


