#!python3
from db_handler import DB_handler
import os
import json

#environment constants
path_ie_exc = "\IEDriverServer"
path_chrome_exec ="\chromedriver"
conf_file = 'safe_stored.txt'

users = []
login = []
userlogins = {}
item_server = {}
vaults = {}
newvaults = {}
objects = {}
object_types={}

path_self = os.path.dirname(__file__)

path_base = os.path.abspath(os.path.join(path_self,'..'))
p_base = os.path.abspath(os.path.join(path_base,conf_file))
f = open(p_base,'r')
l = f.readlines()
f.close()

for obj in l:
    a = json.loads(obj)
    if a['__type__'] == 'DbInfo':
        login = [a['password'],a['host'],a['database'],a['user']]
    elif a['__type__'] == 'userlogin':
        userlogins[a['username']] = [a['password'], a['otp'], a['id']]
    elif a['__type__'] == 'vault':
        vaults[a['vaultname']] = a['vaultid']
    elif a['__type__'] == 'newitem':
        object_types[a['itemname']] = a['type']
        if a['itemtype'] == 'server':
            item_server[a['itemname']] = [a['host'], a['username'], a['password'], a['alert if decrypted'],
                                      a['information'], ['sensitive information']]
    elif a['__type__'] == 'newvault':
        newvaults[a['vaultname']] = [a['policy'],a['information']]
    elif a['__type__'] == 'object':
        object_types[a['objectname']] = a['objecttype']
        objects[a['objectname']] = [a['objectid'],a['vaultid'],a['objecttype']]



db_handler = DB_handler(login[0],login[1],login[2],login[3],True)

#hämta användare -> array [password, otp, user id]
def get_user(username):
    return userlogins[username]

###---inte relevant
def get_vaultsid(vaultname):
    try:
        return vaults[vaultname]
    except KeyError:
        return db_handler.get_new_vault_id(vaultname)

def get_newitem_server(itemname):
    return item_server[itemname]

def get_newvault_info(vaultname):
    return newvaults[vaultname]

def get_object(objectname):
    return objects[objectname]

def get_object_type(objectname):
    return object_types[objectname]
#----



#url constants
url_base = "https://t1.storedsafe.com/"
url_login = ""
url_vault = "groups.php"
url_index = "index.php"

#text and other assorted constants
text_loginbutton = "Login to Storedsafe"