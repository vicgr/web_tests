Feature: Test Logout

Scenario: Logs out user
  Given I am logged in
  When I logout
  Then I should see "savebutton"
