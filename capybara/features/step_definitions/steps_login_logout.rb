Given(/^I am on loginpage$/) do
  visit ''
  assert Page_index .isAtLogin(),"expected to be at login page, but is not"
end

When(/^I login as "([^"]*)"$/) do |user|
  uid = C_Support.get_user_id(user)
  assert C_Support.get_db_handler.is_userid_active(uid),"there is no active user with the name #{user} in the database"
  keys = C_Support.get_login(user)
  Page_index .Login(user,keys)
end

Then(/^I should be logged in as "([^"]*)"$/) do |user|
  fn = C_Support.get_db_handler.get_user_by_id(C_Support.get_user_id(user)) .fullname
  assert Page_logged_in .isLoggedInAs(fn), "expected to be logged in as #{user}, but could not verify this"
end

When(/^I logout as "([^"]*)"$/) do |user|
  assert Page_logged_in .isLoggedInAtAll,"expected to be logged in, but could not verify this"
  Page_logged_in .logout
  assert Page_index .isAtLogin,"expected to be at login page, but is not"
  assert C_Support.get_db_handler.auditlog_verify_logout(C_Support.get_user_id(user)), "expected to find a new logout event for #{user} in the database, but could not"
end

When(/^I authfail login with username "([^"]*)" and password "([^"]*)"$/) do |arg1, arg2|
  fill_in 'username', :with => arg1
  fill_in 'keys', :with => arg2
  click_button 'savebutton'
end

When(/^I am logged in with privileges "([^"]*)", with audit = "([^"]*)" and ug-list = "([^"]*)"$/) do |priv, audit, ug|
  if priv.downcase == 'admin'
    assert Page_vaults .isLoggedInAsAdmin, "expected to find both 'systemusers' and 'new vault' buttons. Could not identify one of them"
  elsif priv.downcase == 'write'
    assert Page_vaults .isLoggedInAsWrite, "expected to find 'new vault' button, but not a 'system users'. Either is wrong"
  elsif priv.downcase == 'read'
    assert Page_vaults .isLoggedInAsRead, "expected to neither find 'new vault' nor 'system users'. At least one was found."
  else
    assert false, "#{priv} is not correct. Variable must be set to admin, write or read"
  end

  if audit.downcase == 'true'
    assert Page_vaults .hasAudit, "expected to find an audit button"
  else
    assert !Page_vaults.hasAudit, "audit button was not expected to be found."
  end
  if ug.downcase == 'true'
    ##howto?
  else
  end

end
