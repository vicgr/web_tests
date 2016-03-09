from pageobjects import page_login
from selenium import webdriver
import test_reporter
import storedsafe_driver_values as constants
from test_login import login_test
import sys


def selenium_testing():
    tested = False
    if sys.argv.__contains__('-ff'):
        test_ff()
        tested = True
    if sys.argv.__contains__('-ch'):
        test_ch()
        tested = True
    if sys.argv.__contains__('-ie'):
        tested = True
        test_ie()
    if tested is False:
        test_ff()

    end_tests()

#Setup drivers


def test_ff():
    driver = webdriver.Firefox()
    run_tests(driver)


def test_ch():
    chrome_path = constants.path_base+constants.path_chrome_exec
    print(chrome_path)
    driver = webdriver.Chrome(executable_path=chrome_path)
    run_tests(driver)

#FOR IE-TESTING TO WORK:
# protected mode must be set to off (I think?) for all zones
# = kernel-läge måste vara avstängt för all zoner
#see: http://jimevansmusic.blogspot.se/2012/08/youre-doing-it-wrong-protected-mode-and.html
def test_ie():
    ie_path = constants.path_base+constants.path_ie_exc
    driver = webdriver.Ie(executable_path = ie_path)
    run_tests(driver)


def run_tests(driver):
    driver.implicitly_wait(3)
    reporter.log_webdriver(driver.name+", v."+driver.capabilities['version'])
    test(driver)
    #driver.close()


def test(driver):
    driver.get(constants.url_base)
    page = page_login.PageLogin(driver)

    if page.verify_on_login_page() is False:
        print("Warning: Something went wrong. Is not at the login page.")
        quit(1)

    print("_test1: logging in using NO USER_")
    page = login_test.loginfailtest(driver,page, reporter, "a", "b")
    #if not constants.check_login_fail:
    #    return
    print("_test2: please enter credentials_")
    u= str(input('username: '))
    #u = 'vg'
    p= str(input('password+yubikey: '))
    #p="test thing"+input('press yubikey:')

    page = login_test.logintest(driver, page, reporter, u, p)
    #if not constants.check_login:
    #    return
    page = login_test.logout(driver,page, reporter)


def end_tests():
    reporter.printreport()
    reporter.clear()

reporter = test_reporter.testreporter()

#selenium_testing()

def do_test():
    if sys.argv.__contains__("-t"):
        driver = webdriver.Firefox()
        driver.implicitly_wait(3)
        driver.get(constants.url_base)
        page = login_test.logintest(driver,page_login.PageLogin(driver),reporter,"vg","test thing"+str(input('plz yubikey: ')))
        page = login_test.logout(driver,page,reporter)
        end_tests()
    else:
        selenium_testing()

do_test()
