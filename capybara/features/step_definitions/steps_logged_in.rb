Given(/^I am logged in$/) do
  visit "/groups.php"
  puts "path= " +page.current_path
end

Given(/^I am on the "([^"]*)" page$/) do |arg1|
  visit arg1 + '.php'
  puts page.current_path
end

Then(/^I should see "([^"]*)"$/) do |arg1|
  has_text?(arg1)
end
