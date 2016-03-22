Given(/^I am on loginpage$/) do
  visit ''
  assert Page_index .isAtLogin()
end


When(/^I login as "([^"]*)"$/) do |user|
  keys = C_Support.get_login(user)
  a = C_Support.get_db_handler.is_username_active(user)
  b = C_Support.get_db_handler.is_userid_active(15)
  $stdout.puts "___"
  $stdout.puts a
  $stdout.puts b
  $stdout.puts "___"
  Page_index .Login(user,keys)
end

When(/^I logout$/) do
  click_button 'logouttop'
end

When(/^I faillogin with username "([^"]*)" and password "([^"]*)"$/) do |arg1, arg2|
  fill_in 'username', :with => arg1
  fill_in 'keys', :with => arg2
  click_button 'savebutton'
end
