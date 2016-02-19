Given(/^I am on loginpage$/) do
  visit ''
end

When(/^I login with username "([^"]*)" and password "([^"]*)"$/) do |arg1, arg2|
  a = gets
  fill_in 'username', :with => arg1 + a
  fill_in 'keys', :with => arg2
  click_button 'savebutton'
end

When(/^I logout$/) do
  click_button 'logouttop'
end

When(/^I faillogin with username "([^"]*)" and password "([^"]*)"$/) do |arg1, arg2|
  fill_in 'username', :with => arg1
  fill_in 'keys', :with => arg2
  click_button 'savebutton'
end
