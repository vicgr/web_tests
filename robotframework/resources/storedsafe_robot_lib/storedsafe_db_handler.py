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

def audit_event_login(user):
    u_id = s_h.get_user_id(user)
    if not u_id:
        return False
    query = "select id from ss_log where event like '%LOGIN%' and userid = {} and stamp >= '{}'".format(u_id,start_time)
    cursor.execute(query)
    res = cursor.fetchone()
    if res is None:
        return False
    res = res[0]
    cursor.fetchall()
    return res

def audit_event_logout(user):
    return

