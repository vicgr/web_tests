#!python3

from pageobjects import page_login
from pageobjects import page_vaults
import storedsafe_driver_values as constants

'''
All login-related tests should be handled in this file
'''

class login_test:

    # tests that logging in using wrong credentials do not work
    def loginfailtest(driver, page, reporter, username, password):
        constants.db_handler.reset_time()

        if type(page) != page_login.PageLogin:
            print ("Error: expected a page Login object, recieved a " +str(type(page)))
            reporter.add_failure(1,"loginfailtest","could not start","initialization unsuccessful")
            return page

        page = page_login.PageLogin.login_incorrectly(page, username, password)

        try:
            assert page.verify_on_login_page() is True
        except AssertionError:
            reporter.add_failure(1,"loginfailuretest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_login)
            return page

        try:
            assert constants.db_handler.expect_event_auth_failure()
        except AssertionError:
            reporter.add_failure(1,"loginfailuretest","no auth failure event found in log","expected an auth failure event")
            return page

        reporter.add_success(1,"loginfailuretest","did not login")
        constants.check_login_fail= True
        return page

    # tests that logging in using correct credentials do work
    def logintest(driver, page, reporter, username, id_access=True):
        constants.db_handler.reset_time()

        if not username in constants.userlogins:
            reporter.add_failure(3, "logintest", "could not start", "file did not contain expeced user info for user "+username)
            return page

        if type(page) != page_login.PageLogin:
            print("expected a pageLogin object, recieved a " + str(type(page)))
            reporter.add_failure(3,"logintest","could not start","initialization unsuccessful")
            return page


        userinfo = constants.userlogins[username]

        try:
            if id_access:
                assert constants.db_handler.get_user_by_id(userinfo[2]).status.is_active()
            else:
                assert constants.db_handler.active_user_with_username(username) == True
        except:
            if id_access:
                reporter.add_failure(2, "logintest", "no active user with id" + userinfo[2] + "in database",
                                     "user expected to exist in the database")
            else:
                reporter.add_failure(2, "logintest", "no active user with username" + username + "in database",
                                     "user expected to exist in the database")
            return page

        try:
            page = page_login.PageLogin.login_correctly(page, username, userinfo[0]+userinfo[1])
        except Exception as E:
            reporter.add_failure(2,"logintest","failed to load page object: "+E.args[0],"expected to load page object")
            return page

        try:
            assert page.verify_on_vaults_page() is True
        except AssertionError:
            reporter.add_failure(2,"logintest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_vault)
            return page

        try:
            assert constants.db_handler.expect_event_login_by_username(username)
        except AssertionError:
            reporter.add_failure(2,"logintest","no loginevent-found for "+username,"expected a login-event in the log")
            return page
        if id_access:
            try:
                assert constants.db_handler.expect_event_login_by_id(userinfo[2])
            except AssertionError:
                reporter.add_failure(2,"logintest","no loginevent-found for userid "+userinfo[2],"expected a login-event in the log")
                return page

        reporter.add_success(2,"logintest","correct login successful - logged in")
        constants.check_login = True

        return page


    def logout(driver, page,reporter, username):
        constants.db_handler.reset_time()

        if type(page) != page_vaults.PageVaults:
            print("Error: not a Vault-page object, recived a " +str(type(page)))
            reporter.add_failure(3,"logouttest","could not start","initialization unsuccessful")
            return page

        page = page_vaults.PageVaults.logout(page)

        try:
            assert  page.verify_on_login_page() is True
        except AssertionError:
            reporter.add_failure(3,"logouttest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_vault)
            return page
        try:
            assert page.verify_on_login_page() is True
        except AssertionError:
            reporter.add_failure(3,"logouttest","is at: "+driver.current_url,"expected to not be logged in")
            return page
        try:
            #assert len(constants.db_handler.expect_event_logout(user[0])) >0
            assert len (constants.db_handler.expect_event_logout_by_id(constants.userlogins[username][2])) >0
        except AssertionError:
            reporter.add_failure(3,"logouttest","no logout-event found for "+username,"expected logout-event in the log")
            return page

        reporter.add_success(3, "logouttest","correctly logged out, is at the login page")
        return page

