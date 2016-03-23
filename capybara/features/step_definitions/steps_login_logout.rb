Given(/^I am on loginpage$/) do
  visit ''
  assert Page_index .isAtLogin()
end


When(/^I login as "([^"]*)"$/) do |user|
  assert C_Support.get_db_handler.is_userid_active(C_Support.get_user_id(user))
  keys = C_Support.get_login(user)
  Page_index .Login(user,keys)
  assert C_Support.get_db_handler.auditlog_verify_login(C_Support.get_user_id(user))
  u = C_Support.get_db_handler.get_user_by_id(C_Support.get_user_id(user))
  assert Page_vaults .isLoggedIn(u.fullname)
  #assert Page_vaults .isAtVaultsPage


end

When(/^I logout$/) do
  click_button 'logouttop'
end

When(/^I faillogin with username "([^"]*)" and password "([^"]*)"$/) do |arg1, arg2|
  fill_in 'username', :with => arg1
  fill_in 'keys', :with => arg2
  click_button 'savebutton'
end
