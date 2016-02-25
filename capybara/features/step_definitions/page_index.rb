class Page_index
  def self.Login (username, keyword)
    a = C_Support.Get_next_yubikey
    fill_in 'username', :with => username
    fill_in 'keys', :with => keyword+a
    click_button 'savebutton'
  end

end
