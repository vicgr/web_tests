from page_objects import PageObject
import storedsafe_driver_values as constants


class PageVaults(PageObject):
    truth = True
    driver = ""

    def __init__(self,webdriver):
        self.driver = webdriver
        PageObject.__init__(self,webdriver)


    def verify_on_vaults_page(self):
        return str(self.driver.current_url).startswith(constants.url_base+constants.url_vault) and \
            1==1
