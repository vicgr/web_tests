

Feature: Test Login

@start_not_logged_in @end_not_logged_in
Scenario: Try to login using incorrect parameters
  Given I am on loginpage
  When I faillogin with username "" and password ""
  Then I should see "savebutton"

@start_not_loggad_in @req_yubi @end_logged_in
Scenario: Login to page
  Given I am on loginpage
  When I login with username "vg" and password "test thing"
  Then I should see "Logout"

@start_logged_in @end_not_logged_in
Scenario: Logout from page
  Given I am on the "groups" page
  When I logout
  Then I should see "savebutton"
