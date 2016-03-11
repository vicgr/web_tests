from page_objects import PageObject
from selenium.webdriver.common.by import By


class bottom_infobar(PageObject):

    driver = None

    lang_EN = None
    lang_IT = None
    lang_NL = None
    lang_SE = None

    my_user = None

    def __init__(self, webdriver):
        self.driver = webdriver
        self.my_user=my_user(self.driver)
        PageObject.__init__(self,self.driver)

        self.lang_EN = self.driver.find_element(By.XPATH,'//a[contains(@onclick,"en_EN")]')
        self.lang_IT = self.driver.find_element(By.XPATH,'//a[contains(@onclick,"it_IT")]')
        self.lang_NL = self.driver.find_element(By.XPATH,'//a[contains(@onclick,"nl_NL")]')
        self.lang_SE = self.driver.find_element(By.XPATH,'//a[contains(@onclick,"sv_SE")]')

    def set_lang(self,lang):
        if lang == "EN" :
            self.set_lang_EN()
        elif lang == "IT":
            self.set_lang_IT()
        elif lang == "NL":
            self.set_lang_NL()
        elif lang == "SE":
            self.set_lang_SE()

    def set_lang_EN(self):
        self.lang_EN.click()
    def set_lang_IT(self):
        self.lang_IT.click()
    def set_lang_NL(self):
        self.lang_NL.click()
    def set_lang_SE(self):
        self.lang_SV.click()

    def get_user_name(self):
        return self.my_user.get_user_fullname()


class my_user(PageObject):
    driver = None
    user = None

    def __init__(self,webdriver):
        self.driver = webdriver
        PageObject.__init__(self,self.driver)
        self.user = self.driver.find_element(By.XPATH, '//a[contains(@onclick,"myuser")]')

    def get_user_fullname(self):
        return self.user.text


    def update_user_settings(self,update_settings):
        return True