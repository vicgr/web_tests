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
    if tested == False:
        test_ff()

    end_tests()

#Setup drivers


def test_ff():
    driver = webdriver.Firefox()
    run_tests(driver)


def test_ch():
    chrome_path = constants.path_base+constants.path_chrome_exec
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


#Run tests


def run_tests(driver):
    reporter.log_webdriver(driver.name+", v."+driver.capabilities['version'])
    test(driver)
    driver.close()


def test(driver):
    driver.get(constants.url_base)
    page = page_login.PageLogin(driver)

    if page.verify_on_login_page() is False:
        print("Warning: Something went wrong. Is not at the login page.")
        quit(1)

    #page = login_test.loginfailtest(driver,page, reporter, "a", "b")
    #if not constants.check_login_fail:
    #    return
    u= str(input('username: '))
    p= str(input('password+yubikey: '))

    page = login_test.logintest(driver, page, reporter, u, p)
    #if not constants.check_login:
    #    return
    page = login_test.logout(driver,page)
    print("logout")

def end_tests():
    reporter.printreport()

reporter = test_reporter.testreporter()

selenium_testing()