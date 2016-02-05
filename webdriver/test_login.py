from pageobjects import page_login
from pageobjects import page_vaults
from selenium import webdriver
import test_reporter
import storedsafe_driver_values as constants
#import web_test

'''
All login-related tests should be handled in this file
'''


class login_test:

    # tests that logging in using wrong credentials do not work
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

    # tests that logging in using correct credentials do work
    def logintest(driver, page, reporter, username, password):
        page = page_login.PageLogin.login_correctly(page, username, password)
        try:
            assert page.verify_on_vaults_page() is True
        except AssertionError:
            reporter.add_failure(2,"logintest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_vault)
            return page

        reporter.add_success(2,"logintest","correct login successful - logged in")
        constants.check_login = True

        return page


    def logout(driver, page,reporter):
        page = page_vaults.PageVaults.logout(page)
        try:
            assert  page.verify_on_login_page() is True
        except AssertionError:
            reporter.add_failure(3,"logouttest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_vault)
            return page
        try:
            driver.get(constants.url_base+constants.url_vault)
            assert page.verify_on_login_page() is True
        except AssertionError:
            reporter.add_failure(3,"logouttest","is at: "+driver.current_url,"expected to not be logged in")
            return page
        reporter.add_success(3, "logouttest","correctly logged out, is at the login page")
        return page

