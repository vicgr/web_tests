

Feature: Test Login

@login_test @fls_login
Scenario: Try to login using incorrect parameters
  Given I am on loginpage
  When I faillogin with username "" and password ""
  Then I should see "savebutton"

@login_test @tru_login @t
Scenario: Login to page
  Given I am on loginpage
  When I login as "vg"
  Then I should see "Logout"
  And log event login for user "vg" is in log

@req_login
Scenario: Logout from page
  Given I am on the "groups" page
  When I logout
  Then I should see "savebutton"
