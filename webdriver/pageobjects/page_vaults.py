from page_objects import PageObject, PageElement,MultiPageElement
import storedsafe_driver_values as constants
from selenium.webdriver.common.alert import Alert

class PageVaults(PageObject):
    driver = ""
    button_logout = PageElement(css = 'input[value="Logout"]')
    #vault_list = MultiPageElement(classname='bars_off')
    #vault_content_list = (MultiPageElement(css=''))
    #v_c_l = [x for x in vault_content_list not in vault_list]


    def __init__(self,webdriver):
        self.driver = webdriver
        PageObject.__init__(self,webdriver)


    def verify_on_vaults_page(self):

        #for i in self.v_c_l:
        #    print(i)

        return str(self.driver.current_url).startswith(constants.url_base+constants.url_vault) and \
            1==1

    def logout(self):
        import pageobjects.page_login as pageLogin
        self.driver.find_element_by_css_selector('input[value="Logout"]').click()
        #self.button_logout.click()
        print('click')
        Alert(self.driver).accept()
        return pageLogin.PageLogin(self.driver)

