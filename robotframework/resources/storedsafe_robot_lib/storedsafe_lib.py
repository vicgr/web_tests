import storedsafe_db_handler as s_db
import storedsafe_file_driver_handler as s_fh


#---FILE RELEATED METHODS---
def is_user_active(username):
    return s_db.is_user_active(username)

def get_user_keys(username):
    return s_fh.get_user_keys(username)

def get_user_id(username):
    return s_fh.get_user_id(username)

def get_user_fullname(username):
    return s_db.get_user_fullname(username)

def get_vault_id(vaultname):
    return s_fh.get_vault_id(vaultname)

def verify_member_of_vault(username, vaultname):
    return s_fh.verify_member_of_vault(username,vaultname)

def verify_object_in_vault(vault,object):
    return s_db.verify_object_in_vault(vault,object)

#---OBJECTS IN DATABASE RELATED METHODS---
def get_object_id_by_name(vaultname, objectname):
    return s_db.get_object_id_by_name(vaultname,objectname)

#---GET ITEM:SERVER---
def item_server_get_host(itemname):
    return s_fh.item_server_get_host(itemname)
def item_server_get_username(itemname):
    return s_fh.item_server_get_username(itemname)
def item_server_get_password(itemname):
    return s_fh.item_server_get_password(itemname)
def item_server_get_alert(itemname):
    return s_fh.item_server_get_alert(itemname)
def item_server_get_info(itemname):
    return s_fh.item_server_get_info(itemname)
def item_server_get_sens_info(itemname):
    return s_fh.item_server_get_sens_info(itemname)

#---AUDIT EVENT METHODS---
def audit_event_login(username):
    return s_db.audit_event_login(username)

def audit_event_logout(username):
    return s_db.audit_event_logout(username)

def audit_event_object_created(username,vaultname,objectname):
    return  s_db.audit_event_object_created(username,vaultname,objectname)