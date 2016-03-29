Given(/^I am on loginpage$/) do
  visit ''
  assert Page_index .isAtLogin()
end

When(/^I login as "([^"]*)"$/) do |user|
  uid = C_Support.get_user_id(user)
  assert C_Support.get_db_handler.is_userid_active(uid)
  keys = C_Support.get_login(user)
  Page_index .Login(user,keys)
end

Then(/^I should be logged in as "([^"]*)"$/) do |user|
  fn = C_Support.get_db_handler.get_user_by_id(C_Support.get_user_id(user)) .fullname
  assert Page_logged_in .isLoggedInAs(fn)
end

When(/^I logout as "([^"]*)"$/) do |user|
  assert Page_logged_in .isLoggedInAtAll
  Page_logged_in .logout
  assert Page_index .isAtLogin
  assert C_Support.get_db_handler.auditlog_verify_logout(C_Support.get_user_id(user))
end

When(/^I authfail login with username "([^"]*)" and password "([^"]*)"$/) do |arg1, arg2|
  fill_in 'username', :with => arg1
  fill_in 'keys', :with => arg2
  click_button 'savebutton'
end
