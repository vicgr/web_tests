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

    def copy_object(page,reporter, username, vault_from,vault_to, objectname):

        #--TODO: for paste object: refactor to reuse code

        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(6, "copy object test", "could not start", "initialization unsuccessful")
            return page

        userid = constants.get_user(username)[2]
        status = constants.db_handler.get_user_by_id(userid).status
        try:
            assert status.has_write() or status.has_admin()
        except AssertionError:
            reporter.add_failure(6, "copy object test",
                                 username + " expected to have admin or write privilege",
                                 "user did not have admin or write privilege")
            return page
        try:
            data_from = vault_tests.read_data(page, vault_from, objectname)
        except:
            data_from = False
        try:
            assert page.copy_object(vault_from, objectname)
        except AssertionError:
            reporter.add_failure(6, "copy object test", "could not find or choose the object "+objectname,"expected to find it")
            return page

        try:
            assert page.paste_object(vault_to)
        except AssertionError:
            reporter.add_failure(6, "copy object test", "could not paste object "+objectname +" to "+ vault_to,"expected to be able to paste")
            return page

        if data_from:
            #if has decryptable info
            try:
                data_to = vault_tests.read_data(page, vault_to, objectname,userid,reporter,[6,"copy object test"])
            except:
                data_to = False
            try:
                assert data_from == data_to
            except AssertionError:
                reporter.add_failure(6, "copy object test","the copied objects encrypted data was not the same as that of the original object",
                                     "expected encrypted data not to have changed")
                return page
        else:
            try:
                assert constants.db_handler.get_new_created_item_in_vault_by_name(objectname,constants.db_handler.get_new_vault_id(vault_to))
            except AssertionError:
                reporter.add_failure(6,"copy object test","expected to find object {} in vault {} in database".format(objectname,vault_to),"could not")
                return page

        try:
            object = constants.get_object(objectname)
            o_id = object[0]
            v_id_f = object[1]
        except KeyError:
            v_id_f = constants.db_handler.get_new_vault_id(vault_from)
            o_id = constants.db_handler.get_new_created_item_in_vault_by_name(objectname, v_id_f)
        v_id_t=constants.db_handler.get_new_vault_id(vault_to)
        try:
            assert constants.db_handler.expect_event_object_copied(userid,v_id_f,o_id,v_id_t)
        except AssertionError:
            reporter.add_failure(6, "copy object test",
                                 "expected to find event COPY OBJECT for {} from {} to {} in audot log".format(
                                     objectname, vault_from, vault_to), "no such log was found")
            return page

        reporter.add_success(6, "copy object test",
                             "correctly copied object {} from {} to {}".format(objectname, vault_from, vault_to))
        return page

    def read_data(page,vaultname,objectname,userid=None,reporter=None,case=None):
        try:
            ob = constants.get_object(objectname)
            o_id=ob[0]
            v_id=ob[1]
        except KeyError:
            v_id = constants.db_handler.get_new_vault_id(vaultname)
            o_id=constants.db_handler.get_new_created_item_in_vault_by_name(objectname,v_id)
        data = page.get_encrypted_data(v_id,o_id)
        if reporter is not None and userid is not None:
            try:
                assert constants.db_handler.expect_event_object_decryption(userid, v_id, o_id)
            except AssertionError:
                reporter.add_failure(case[0],case[1],"expected to find decryption event for object {}".format(objectname),"could not find decryption event")
        return data