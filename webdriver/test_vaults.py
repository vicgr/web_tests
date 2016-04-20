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