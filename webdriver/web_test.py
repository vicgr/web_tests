from selenium import webdriver
from selenium.webdriver.common.keys import Keys


class WebTest(object):
    def __init__(self,driver):
        if(isinstance(driver,webdriver)):
            self.driver = driver
        else:
            self.driver = webdriver.Firefox()

