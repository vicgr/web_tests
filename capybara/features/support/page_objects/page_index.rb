class Page_index

  def self.Login (username, keywords)
    #a = C_Support.Get_next_yubikey
    fill_in 'username', :with =>username
    fill_in 'keys', :with => keywords
    click_on 'savebutton'
  end

  def self.isAtLogin
    begin
      find_button 'savebutton'
      find_field 'username'
      find_field 'keys'
    rescue
      return false
    end
    return true
  end

end
