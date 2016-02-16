
#environment constants
path_base = "/Users/Victor/works/storedsafe_webtests/" #TODO:edit to fit any environment
path_ie_exc = "IEDriverServer"
path_chrome_exec ="chromedriver"

#url constants
url_base = "https://t1.storedsafe.com/"
url_login = ""
url_vault = "groups.php"
url_index = "index.php"

#text and other assorted constants
text_loginbutton = "Login to Storedsafe"

#Check-values that are necessary for ensuring that the tests can continue
check_login = False
check_login_fail = False

def reset_all_checks():
    check_login = False
    check_login_fail = False