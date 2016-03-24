Given(/^I am on vaultpage$/) do
  assert Page_vaults .isAtVaultsPage
end

Given(/^I am logged in$/) do
  visit "/groups.php"
  puts "path= " +page.current_path
end

Given(/^I am on the "([^"]*)" page$/) do |arg1|
  visit arg1 + '.php'
end

Then(/^I should see "([^"]*)"$/) do |arg1|
    assert has_text?(arg1)
end
