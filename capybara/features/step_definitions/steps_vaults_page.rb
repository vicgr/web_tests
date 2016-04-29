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
  assert Page_vaults.isObjectInVault(vaultid,itemname),"expected to find object "+itemname+" in vault " +vaultname+", but could not"
  assert C_Support.get_db_handler.auditlog_verify_item_creation(C_Support.get_user_id(username),vaultid,o_id), "no object-creation event for in the log for object"+objectname+ "in vault " + vaultname
end

When(/^I create vault "([^"]*)"$/) do |vaultname|
  assert Page_vaults.create_new_vault(vaultname), "could not create vault "+ vaultname
end

Then(/^new vault "([^"]*)" is in the list of vaults$/) do |vaultname|
  v_id=C_Support.get_db_handler.get_new_vault_id(vaultname)
  assert v_id, "no vault with the name "+vaultname+" seems to exist"
  assert Page_vaults.isVaultInList(v_id),"vault with name "+vaultname+" is not in the list of vaults"
end

When(/^"([^"]*)" copies object "([^"]*)" from "([^"]*)" to "([^"]*)"$/) do |user,objectname, vault_from, vault_to|

  userid = C_Support.get_user_id(user)

  v_from = C_Support.get_vault_id(vault_from)
  v_to = C_Support.get_vault_id(vault_to)
  Page_vaults.openVault(v_from)
  assert Page_vaults.isObjectInVault(v_from,objectname),"expected to find object "+objectname+" in vault " +vault_from+", but could not"
  o_id = C_Support.get_db_handler.get_newest_item_id(v_from,objectname)

  data1= Page_vaults.read_encrypted_data(vault_from,objectname)
  assert data1, "could not read encrypted data from #{objectname} in #{vault_from}"
  assert C_Support.get_db_handler.auditlog_verify_object_decryption(userid, v_from, o_id),"expected decryption event for #{objectname} in #{vault_from} in audit log"

  assert Page_vaults.copy_object(v_from,objectname), "expected to be able to copy object #{objectname} in #{vault_from}"
  assert Page_vaults.paste_object(v_to), "expected to be able to paste object #{objectname} in #{vault_to}"
  assert Page_vaults.isObjectInVault(v_to,objectname),"expected to find object "+objectname+" in vault " +vault_to+", but could not"

  data2 = Page_vaults.read_encrypted_data(vault_to,objectname)
  o_id = C_Support.get_db_handler.get_newest_item_id(v_to,objectname)
  assert data2, "could not read encrypted data from #{objectname} in #{vault_to}"
  assert C_Support.get_db_handler.auditlog_verify_object_decryption(userid, v_to, o_id), "expected decryption event for #{objectname}:#{o_id} in #{vault_to},#{v_to} in audit log"

  assert data1==data2, "expected the copied objects encyypted data to not have changed"

end
When(/^"([^"]*)" moves object "([^"]*)" from "([^"]*)" to "([^"]*)"$/) do |user,objectname, vault_from, vault_to|
  userid = C_Support.get_user_id(user)

  v_from = C_Support.get_vault_id(vault_from)
  v_to = C_Support.get_vault_id(vault_to)
  Page_vaults.openVault(v_from)
  assert Page_vaults.isObjectInVault(v_from,objectname),"expected to find object "+objectname+" in vault " +vault_from+", but could not"
  o_id = C_Support.get_db_handler.get_newest_item_id(v_from,objectname)

  data1= Page_vaults.read_encrypted_data(vault_from,objectname)
  assert data1, "could not read encrypted data from #{objectname} in #{vault_from}"
  assert C_Support.get_db_handler.auditlog_verify_object_decryption(userid, v_from, o_id),"expected decryption event for #{objectname} in #{vault_from} in audit log"

  assert Page_vaults.cut_object(v_from,objectname), "expected to be able to cut object #{objectname} in #{vault_from}"
  assert Page_vaults.paste_object(v_to), "expected to be able to paste object #{objectname} in #{vault_to}"
  assert Page_vaults.isObjectInVault(v_to,objectname),"expected to find object "+objectname+" in vault " +vault_to+", but could not"

  data2 = Page_vaults.read_encrypted_data(vault_to,objectname)
  o_id = C_Support.get_db_handler.get_newest_item_id(v_to,objectname)
  assert data2, "could not read encrypted data from #{objectname} in #{vault_to}"
  assert C_Support.get_db_handler.auditlog_verify_object_decryption(userid, v_to, o_id), "expected decryption event for #{objectname}:#{o_id} in #{vault_to},#{v_to} in audit log"

  assert data1==data2, "expected the copied objects encyypted data to not have changed"
end
