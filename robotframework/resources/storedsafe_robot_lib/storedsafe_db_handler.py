import storedsafe_file_driver_handler as s_h
import pymysql.cursors
import s_db_objects

l = s_h.get_db_login()

connection = pymysql.connect(user = l[3],
                     host = l[1],
                     database = l[2],
                     password = l[0]
                     )

cursor = connection.cursor()

cursor.execute('select NOW()')
start_time = cursor.fetchone()[0]
print start_time


def is_user_active(user):
    u_id = s_h.get_user_id(user)
    if not u_id:
        return False
    cursor.execute('select status from ss_userbase where id = %s',u_id)
    res = cursor.fetchone()[0]
    cursor.fetchall()
    if res is not None:
        return s_db_objects.obj_status(res) .is_active()
    else:
        return False

def get_user_fullname(username):
    u_id = s_h.get_user_id(username)
    if not u_id:
        return False
    cursor.execute('select fullname from ss_userbase where id = %s',u_id)
    res = cursor.fetchone()[0]
    cursor.fetchall()
    return res

def verify_object_in_vault(vault,object):
    v_name = s_h.get_vault_id(vault)

def get_object_id_by_name(vaultname, objectname): #gets the _latest_ created object with that name
    v_id = s_h.get_vault_id(vaultname)
    if not v_id:
        return False
    query = "select id, status from ss_objects where groupid = {} and objectname = '{}' order by id desc".format(v_id, objectname)
    cursor.execute(query)
    res = cursor.fetchall()
    for row in res:
        if s_db_objects.obj_status(row[1]) .is_active():
            return row[0]
    return

def get_vault_id_by_name(vaultname): #gets the id of the latest created (highest id) active vault with the given name
    query = "select id,status from ss_groups where groupname = '{}' order by id desc".format(vaultname)
    cursor.execute(query)
    res = cursor.fetchall()
    for row in res:
        if s_db_objects.obj_status(row[1]) .is_active():
            return row[0]
    return

def get_next_object_id():
    return

def audit_execute(query):
    cursor.execute(query)
    res = cursor.fetchone()
    if res is None:
        return False
    res = res[0]
    cursor.fetchall()
    return res

def audit_event_login(user):
    u_id = s_h.get_user_id(user)
    if not u_id:
        return False
    query = "select id from ss_log where event like '%LOGIN%' and userid = {} and stamp >= '{}'".format(u_id,start_time)
    return audit_execute(query)

def audit_event_logout(user):
    u_id = s_h.get_user_id(user)
    if not u_id:
        return False
    query = "select id from ss_log where event like '%LOGOUT%' and userid = {} and stamp >= '{}'".format(u_id,start_time)
    return audit_execute(query)

def audit_event_object_created(username,vaultname,objectname):
    u_id = s_h.get_user_id(username)
    v_id = s_h.get_vault_id(vaultname)
    o_id = get_object_id_by_name(vaultname,objectname)
    if not v_id or not u_id or not o_id:
        return False
    query = "select id from ss_log where event like '%OBJECT CREATED%' and userid = {} and groupid = {} and objectid = {} and stamp >= '{}'".format(u_id,v_id,o_id,start_time)
    return  audit_execute(query)

def audit_event_vault_created(username, vaultname):
    u_id = s_h.get_user_id(username)
    v_id = get_vault_id_by_name(vaultname)
    if not u_id or not v_id:
        return False
    query = "select id from ss_log where userid = {} and groupid = {} and event like '%VAULT CREATED:{}%' and stamp >= '{}'".format(u_id,v_id,vaultname,start_time)
    return audit_execute(query)
