

Feature: Test Login

@login_test @fls_login
Scenario: Try to login using incorrect parameters
  Given I am on loginpage
  When I faillogin with username "" and password ""
  Then I should see "savebutton"

@login_test @tru_login
Scenario: Login to page
  Given I am on loginpage
  When I login with username "vg" and password "test thing"
  Then I should see "Logout"

@req_login
Scenario: Logout from page
  Given I am on the "groups" page
  When I logout
  Then I should see "savebutton"
