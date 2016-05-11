

Feature: Test Login

@admin_smoke
Scenario: admin smoke test
  Given I am on loginpage
  And I login as "test_admin"
  Then I should be logged in as "test_admin"
  And I am logged in with privileges "admin", with audit = "true" and ug-list = "true"
  And log event login for user "test_admin" is in log
  And I open vault "v_test_vault_1"

  And "test_admin" creates new item "v_test_object_2" of type "server" in vault "v_test_vault_1"

  When I create vault "v_test_vault_2"
  Then new vault "v_test_vault_2" is in the list of vaults
  And log event vault created for user "test_admin" for vault "v_test_vault_2" is in log

  When "test_admin" copies object "v_test_object_1.pdf" from "v_test_vault_1" to "v_test_vault_2"
  Then log event object "v_test_object_1.pdf" copied by "test_admin", from "v_test_vault_1" to "test_vault_2"

  When "test_admin" moves object "v_test_object_2" from "v_test_vault_1" to "v_test_vault_2"
  Then log event object "v_test_object_2" moved by "test_admin", from "v_test_vault_1" to "v_test_vault_2"

  When "test_admin" deletes object "v_test_object_2" in vault "v_test_vault_2"
  Then log event object "v_test_object_2" in vault "v_test_vault_2" deleted by "test_admin"

  When "test_admin" tries to delete non-empty vault "v_test_vault_2"
  Then vault "v_test_vault_2" is in the list of vaults

  When user "test_admin" is the only admin in "v_test_vault_2"
  And user "test_admin" tries to leave vault "v_test_vault_2" as the last admin
  Then user "test_admin" is the only admin in "v_test_vault_2"

  When user "test_admin" deletes vault "v_test_vault_2" with any number of objects
  Then user "test_admin" has deleted vault "v_test_vault_2"



@item
Scenario: test set
  Given I am on loginpage
  And I login as "test_admin"

  And I create vault "v_test_vault_2"
  Then "test_admin" copies object "v_test_object_1.pdf" from "v_test_vault_1" to "v_test_vault_2"
  And log event object "v_test_object_1.pdf" copied by "test_admin", from "v_test_vault_1" to "test_vault_2"
