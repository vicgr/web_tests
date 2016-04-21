Given(/^vault "([^"]*)" is in the list of vaults$/) do |vaultname|
  assert Page_vaults .isVaultInList(C_Support.get_vault_id(vaultname))
end

When(/^I open vault "([^"]*)"$/) do |vaultname|
  Page_vaults.openVault(C_Support.get_vault_id(vaultname))
  assert Page_vaults.isVaultOpen?(C_Support.get_vault_id(vaultname))
end

When(/^"([^"]*)" creates new item "([^"]*)" of type "([^"]*)" in vault "([^"]*)"$/) do |username, itemname, itemtype, vaultname|

  vaultid=C_Support.get_vault_id(vaultname)

  if itemtype == 'server'
    assert Page_vaults.create_new_item_server(vaultid,itemname)
    #add more...
  end
  o_id = C_Support.get_db_handler.get_newest_item_id(vaultid,itemname)
  assert o_id != false
  assert Page_vaults.isObjectInVault(vaultid,itemname)
  assert C_Support.get_db_handler.auditlog_verify_item_creation(C_Support.get_user_id(username),vaultid,o_id)
end

Given(/^"([^"]*)" creates vault "([^"]*)"$/) do |username, vaultname|
  userid=C_Support.get_user_id(username)

end
