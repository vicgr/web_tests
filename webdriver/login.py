"from web_test import WebTest"
from pageobjects import page_login
from selenium import webdriver
import test_reporter
import storedsafe_driver_constants as constants


check_login_fail= False
check_login = False

def test_login():
    #test_ff()
    #test_ch()
    test_ie()
    end_tests()


def test_ff():
    driver = webdriver.Firefox()
    run_tests(driver)


def test_ch():
    #chrome_path = "/Users/Victor/works/storedsafe_webtests/chromedriver"
    chrome_path = constants.path_base+constants.path_chrome_exec
    driver = webdriver.Chrome(executable_path=chrome_path)
    run_tests(driver)


def test_ie():
    #ie_path = "/Users/Victor/works/storedsafe_webtests/IEDriverServer"
    ie_path = constants.path_base+constants.path_ie_exc
    driver = webdriver.Ie(executable_path = ie_path)
    run_tests(driver)

def run_tests(driver):
    reporter.log_webdriver(driver.name+", v."+driver.capabilities['version'])
    test(driver)
    driver.close()

def test(driver):
    #driver.get("https://t1.storedsafe.com/")
    driver.get(constants.url_base)
    page = page_login.PageLogin(driver)

    if page.verify_on_login_page() is False:
        print("Warning: Something went wrong. Is not at the login page.")
        quit(1)

    print('is at loginpage. testing commencing')
    page = loginfailtest(driver,page, "a", "b")
    if not check_login_fail:
        return
    u= str(input('username: '))
    p= str(input('password+yubikey: '))

    page = logintest(driver,page,u,p)
    if not check_login:
        return


def loginfailtest(driver, page, username, password):
    page = page_login.PageLogin.login_incorrectly(page, username, password)
    try:
        assert page.verify_on_login_page() is True
    except AssertionError:
        reporter.add_failure(1,"loginfailuretest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_login)
        return page
    reporter.add_success(1,"loginfailuretest","did not login")
    global check_login_fail
    check_login_fail= True
    return page


def logintest(driver, page, username,password):
    page = page_login.PageLogin.login_correctly(page, username, password)
    try:
        #assert str(driver.current_url).startswith('https://t1.storedsafe.com/groups.php')
        assert str(driver.current_url).startswith(constants.url_base+constants.url_vault)
    except AssertionError:
        reporter.add_failure(2,"logintest","is at: "+driver.current_url,"expected to be at: "+constants.url_base+constants.url_vault)
        return page

    reporter.add_success(2,"logintest","correct login successful - logged in")
    global check_login
    check_login = True

    return page

def end_tests():
    reporter.printreport()

reporter = test_reporter.testreporter()
test_login()


