from db_handler import DB_handler
import os
import json

#environment constants
#path_base = "/Users/Victor/works/storedsafe_webtests/" #TODO:edit to fit any environment
path_ie_exc = "\IEDriverServer"
path_chrome_exec ="\chromedriver"
conf_file = 'safe_stored.txt'

users = []
login = []
userlogin = []

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
        userlogin=[a['username'],a['password'],a['otp']]
    elif a['__type__'] == 'user':
        True


db_handler = DB_handler(login[0],login[1],login[2],login[3],True)

curr_user = None

#url constants
url_base = "https://t1.storedsafe.com/"
url_login = ""
url_vault = "groups.php"
url_index = "index.php"

#text and other assorted constants
text_loginbutton = "Login to Storedsafe"

#Check-values that are necessary for ensuring that the tests can continue (unused)
check_login = False
check_login_fail = False


def reset_all_checks():
    check_login = False
    check_login_fail = False