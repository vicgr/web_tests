
Feature: Test Login

Scenario: Try to login using incorrect parameters
  Given I am on loginpage
  When I faillogin with username "vg" and password "test"
  Then I should see "savebutton"


Scenario: Login to page
  Given I am on loginpage
  When I login with username "vg" and password "test thing"
  Then I should see "Logout"
