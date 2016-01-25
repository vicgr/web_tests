from selenium import webdriver
from selenium.webdriver.common.keys import Keys
driver = webdriver.Firefox()
driver.get("http://t1.storedsafe.com")

assert "StoredSafe" in driver.title
login = driver.find_element_by_name("username")
pw = driver.find_element_by_name("keys")
login.send_keys("victor")
passw.send_keys("")
click(driver.find_element_by_id("savebutton"))
