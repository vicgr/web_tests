from pageobjects import page_login
from selenium import webdriver
import test_reporter
import storedsafe_driver_values as constants
from test_login import login_test as test_login
#from test_login import loginfailtest,logintest


def selenium_testing():
    test_ff()
    test_ch()
    test_ie()
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
#http://jimevansmusic.blogspot.se/2012/08/youre-doing-it-wrong-protected-mode-and.html
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

    page = test_login.loginfailtest(driver,page, reporter, "a", "b")
    if not constants.check_login_fail:
        return
    u= str(input('username: '))
    p= str(input('password+yubikey: '))

    page = test_login.logintest(driver, page, reporter, u, p)
    if not constants.check_login:
        return

def end_tests():
    reporter.printreport()

reporter = test_reporter.testreporter()
selenium_testing()