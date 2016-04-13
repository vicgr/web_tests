#!python2
import simplejson as json
import os

userlogins = {}
login = []
path_ie_exc = "\IEDriverServer"
path_chrome_exec = "\chromedriver"
conf_file = 'safe_stored.txt'

path_self = os.path.dirname(__file__)
path_base = os.path.abspath(os.path.join(path_self, '../../..'))
p_base = os.path.abspath(os.path.join(path_base, conf_file))
f = open(p_base, 'r')

l = f.readlines()
f.close()
for obj in l:
    a = json.loads(obj)
    if a['__type__'] == 'DbInfo':
        login = [a['password'], a['host'], a['database'], a['user']]
    elif a['__type__'] == 'userlogin':
        userlogins[a['username']] = [a['password'],a['otp'],a['id']]
    elif a['__type__'] == 'vaultmember':
        True
    elif a['__type__'] == 'vault':
        True
a = None

def get_user_keys( user ):
    if userlogins.has_key(user):
        return userlogins[user][0]+userlogins[user][1]
    return False

def get_user_id (user):
    if userlogins.has_key(user):
        return userlogins[user][2]
    return False


def get_db_login ():
    return login

def get_vault_id (vaultname):
    return

def get_vault_membership(name):
    return


