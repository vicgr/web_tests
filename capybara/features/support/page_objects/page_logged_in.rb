class Page_logged_in
  def self.isLoggedInAs(fullname)
    #user fullname is displayed in the window
    if !has_content? fullname
      return false
    end
    #the user-image exists
    return isLoggedInAtAll
  end

  def self.isLoggedInAtAll
    return has_css?("img[src='img/ico/user/user.png']")
  end

  def self.logout
    click_button 'logouttop'
    if C_Support.driver
      page.driver.browser.switch_to.alert .accept
    end
  end
end
