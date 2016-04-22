from pageobjects import page_vaults
import storedsafe_driver_values as constants

class vault_tests:

    def create_new_server_item(driver, page, reporter, username, vaultname, itemname):

        userid = constants.get_user(username)[2]
        vaultid = constants.get_vaultsid(vaultname)
        try:
            vault_tests.new_item_commons(page, reporter,username,vaultname)
        except AssertionError:
            return page

        #read itemdata from constants
        newitem = constants.get_newitem_server(itemname)

        try:
            assert page.create_new_item_server(vaultname,itemname,newitem)
        except:
            reporter.add_failure(10, "create new item test", "expected to create a new item", "item creation failed")
            return page

        i_id=constants.db_handler.get_new_created_item_in_vault_by_name(itemname, vaultid)

        try:
            assert constants.db_handler.expect_event_item_created(userid,i_id,vaultid)
        except:
            reporter.add_failure(10, "create new item test", "expected that creation of object "+itemname +" would be logged","objectcreation was not logged")
            return page


        reporter.add_success(10,"create new item test","object "+ itemname+ "created successfully")
        return page

    def open_vault(page, vaultname):
        page.open_vault(vaultname)


    def new_item_commons(page, reporter, username, vaultname):
        userid = constants.get_user(username)[2]
        vaultid = constants.get_vaultsid(vaultname)
        constants.db_handler.reset_time()
        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(10, "create new item test", "could not start", "initialization unsuccessful")
            raise AssertionError

        status = None
        try:
            status = constants.db_handler.get_user_vault_membership(userid, vaultid)
        except:
            reporter.add_failure(10, "create new item test",
                                 "expected user " + username + " to be a member of vault " + vaultname,
                                 "user was not a member of vault")
            raise AssertionError
        try:
            assert status.has_write() or status.has_admin()
        except AssertionError:
            reporter.add_failure(10, "create new item test",
                                 "expected user " + username + " to have read or write privileges in " + vaultname,
                                 "user did not have the correct privileges")
            raise AssertionError


    def create_new_vault(page, reporter, username,vaultname):
        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(9, "create new vault test","could not start", "initialization unsuccessful")
            return page
        userid = constants.get_user(username)[2]
        status = constants.db_handler.get_user_by_id(userid).status
        try:
            assert status.has_write() or status.has_admin()
        except AssertionError:
            reporter.add_failure(9, "create new vault test",
                                 username + " expected to have admin or write privilege",
                                 "user did not have admin or write privilege")
            return page

        try:
            assert page.create_new_vault(vaultname)
        except AssertionError:
            reporter.add_failure(9,"create new vault test","could not create new vault","expected new vault to be created")
            return page
        try:
            page = page_vaults.PageVaults(page.driver)
            assert page.open_new_vault(vaultname)
        except:
            reporter.add_failure(9, "create new vault test",
                                 "vault " + vaultname + " does not appear to be in the list of vaults",
                                 "expected " + vaultname + " to be in the list of vaults")
            return page
        try:
            assert constants.db_handler.expect_event_vault_created(userid,vaultname)
        except:
            reporter.add_failure(9, "create new vault test","no audit log vault creation event for creation of "+vaultname,"expected one to exist in audit log")
            return page

        reporter.add_success(9,"create new vault test","vault "+vaultname+" created as expected")
        return page