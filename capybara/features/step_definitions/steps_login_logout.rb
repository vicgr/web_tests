Given(/^I am on loginpage$/) do
  visit ''
end

Given(/^I am logged in$/) do

  #assert page.current_path
  #pending # Write code here that turns the phrase above into concrete actions
end

When(/^I login with username "([^"]*)" and password "([^"]*)"$/) do |arg1, arg2|
  a = gets
  fill_in 'username', :with => arg1 + a
  fill_in 'keys', :with => arg2
  click_button 'savebutton'
end

When(/^I faillogin with username "([^"]*)" and password "([^"]*)"$/) do |arg1, arg2|
  fill_in 'username', :with => arg1
  fill_in 'keys', :with => arg2
  click_button 'savebutton'
end

Then(/^I should see "([^"]*)"$/) do |arg1|
  has_text?(arg1)
end
