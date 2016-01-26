"from web_test import WebTest"
from pageobjects import page_login
from selenium import webdriver



def test():
    driver = webdriver.Firefox()
    driver.get("https://t1.storedsafe.com/")
    loginfailtest(driver, "a","b")
    # logintest(driver,"vg","test" )


def loginfailtest(driver,username,password):
    page = page_login.PageLogin(driver)
    page = page_login.PageLogin.login_incorrectly(page,username,password)

test()

#def logintest(driver, username,password):
 #   page_login.PageLogin()



