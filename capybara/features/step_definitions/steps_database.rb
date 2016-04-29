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

Given(/^"([^"]*)" is a "([^"]*)" member of vault "([^"]*)"$/) do |user, privilege, vault|
  assert C_Support.get_db_handler.verify_user_is_member_of_vault(C_Support.get_user_id(user),C_Support.get_vault_id(vault),privilege)
end

Given(/^"([^"]*)" has privilege "([^"]*)", audit = "([^"]*)", ug\-list="([^"]*)"$/) do |user, prv, aud, ugl|
  status = C_Support.get_db_handler.get_db_user_status(C_Support.get_user_id(user))
  prv=='true' ? prv=true : prv=false
  aud=='true' ? aud=true : aud=false
  ugl=='true' ? ugl=true : ugl=false
  assert status.compare_status(privilege:prv,has_audit:aud,has_uglist:ugl)
end

Then(/^log event vault created for user "([^"]*)" for vault "([^"]*)" is in log$/) do |username, vaultname|
  userid = C_Support.get_user_id(username)
  assert C_Support.get_db_handler.auditlog_verify_vault_creation(userid,vaultname),"no vault-creation event in the log for vault " + vaultname
end

Then(/^log event object "([^"]*)" copied by "([^"]*)", from "([^"]*)" to "([^"]*)"$/) do |objectname, username, vault_from, vault_to|
  userid = C_Support.get_user_id(username)
  v_id_f = C_Support.get_vault_id(vault_from)
  v_id_t = C_Support.get_vault_id(vault_to)
  o_id = C_Support.get_object_id(v_id_f,objectname)
  assert C_Support.get_db_handler.auditlog_verify_object_copied(userid, v_id_f, o_id, v_id_t)
end

Then(/^log event object "([^"]*)" moved by "([^"]*)", from "([^"]*)" to "([^"]*)"$/) do |objectname, username, vault_from, vault_to|
  userid = C_Support.get_user_id(username)
  v_id_f = C_Support.get_vault_id(vault_from)
  v_id_t = C_Support.get_vault_id(vault_to)
  o_id = C_Support.get_object_id(v_id_f,objectname)
  assert C_Support.get_db_handler.auditlog_verify_object_moved(userid, v_id_f, o_id, v_id_t)
end
