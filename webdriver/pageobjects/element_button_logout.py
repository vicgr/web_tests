from page_objects import PageObject
from selenium.webdriver.common.alert import Alert


class button_logout(PageObject):
    button_logout = None
    driver = None

    def __init__(self, webdriver):
        self.button_logout = webdriver.find_element_by_css_selector('input[value="Logout"]')
        PageObject.__init__(self,webdriver)
        self.driver = webdriver

    def logout(self):
        self.button_logout.click()
        Alert(self.driver).accept()
        return
