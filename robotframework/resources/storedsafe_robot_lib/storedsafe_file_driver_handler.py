#!python2
import simplejson as json
import os


userlogins = {}
login = []
vaults = {}
ug_list = {} #lists all vaults a user is a member of (no status, just name)
servers = {}
newvaults = {}
objects = {}
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
        if not ug_list.has_key(a['username']):
            ug_list[a['username']] = [a['vaultname']]
        else:
            ug_list[a['username']] # add new connect here
    elif a['__type__'] == 'vault':
        vaults[a['vaultname']] = a['vaultid']
    elif a['__type__'] == 'newitem':
        objects[a['itemname']] = [None,None,a['type']]
        if a['itemtype'] == 'server':
            servers[a['itemname']] = [a['host'],a['username'],a['password'],a['alert if decrypted'],a['information'],['sensitive information']]
        else:
            True
    elif a['__type__'] == 'newvault':
        newvaults[a['vaultname']] = [a['policy'],a['information']]
    elif a['__type__'] == 'object':
        objects[a['objectname']] = [a['objectid'],a['vaultid'],a['objecttype']]

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
    if vaults.has_key(vaultname):
        return vaults[vaultname]
    return False

def verify_member_of_vault(username,vaultname):
    return True

def get_object_id(objectname):
    return objects[objectname][0]
def get_object_vault(objectname):
    return objects[objectname][1]
def get_object_type(objectname):
    print(objectname)
    try:
        return objects[objectname][2]
    except KeyError:
        return False





#new item: server information
def item_server_get_host(itemname):
    return servers[itemname][0]
def item_server_get_username(itemname):
    return servers[itemname][1]
def item_server_get_password(itemname):
    return servers[itemname][2]
def item_server_get_alert(itemname):
    return servers[itemname][3] == 'True'
def item_server_get_info(itemname):
    return servers[itemname][4]
def item_server_get_sens_info(itemname):
    return servers[itemname][5]

#new vault inforamtion
def get_newvault_policy(vaultname):
    return newvaults[vaultname][0]
def get_newvault_info(vaultname):
    return newvaults[vaultname][1]