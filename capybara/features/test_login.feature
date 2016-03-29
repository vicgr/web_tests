

Feature: Test Login

@false_login_no_user
Scenario: Try to login using a non-existing user
  Given I am on loginpage
  When I authfail login with username "" and password ""
  Then I am on loginpage
  And log event authfailure apikey is in log

@login_only
Scenario: Login to page
  Given I am on loginpage
  When I login as "vg"
  Then I should be logged in as "vg"
  And log event login for user "vg" is in log

@o
Scenario: Logout from page
  Given I am on loginpage
  And I login as "vg"
  Then I should be logged in as "vg"
  And I am on vaultpage
  When I logout as "vg"
  Then I am on loginpage
  And log event logout for user "vg" is in log


@admin
Scenario: Admin scenario
  Given I am on loginpage
  When I login as "test_admin"
  Then I should be logged in as "test_admin"
  And I am on vaultpage
  And log event login for user "test_admin" is in log
