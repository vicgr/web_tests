from page_objects import PageObject, PageElement,MultiPageElement
import storedsafe_driver_values as constants
from selenium.webdriver.common.by import By
from pageobjects.element_top_menu import top_menu

class PageVaults(PageObject):
    driver = None
    topmenu = None
    vault_list = None
    vault_content_list = None
    #v_c_l = [x for x in vault_content_list not in vault_list]

    def __init__(self,webdriver):
        self.driver = webdriver
        PageObject.__init__(self,webdriver)
        #self.button_logout = self.driver.find_element_by_css_selector('input[value="Logout"]')
        self.topmenu = top_menu(self.driver)
        self.vault_list = self.driver.find_elements(By.XPATH, '//*[starts-with(@id,"bartitle")]')
        self.vault_content_list = self.driver.find_elements(By.XPATH, '//*[starts-with(@id,"bar")]')
        #self.vault_content_list =

    def verify_on_vaults_page(self):
        return str(self.driver.current_url).startswith(constants.url_base+constants.url_vault) and \
            1==1

    def logout(self):
        import pageobjects.page_login as pageLogin
        #self.button_logout.click()
        self.topmenu.logout()
        return pageLogin.PageLogin(self.driver)

