from dns.hash import get

from pageobjects import page_vaults
import storedsafe_driver_values as constants


class vault_tests:

    def create_new_server_item(page, reporter, username, vaultname, itemname):

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
            reporter.add_failure(10, "create new object test", "expected to create a new item", "item creation failed")
            return page

        i_id=constants.db_handler.get_new_created_item_in_vault_by_name(itemname, vaultid)

        try:
            assert constants.db_handler.expect_event_item_created(userid,i_id,vaultid)
        except:
            reporter.add_failure(10, "create new object test", "expected that creation of object "+itemname +" would be logged","objectcreation was not logged")
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

        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(10, "copy object test", "could not start", "initialization unsuccessful")
            return page

        userid = constants.get_user(username)[2]
        status = constants.db_handler.get_user_by_id(userid).status
        try:
            assert status.has_write() or status.has_admin()
        except AssertionError:
            reporter.add_failure(10, "copy object test",
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
            reporter.add_failure(10, "copy object test", "could not find or choose the object "+objectname,"expected to find it")
            return page

        try:
            assert page.paste_object(vault_to)
        except AssertionError:
            reporter.add_failure(10, "copy object test", "could not paste object "+objectname +" to "+ vault_to,"expected to be able to paste")
            return page

        if data_from: #if has decryptable info
            try:
                data_to = vault_tests.read_data(page, vault_to, objectname,userid,reporter,[6,"copy object test"])
            except:
                data_to = False
            try:
                if data_to:
                    assert data_from == data_to
            except AssertionError:
                reporter.add_failure(10, "copy object test","the copied objects encrypted data was not the same as that of the original object",
                                     "expected encrypted data not to have changed")
                return page
        else:
            try:
                assert constants.db_handler.get_new_created_item_in_vault_by_name(objectname,constants.db_handler.get_new_vault_id(vault_to))
            except AssertionError:
                reporter.add_failure(10,"copy object test","expected to find object {} in vault {} in database".format(objectname,vault_to),"could not")
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
            reporter.add_failure(10, "copy object test",
                                 "expected to find event COPY OBJECT for {} from {} to {} in audot log".format(
                                     objectname, vault_from, vault_to), "no such log was found")
            return page

        reporter.add_success(10, "copy object test",
                             "correctly copied object {} from {} to {}".format(objectname, vault_from, vault_to))
        return page

    def move_object(page,reporter, username, vault_from,vault_to, objectname):
        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(15, "move object test", "could not start", "initialization unsuccessful")
            return page

        userid = constants.get_user(username)[2]
        status = constants.db_handler.get_user_by_id(userid).status
        try:
            assert status.has_write() or status.has_admin()
        except AssertionError:
            reporter.add_failure(15, "move object test",
                                 username + " expected to have admin or write privilege",
                                 "user did not have admin or write privilege")
            return page
        try:
            data_from = vault_tests.read_data(page, vault_from, objectname)
        except:
            data_from = False
        try:
            assert page.move_object(vault_from, objectname)
        except AssertionError:
            reporter.add_failure(15, "move object test", "could not find or choose the object " + objectname,
                                 "expected to find it")
            return page

        try:
            assert page.paste_object(vault_to)
        except AssertionError:
            reporter.add_failure(15, "move object test", "could not paste object " + objectname + " to " + vault_to,
                                 "expected to be able to paste")
            return page
        page.close_vault(vault_from)
        page.close_vault(vault_to)
        page.open_vault(vault_to)


        if data_from:  # if has decryptable info
            try:
                data_to = vault_tests.read_data(page, vault_to, objectname, userid, reporter, [15, "move object test"])
            except:
                data_to = False
            try:
                if data_to:
                    assert data_from == data_to
            except AssertionError:
                reporter.add_failure(15, "move object test",
                                     "the copied objects encrypted data was not the same as that of the original object",
                                     "expected encrypted data not to have changed")
                return page
        else:
            try:
                assert constants.db_handler.get_new_created_item_in_vault_by_name(objectname,
                                                                                  constants.db_handler.get_new_vault_id(
                                                                                      vault_to))
            except AssertionError:
                reporter.add_failure(15, "move object test",
                                     "expected to find object {} in vault {} in database".format(objectname, vault_to),
                                     "could not")
                return page
        try:
            object = constants.get_object(objectname)
            #o_id = object[0]
            v_id_f = object[1]
        except KeyError:
            v_id_f = constants.db_handler.get_new_vault_id(vault_from)
        v_id_t = constants.db_handler.get_new_vault_id(vault_to)
        o_id = constants.db_handler.get_new_created_item_in_vault_by_name(objectname, v_id_t)
        try:
            assert constants.db_handler.expect_event_object_moved(userid, v_id_f, o_id, v_id_t)
        except AssertionError:
            reporter.add_failure(15, "move object test",
                                 "expected to find event MOVED OBJECT for {} from {} to {} in audit log".format(
                                     objectname, vault_from, vault_to), "no such log was found")
            return page

        reporter.add_success(15, "move object test",
                             "correctly moved object {} from {} to {}".format(objectname, vault_from, vault_to))
        return page



    def read_data(page,vaultname,objectname,userid=None,reporter=None,case=None):
        try:
            ob = constants.get_object(objectname)
            o_id=ob[0]
            v_id=ob[1]
        except KeyError:
            v_id = constants.db_handler.get_new_vault_id(vaultname)
            o_id=constants.db_handler.get_new_created_item_in_vault_by_name(objectname,v_id)
        print("v:{}, o:{}".format(v_id,o_id))
        data = page.get_encrypted_data(v_id,o_id)
        if reporter is not None and userid is not None:
            try:
                assert constants.db_handler.expect_event_object_decryption(userid, v_id, o_id)
            except AssertionError:
                reporter.add_failure(case[0],case[1],"expected to find decryption event for object {}".format(objectname),"could not find decryption event")
        return data

    def delete_object(page,reporter,user,vaultname,objectname):
        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(17, "delete object test", "could not start, not on the vaults page", "initialization unsuccessful")
            return page
        try:
            assert page.open_vault(vaultname)
        except AssertionError:
            reporter.add_failure(17, "delete object test","tried to open vault {}".format(vaultname), "could not find vault {} in list of vaults".format(vaultname))
            return page

        try:
            userid = constants.get_user(user)[2]
            objecttype = constants.get_object_type(objectname)
        except KeyError:
            reporter.add_failure(17, "delete object test","could not find user {} or object type of {} from file".format(user,objectname),"verify that these are entered correctly")
            return page
        try:
            ob = constants.get_object(objectname)
            objectid = ob[0]
            vaultid = ob[1]
        except KeyError:
            vaultid = constants.db_handler.get_new_vault_id(vaultname)
            objectid = constants.db_handler.get_new_created_item_in_vault_by_name(objectname, vaultid)

        try:
            assert page.delete_object(vaultid,objectid,objecttype)
        except AssertionError:
            reporter.add_failure(17, "delete object test", "could not delete object {} in vault {}".format(objectname,vaultname), "expected to be able to do this as user {}".format((user)))
            return page
        try:
            assert constants.db_handler.expect_event_object_deleted(userid,vaultid,objectid,objectname)
        except AssertionError:
            reporter.add_failure(17, "delete object test","expected an delete-event for object {} in vault {}".format(objectname,vaultname),"could not find such an event")
        reporter.add_success(17, "delete object test","correcylt deleted object {} in vault".format(objectname,vaultname))
        return page

    def try_delete_non_empty_vault(page,reporter,username,vaultname):
        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(20, "try to delete non-empty vault", "could not start, not on the vaults page",
                                 "initialization unsuccessful")
            return page
        try:
            userid = constants.get_user(username)[2]
            vaultid = constants.db_handler.get_new_vault_id(vaultname)
        except:
            reporter.add_failure(20,"try to delete non-empty vault","could not find id:s for user {} or vault {}".format(username,vaultname),"verify that these are correct")
            return page
        try:
            status = constants.db_handler.get_user_vault_membership(userid,vaultid)
            assert status
        except AssertionError:
            reporter.add_failure(20, "try to delete non-empty vault",
                                 "expected user {} to be a mamber of vault {}".format(username, vaultname),
                                 "User was not member of vault")
            return page
        try:
            assert status.has_admin()
        except AssertionError:
            reporter.add_failure(20, "try to delete non-empty vault",
                                 "expected user {} to be admin in vault {}".format(username, vaultname),
                                 "User was not admin in vault")
            return page

        try:
            assert constants.db_handler.count_objects_in_vault(vaultid) > 0
        except AssertionError:
            reporter.add_failure(20,"try to delete non-empty vault","expected vault {} to not be empty".format(vaultname),"vault contains no objects")
            return page

        try:
            assert page.delete_vault(vaultid)
        except AssertionError:
            reporter.add_failure(20, "try to delete non-empty vault",
                                 "Expected to be able to go through the entire delete-vault procedure for vault {}".format(
                                     vaultname),"Failed to do so")
            return page
        try:
            assert page.driver.find_element_by_id("errorwindow").text == "Vault cannot be deleted with active items"
        except AssertionError:
            reporter.add_failure(20, "try to delete non-empty vault","Expected to find error message on page","Could not")
            return page


        try:
            assert constants.db_handler.get_new_vault_id(vaultname)
        except AssertionError:
            reporter.add_failure(20, "try to delete non-empty vault", "Expected vault {} to not be deleted",
                                 "Could not find any active vaults with that name in the database")
            return page

        reporter.add_success(20, "try to delete non-empty vault",
                             "tried to delete vault {} when it was not empty - deletion failed as expected".format(
                                 vaultname))
        return page

    def delete_vault_with_objects(page, reporter, username, vaultname):
        #page = page_vaults.PageVaults()
        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(19, "delete vault and its content", "could not start, not on the vaults page",
                                 "initialization unsuccessful")
            return page
        try:
            userid = constants.get_user(username)[2]
            vaultid = constants.get_vaultsid(vaultname)

            assert constants.db_handler.get_user_vault_membership(userid, vaultid).has_admin()
        except AssertionError:
            reporter.add_failure(19, "delete vault and its content",
                                 "Expected {} to be admin member of {}".format(username, vaultname),
                                 "Could not verify this")
            return page
        except:
            reporter.add_failure(19, "delete vault and its content",
                                 "Could not find user {} or vault {} in the database".format(username, vaultname),
                                 "expected to be able to find them")
            return page

        #get all object id:s and names [i,n]
        objects = constants.db_handler.get_all_objects_in_vault(vaultid)
        #delete all objects in vault
        if objects:
            try:
                assert page.delete_all_objects_in_vault(vaultid)
            except AssertionError:
                reporter.add_failure(19, "delete vault and its content","Expected to be able to delete all objects in {}".format(vaultname),"Could not verify this")
                return page
            #verify deletion
            for o in objects:
                try:
                    assert constants.db_handler.expect_event_object_deleted(userid,vaultid,o[0],o[1])
                except AssertionError:
                    reporter.add_failure(19, "delete vault and its content",
                                 "Expected to be able to find deletion events for all objects in vault {}".format(vaultname),
                                         "Could not")
                    return page
        #---end if objects

        #Delete vault
        try:
            assert page.delete_vault(vaultid)
        except AssertionError:
            reporter.add_failure(19, "delete vault and its content",
                                 "Expected to be able to go through the delete-vault procedure for vault {}".format(
                                     vaultname), "Could not verify this")
            return page

        #Verify vault deleted:
        try:
            assert page.verify_on_vaults_page()
            assert page.verify_vault_deleted(vaultid)
        except AssertionError:
            reporter.add_failure(19, "delete vault and its content","Expected to be able to verify {} to be deleted".format(vaultname),"could not verify")
            return page

        #Verify in database
        try:
            assert constants.db_handler.expect_event_vault_deleted(userid,vaultid,vaultname)
        except AssertionError:
            reporter.add_failure(19, "delete vault and its content",
                                 "Expected to be able to verify in database that vault {} was deleted".format(
                                     vaultname), "could not verify")
            return page

        #Success
        reporter.add_success(19, "delete vault and its content",
                             "vault {} and its content has been deleted as expected".format(vaultname))
        return page

    def try_leave_vault_as_last_admin(page, reporter, username, vaultname):

        try:
            assert page.verify_on_vaults_page()
        except AssertionError:
            reporter.add_failure(22, "try to leave vault as last admin", "could not start, not on the vaults page",
                             "initialization unsuccessful")
            return page
        try:
            userid = constants.get_user(username)[2]
            vaultid = constants.get_vaultsid(vaultname)

            assert constants.db_handler.get_user_vault_membership(userid,vaultid).has_admin()
        except AssertionError:
            reporter.add_failure(22, "try to leave vault as last admin",
                                 "Expected {} to be admin member of {}".format(username, vaultname),
                                 "Could not verify this")
            return page
        except:
            reporter.add_failure(22, "try to leave vault as last admin",
                                 "Could not find user {} or vault {} in the database".format(username, vaultname),
                                 "expected to be able to find them")
            return page

        try:
            nr = constants.db_handler.number_of_admins(vaultid)
            assert nr == 1
        except AssertionError:
            reporter.add_failure(22, "try to leave vault as last admin",
                                 "Expected only {} to be the only admin in {}".format(username, vaultname),
                                 "Found that there were {} admins in {} in total".format(nr, vaultname))
            return page
        try:
            assert page.leave_vault(userid,vaultid)
        except AssertionError:
            reporter.add_failure(22, "try to leave vault as last admin",
                                 "Expected to be able to go through the entire leave-vault procedure for vault {}".format(
                                     vaultname), "Failed to do so")
            return page

        try:
            assert page.verify_on_vaults_page()
        except AssertionError:

            reporter.add_failure(22, "try to leave vault as last admin", "Expected to be on vaults page","Could not verify this")
            return page

        try:
            assert page.driver.find_element_by_id("errorwindow").text == "Last admin cannot be deleted - all object will be lost forever"
        except AssertionError:
            reporter.add_failure(22, "try to leave vault as last admin", "Expected to find error message on page", "Could not")
            return page

        try:
            assert constants.db_handler.number_of_admins(vaultid) == 1
            assert constants.db_handler.get_user_vault_membership(userid,vaultid).has_admin()
        except AssertionError:
            reporter.add_failure(22, "try to leave vault as last admin",
                         "Expected {} to remain the only admin member of {}".format(username, vaultname),
                         "could not verify this")
            return page
        reporter.add_success(22, "try to leave vault as last admin","Tried to leave vault {} as last admin member {} - leaving vault function did not go through, as expected".format(vaultname,username))
        return page







