Then(/^log event login for user "([^"]*)" is in log$/) do |user|
  assert C_Support.get_db_handler.auditlog_verify_login(C_Support.get_user_id(user))
end

Then(/^log event logout for user "([^"]*)" is in log$/) do |user|
  assert C_Support.get_db_handler.auditlog_verify_logout(C_Support.get_user_id(user))
end

Then(/^And log event authfailure apikey is in log$/) do |event|
  assert C_Support.get_db_handler.auditlog_verify_authfailure_apikey
end
