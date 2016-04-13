import storedsafe_db_handler as s_db
import storedsafe_file_driver_handler as s_fh

def is_user_active(username):
    return s_db.is_user_active(username)

def get_user_keys(username):
    return s_fh.get_user_keys(username)

def get_user_id(username):
    return s_fh.get_user_id(username)

def get_user_fullname(username):
    return s_db.get_user_fullname(username)

def audit_event_login(username):
    return s_db.audit_event_login(username)

def audit_event_logout(username):
    return s_db.audit_event_logout(username)

