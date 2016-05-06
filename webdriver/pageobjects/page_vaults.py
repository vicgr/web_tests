#!python3
from page_objects import PageObject, PageElement,MultiPageElement
import storedsafe_driver_values as constants
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.alert import Alert
from pageobjects.element_top_menu import top_menu
from pageobjects.element_bottom_infobar import bottom_infobar

import selenium.selenium

class PageVaults(PageObject):
    driver = None
    topmenu = None
    bottommenu = None
    vault_list = None
    vault_content_list = []


    def __init__(self,webdriver):
        self.driver = webdriver
        PageObject.__init__(self,self.driver)
        #self.button_logout = self.driver.find_element_by_css_selector('input[value="Logout"]')
        self.topmenu = top_menu(self.driver)
        self.bottommenu = bottom_infobar(self.driver)
        self.vault_list = self.driver.find_elements(By.XPATH, '//*[starts-with(@id,"bartitle")]')
        self.new_vault_button = self.driver.find_element_by_id('newgroup')
        for i in self.vault_list:
            p = "".join(list(filter(str.isdigit,i.get_attribute("id"))))
            z =self.driver.find_element(By.ID, 'bar'+p)
            self.vault_content_list.append(z)

    def verify_on_vaults_page(self):
        try:
            self.driver.find_element_by_id('objectlistwindow')
            v_ex = True
        except:
            v_ex = False

        return str(self.driver.current_url).startswith(constants.url_base+constants.url_vault) and v_ex


    def logout(self):
        import pageobjects.page_login as pageLogin
        self.topmenu.logout()
        return pageLogin.PageLogin(self.driver)

    def close_vault(self,vaultname):
        id = constants.get_vaultsid(vaultname)
        for v in self.vault_list:
            if v.get_attribute('id') == "bartitle{}".format(id):
                if v.get_attribute('class') == 'bars _on':
                    v.click()
                    return

    def open_vault(self,vaultname):
        try:
            id = constants.get_vaultsid(vaultname)
        except KeyError:
            id=constants.db_handler.get_new_vault_id(vaultname)

        return self.open_vault_by_id(id)

    def open_new_vault(self,vaultname):
        id = constants.db_handler.get_new_vault_id(vaultname)
        return self.open_vault_by_id(id)

    def open_vault_by_id(self,vaultid):
        for v in self.vault_list:
            if v.get_attribute('id') == 'bartitle' + str(vaultid):
                if v.get_attribute('class') == 'bars _off':
                    v.click()
                return True
        return False

    def create_new_item_server(self,vaultname,itemname,iteminfo):
        #split in multiple lesser classes to better handle multiple object types
        try:
            self.open_vault(vaultname)
            v_id = constants.get_vaultsid(vaultname)
            self.driver.find_element_by_id('bar'+v_id+'add').click()
            self.driver.find_element_by_id('templateid1').click()
            self.driver.find_element_by_id('cont'+v_id).click()
            self.driver.find_element_by_id('host').send_keys(itemname)
            self.driver.find_element_by_id('username').send_keys(iteminfo[1])
            if iteminfo[2] == '':
                self.driver.find_element_by_id('gen').click()
            else:
                self.driver.find_element_by_id('password').send_keys(iteminfo[2])
            if iteminfo[3] == 'True':
                self.driver.find_element_by_id('password_alarm').click()
            self.driver.find_element_by_id('info').send_keys(iteminfo[4])
            self.driver.find_element_by_id('cryptedinfo').send_keys(iteminfo[5])
            self.driver.find_element_by_id('submitbutton').click()
        except:
            return False
        return True

    def mark_object(self,vaultname, objectname):
        try:
            self.open_vault(vaultname)
            vaultid = constants.get_vaultsid(vaultname)
            try:
                object= constants.get_object(objectname)
                o_id = object[0]
                o_type = object[2]
            except KeyError:
                o_id = constants.db_handler.get_new_created_item_in_vault_by_name(objectname,vaultid)
                o_type = constants.db_handler.get_new_object_type(o_id,vaultid)


            self.driver.find_element_by_id('mod_{}_{}_{}'.format(vaultid,o_type,o_id)).click()
        except:
            import sys
            print(sys.exc_info())
            return False
        return True

    def copy_object(self,vaultname,objectname):
        a = self.mark_object(vaultname,objectname)
        if not a:
            return False
        try:
            self.driver.find_element_by_id('copy_'+constants.get_vaultsid(vaultname)).click()
        except:
            return False
        return True

    def move_object(self,vaultname,objectname):
        a = self.mark_object(vaultname, objectname)
        if not a:
            return False
        try:
            self.driver.find_element_by_id('move_' + constants.get_vaultsid(vaultname)).click()
        except:
            return False
        return True

    def get_encrypted_data(self,vaultid,objectid):
        self.open_vault_by_id(vaultid)
        obj=self.driver.find_element(By.XPATH, '//*[contains(@id,":{}:")]'.format(objectid))
        obj.click()
        data = obj.find_element_by_class_name("obfuscate").text
        return data

    def paste_object(self,vaultname):
        try:
            self.open_vault(vaultname)
            try:
                vaultid = constants.get_vaultsid(vaultname)
            except KeyError:
                vaultid = constants.db_handler.get_new_vault_id(vaultname)
            self.driver.find_element_by_id('paste_{}'.format(vaultid)).click()
            Alert(self.driver).accept()
        except:
            return False
        #wait for waitwondow to disappear => wait for database to update
        WebDriverWait(self.driver, 10).until(EC.invisibility_of_element_located((By.ID, "waitwindow")))

        return True


    def create_new_vault(self,vaultname):
        try:
            vaultinfo = constants.get_newvault_info(vaultname)
            self.new_vault_button.click()
            self.driver.find_element_by_id('groupname').send_keys(vaultname)
            Select(self.driver.find_element_by_id('policy')).select_by_visible_text(vaultinfo[0])
            self.driver.find_element_by_id('info').send_keys(vaultinfo[1])
            self.driver.find_element_by_id('submitbutton').click()
        except:
            return False
        return True

    def delete_vault(self,vaultid):
        try:
            self.open_vault_by_id(vaultid)
            self.driver.find_element_by_id("bar{}edit".format(vaultid)).click()
            WebDriverWait(self.driver, 10).until(EC.visibility_of_element_located((By.ID, "popupwindow")))
            self.driver.find_element_by_id("deletebutton").click()

            Alert(self.driver).accept()
            WebDriverWait(self.driver, 10).until(EC.invisibility_of_element_located((By.ID, "popupwindow")))
        except:
            return False
        return True


    def delete_object(self,vaultid,objectid,objecttype):
        try:
            self.open_vault_by_id(vaultid)
            self.driver.find_element_by_id("link-{}".format(objectid)).click()
            if(objecttype!='8' or objecttype != '9'):
                self.driver.find_element_by_id("editbtn#{}".format(objectid)).click()
            WebDriverWait(self.driver, 10).until(EC.visibility_of_element_located((By.ID, "popupwindow")))
            self.driver.find_element_by_id('deletebutton').click()
            Alert(self.driver).accept()
            WebDriverWait(self.driver, 10).until(EC.invisibility_of_element_located((By.ID, "popupwindow")))
        except:
            return False
        return True

    def leave_vault(self,userid,vaultid):
        try:
            self.open_vault_by_id(vaultid)
            self.driver.find_element_by_id("bar{}users2".format(vaultid)).click()
            WebDriverWait(self.driver,10).until(EC.visibility_of_element_located((By.ID,"btnid{}".format(userid))))
            self.driver.find_element_by_id("btnid{}".format(userid)).click()
            Alert(self.driver).accept()
            WebDriverWait(self.driver,10).until((EC.invisibility_of_element_located((By.ID, "waitwindow"))))
        except:
            return False
        return True









