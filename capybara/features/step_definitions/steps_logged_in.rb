Given(/^I am logged in$/) do
  visit "/groups.php"
  puts "path= " +page.current_path
end

Given(/^I am on the "([^"]*)" page$/) do |arg1|
  visit arg1 + '.php'
  puts page.current_path
end

Then(/^I should see "([^"]*)"$/) do |arg1|

    assert has_text?(arg1)

    #assert find_button(arg1).nil? is false


    #assert have_button(arg1)
end
