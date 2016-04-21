Given(/^vault "([^"]*)" is in the list of vaults$/) do |vaultname|
  assert Page_vaults .isVaultInList(C_Support.get_vault_id(vaultname)),vaultname +"with id "+C_Support.get_vault_id(vaultname) +" was expected ot be in the list of vaults: it was not"
end

When(/^I open vault "([^"]*)"$/) do |vaultname|
  Page_vaults.openVault(C_Support.get_vault_id(vaultname))
  assert Page_vaults.isVaultOpen?(C_Support.get_vault_id(vaultname)), vaultname+" was supposed to be open: it was not"
end

#Note - this step only work for vaults that exist before testing begins, not newly created vaults
When(/^"([^"]*)" creates new item "([^"]*)" of type "([^"]*)" in vault "([^"]*)"$/) do |username, itemname, itemtype, vaultname|

  vaultid=C_Support.get_vault_id(vaultname)

  if itemtype == 'server'
    assert Page_vaults.create_new_item_server(vaultid,itemname), "the server-object named "+ itemname +" could not be created"
    #add more...
  end
  o_id = C_Support.get_db_handler.get_newest_item_id(vaultid,itemname)
  assert o_id != false, "no item called "+itemname+" was found in "+vaultname
  assert Page_vaults.isObjectInVault(vaultid,itemname),"expected to find object "+itemname+" in vault" +vaultname+", but could not"
  assert C_Support.get_db_handler.auditlog_verify_item_creation(C_Support.get_user_id(username),vaultid,o_id), "no object-creation event for in the log for object"+objectname+ "in vault " + vaultname
end

When(/^I create vault "([^"]*)"$/) do |vaultname|
  assert Page_vaults.create_new_vault(vaultname), "could not create vault "+ vaultname
end

Then(/^new vault "([^"]*)" is in the list of vaults$/) do |vaultname|
  $stdout.puts "implement vaultlist verification step"
  v_id=C_Support.get_db_handler.get_new_vault_id(vaultname)
  assert v_id, "no vault with the name "+vaultname+" seems to exist"
  assert Page_vaults.isVaultInList(v_id),"vault with name "+vaultname+" is not in the list of vaults"
end

Then(/^log event vault created for user "([^"]*)" for vault "([^"]*)" is in log$/) do |username, vaultname|
  userid = C_Support.get_user_id(username)
  assert C_Support.get_db_handler.auditlog_verify_vault_creation(userid,vaultname),"no vault-creation event in the log for vault " + vaultname
end
