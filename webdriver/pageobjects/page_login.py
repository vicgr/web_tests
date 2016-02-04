from page_objects import PageObject, PageElement
#from pageobjects.page_vaults import PageVaults
import pageobjects.page_vaults as PageVaults
import storedsafe_driver_values as constants

class PageLogin(PageObject):
    fieldUsername = PageElement(id_='username')
    fieldPassword = PageElement(id_='keys')
    buttonSubmit = PageElement(css='input[type="submit"]')
    driver = "webdriver"


    def _clear_fields_(self):
        self.fieldPassword.clear()
        self.fieldUsername.clear()

    def __init__(self,webdriver):
        self.driver = webdriver
        PageObject.__init__(self,webdriver)

    def __login__(self, username, password):
        self._clear_fields_()
        self.fieldUsername = username
        self.fieldPassword = password
        self.buttonSubmit.click()

    def login_correctly(self, username, password):
        self.__login__(username, password)
        return PageVaults.PageVaults(self.driver)

    def login_incorrectly(self, username, password):
        self.__login__(username, password)
        #return PageLogin(self.driver)
        return self

    def verify_on_login_page(self):
        return self.buttonSubmit.get_attribute("value") == constants.text_loginbutton and \
               self.driver.current_url == constants.url_base


