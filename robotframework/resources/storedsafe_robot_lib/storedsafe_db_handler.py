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

def verify_member_of_vault(userid,vaultid):
    cursor.execute("select status from ss_groupkeys where userid={} and groupid = {}".format(userid,vaultid))
    res = cursor.fetchall()
    for row in res:
        return s_db_objects.obj_status(row[0])
    return False

def count_objects_in_vault(vaultid):
    nr = 0
    cursor.execute("select status from ss_objects where groupid = {}".format(vaultid))
    res = cursor.fetchall()
    for row in res:
        if s_db_objects.obj_status(row[0]).is_active():
            nr += 1
    return nr

def get_object_id_by_name(vaultname, objectname): #gets the _latest_ created _active_ object with that name
    v_id = s_h.get_vault_id(vaultname)
    if not v_id:
        v_id = get_vault_id_by_name(vaultname)
        if not v_id:
            return False
    query = "select id, status from ss_objects where groupid = {} and objectname = '{}' order by id desc".format(v_id, objectname)
    cursor.execute(query)
    res = cursor.fetchall()
    for row in res:
        if s_db_objects.obj_status(row[1]) .is_active():
            return row[0]
    return False


def get_vault_id_by_name(vaultname): #gets the id of the latest created (highest id) active vault with the given name
    query = "select id,status from ss_groups where groupname = '{}' order by id desc".format(vaultname)
    cursor.execute(query)
    res = cursor.fetchall()
    for row in res:
        if s_db_objects.obj_status(row[1]) .is_active():
            return row[0]
    return

def objects_Should_Be_Similar(vault1,object1,vault2,object2):
    o_id_1 = get_object_id_by_name(vault1,object1)
    o_id_2 = get_object_id_by_name(vault2,object2)
    cursor.execute("select * from ss_objects where id={}".format(o_id_1))
    for row in cursor:
        o1 = row
    cursor.execute("select * from ss_objects where id={}".format(o_id_2))
    for row in cursor:
        o2= row
    return o1[1]==o2[1] and o1[2]==o2[2] and o1[4]==o2[4] and o1[6]==o2[6] and o1[7]==o2[7] and o1[9]==o2[9] and o1[10]==o2[10]


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

def audit_event_object_copied(userid,vault_from,vault_to,objectid):
    query = "select id from ss_log where userid={} and objectid = {} and groupid = {} and event like '%COPY TO VAULT: {}%'".format(userid,objectid,vault_from,vault_to)
    return audit_execute(query)

def audit_event_object_moved(userid,vault_from,vault_to,objectid):
    query = "select id from ss_log where userid={} and objectid = {} and groupid = {} and event like '%MOVED TO VAULT: {}%'".format(userid,objectid,vault_from,vault_to)
    return audit_execute(query)


def audit_event_object_decryption(userid, v_id, o_id):
    query = "select id from ss_log where userid={} and groupid={} and objectid={} and event like '%ALARM DECRYPTED%'".format(
        userid, v_id, o_id)
    return audit_execute(query)

def audit_event_object_deleted(userid,vaultid,objectname):
    query = "select id from ss_log where userid= {} and groupid={} and event like '%OBJECT DELETED:{}%'".format(userid,vaultid,objectname)
    return audit_execute(query)
