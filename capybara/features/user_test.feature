Feature: User testing of cucumber and capybara
  For testing the frameworks by their usability.

  @usability_test
  Scenario: login to Storedsafe and then logout
     #exempel:
     Given I am on the login page
     When user "test_admin" logs in to storedsafe
     Then the user "test_admin" is logged in to storedsafe
     When I click the logout button
     Then I should be on the login page
