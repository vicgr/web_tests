

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
  And "test_admin" has privilege "admin", audit = "true", ug-list="true"
  And "test_admin" is a "admin" member of vault "v_test_vault_1"
  When I login as "test_admin"
  Then I should be logged in as "test_admin"
  And I am on vaultpage
  And log event login for user "test_admin" is in log
  And I am logged in with privileges "admin", with audit = "true" and ug-list = "true"
  #Given vault "v_test_vault_1" is in the list of vaults
  #When I open vault "v_test_vault_1"

@item
Scenario: create item
  Given I am on loginpage
  And I login as "test_admin"
  Then log event login for user "test_admin" is in log
  And I open vault "v_test_vault_1"
  And "test_admin" creates new item "v_test_object_2" of type "server" in vault "v_test_vault_1"
  #And "test_admin" creates vault "v_test_vault_2"
