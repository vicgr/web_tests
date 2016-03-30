Then(/^log event login for user "([^"]*)" is in log$/) do |user|
  assert C_Support.get_db_handler.auditlog_verify_login(C_Support.get_user_id(user))
end

Then(/^log event logout for user "([^"]*)" is in log$/) do |user|
  assert C_Support.get_db_handler.auditlog_verify_logout(C_Support.get_user_id(user))
end

Then(/^log event authfailure apikey is in log$/) do
  assert C_Support.get_db_handler.auditlog_verify_authfailure_apikey
end

Given(/^"([^"]*)" is a member of vault "([^"]*)"$/) do |user, vault|
  assert C_Support.get_db_handler.verify_user_is_member_of_vault(C_Support.get_user_id(user),C_Support.get_vault_id(vault))
end
