#!python3
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

#---SETUP DRIVERS---

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
#--------------------


def run_tests(driver):
    driver.implicitly_wait(3)
    reporter.log_webdriver(driver.name + ", v." + driver.capabilities['version'])

    driver.get(constants.url_base)
    page = page_login.PageLogin(driver)

    if page.verify_on_login_page() is False:
        print("Warning: Something went wrong. Is not at the login page.")
        quit(1)

    page = login_test.logintest(driver, page, reporter, username='test_admin')

    import test_vaults
    #test_vaults.vault_tests.create_new_vault(page,reporter,'test_admin','v_test_vault_2')
    #test_vaults.vault_tests.open_vault(page,'v_test_vault_1')
    #test_vaults.vault_tests.create_new_server_item(None,page,reporter,'test_admin','v_test_vault_1','v_test_object_2')
    #test_vaults.vault_tests.copy_object(page,reporter,'test_admin','v_test_vault_1','v_test_vault_2','v_test_object_2')
    #test_vaults.vault_tests.move_object(page, reporter, 'test_admin', 'v_test_vault_1', 'v_test_vault_2','v_test_object_2')
    #page = login_test.logout(driver,page, reporter, username='test_admin')
    #page = test_vaults.vault_tests.read_data(page,reporter,'test_admin','v_test_vault_1','v_test_object_2')
    #test_vaults.vault_tests.delete_object(page,reporter,'test_admin','v_test_vault_2','v_test_object_2')
    test_vaults.vault_tests.try_delete_non_empty_vault(page,reporter,'test_admin','v_test_vault_2')


def end_tests():
    reporter.printreport()
    reporter.clear()

reporter = test_reporter.testreporter()

#selenium_testing()

selenium_testing()