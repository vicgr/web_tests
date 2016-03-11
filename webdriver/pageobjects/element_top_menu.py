from page_objects import PageObject
from page_objects import PageElement
from selenium.webdriver.common.alert import Alert


class top_menu(PageObject):
    button_logout = None
    search = None
    logo = None
    driver = None

    def __init__(self,webdriver):
        self.button_logout = button_logout(webdriver)
        self.search = field_search(webdriver)
        self.logo = webdriver.find_element_by_css_selector('img[src="/img/logotype-storedsafe.png"]')
        self.driver = webdriver

    def logout(self):
        self.button_logout.logout()
        return

    def search(self,phrase):
        self.search.search(phrase)
        return

    def click_logotype(self):
        self.logo.click()
        import pageobjects.page_vaults as pv
        return pv.PageVaults(self.driver)

class button_logout(PageObject):
    button_logout = None
    driver = None

    def __init__(self, webdriver):
        #self.button_logout = PageElement(css='input[value="Logout"]')
        self.button_logout = webdriver.find_element_by_css_selector('input[value="Logout"]')
        PageObject.__init__(self,webdriver)
        self.driver = webdriver

    def logout(self):
        self.button_logout.click()
        Alert(self.driver).accept()
        return


class field_search(PageObject):
    field_search = None
    driver = None

    def __init__(self,webdriver):
        self.field_search = PageElement(id_="quicksearch")
        PageObject.__init__(self,webdriver)
        self.driver = webdriver

    def search(self, phrase):
        self.field_search = phrase