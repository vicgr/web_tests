#!python3

import sys
from selenium import webdriver
from selenium.webdriver.common.by import By
import storedsafe_driver_values as constants


def run_test():
    if sys.argv.__contains__('-ff'):
        test('ff')
        tested = True
    if sys.argv.__contains__('-ch'):
        test('ch')
        tested = True
    if sys.argv.__contains__('-ie'):
        tested = True
        test('ie')
    if tested is False:
        test('ch')

def test(br='ch'):
    if br == 'ch':
        chrome_path = constants.path_base + constants.path_chrome_exec
        driver = webdriver.Chrome(executable_path=chrome_path)
    elif br == 'ie':
        ie_path = constants.path_base + constants.path_ie_exc
        driver = webdriver.Ie(executable_path=ie_path)
    else:
        driver = webdriver.Firefox()

    driver.implicitly_wait(3) #sätter alla väntetider

    #----Start test
    #----End test
    #----Display result?

run_test()


