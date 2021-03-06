Given(/^vault "([^"]*)" is in the list of vaults$/) do |vaultname|
  vaultid = C_Support.get_vault_id(vaultname)
  assert Page_vaults .isVaultInList(vaultid),"#{vaultname} with id #{vaultid} was expected to be in the list of vaults: it was not"
end

When(/^I open vault "([^"]*)"$/) do |vaultname|
  Page_vaults.openVault(C_Support.get_vault_id(vaultname))
  assert Page_vaults.isVaultOpen?(C_Support.get_vault_id(vaultname)), vaultname+" was supposed to be open: it was not"
end

When(/^"([^"]*)" creates new item "([^"]*)" of type "([^"]*)" in vault "([^"]*)"$/) do |username, itemname, itemtype, vaultname|

  vaultid=C_Support.get_vault_id(vaultname)

  if itemtype == 'server'
    assert Page_vaults.create_new_item_server(vaultid,itemname), "the server-object named "+ itemname +" could not be created"
    #add more...
  end
  Page_vaults.closeVault(vaultid)
  Page_vaults.openVault(vaultid)
  o_id = C_Support.get_db_handler.get_newest_item_id(vaultid,itemname)
  assert o_id != false, "no item called "+itemname+" was found in "+vaultname
  assert Page_vaults.isObjectInVault(vaultid,itemname),"expected to find object "+itemname+" in vault " +vaultname+", but could not"
  assert C_Support.get_db_handler.auditlog_verify_item_creation(C_Support.get_user_id(username),vaultid,o_id), "no object-creation event for in the log for object"+itemname+ "in vault " + vaultname
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
  if not data1.is_a?(Array)
    assert C_Support.get_db_handler.auditlog_verify_object_decryption(userid, v_from, o_id),"expected decryption event for #{objectname} in #{vault_from} in audit log"
  end


  assert Page_vaults.copy_object(v_from,objectname), "expected to be able to copy object #{objectname} in #{vault_from}"
  assert Page_vaults.paste_object(v_from,v_to), "expected to be able to paste object #{objectname} in #{vault_to}"
  assert Page_vaults.isObjectInVault(v_to,objectname),"expected to find object "+objectname+" in vault " +vault_to+", but could not"

  if not data1.is_a?(Array)
    data2 = Page_vaults.read_encrypted_data(vault_to,objectname)
    o_id = C_Support.get_db_handler.get_newest_item_id(v_to,objectname)
    assert data2, "could not read encrypted data from #{objectname} in #{vault_to}"
    assert C_Support.get_db_handler.auditlog_verify_object_decryption(userid, v_to, o_id), "expected decryption event for #{objectname}:#{o_id} in #{vault_to},#{v_to} in audit log"

    assert data1==data2, "expected the copied objects encyypted data to not have changed"
  end
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
  assert Page_vaults.paste_object(v_from,v_to), "expected to be able to paste object #{objectname} in #{vault_to}"
  assert Page_vaults.isObjectInVault(v_to,objectname),"expected to find object "+objectname+" in vault " +vault_to+", but could not"

  data2 = Page_vaults.read_encrypted_data(vault_to,objectname)

  assert data2, "could not read encrypted data from #{objectname} in #{vault_to}"
  assert C_Support.get_db_handler.auditlog_verify_object_decryption(userid, v_to, o_id), "expected decryption event for #{objectname}:#{o_id} in #{vault_to},#{v_to} in audit log"

  assert data1==data2, "expected the copied objects encyypted data to not have changed"
end

When(/^"([^"]*)" deletes object "([^"]*)" in vault "([^"]*)"$/) do |username, objectname, vaultname|
  userid = C_Support.get_user_id (username)
  vaultid = C_Support.get_vault_id(vaultname)
  objectid = C_Support.get_object_id(vaultid,objectname)
  Page_vaults.openVault(vaultid)
  assert Page_vaults.isObjectInVault(vaultid,objectname), "expected to find object "+objectname+" in vault " +vaultname+", but could not"
  Page_vaults.delete_object(vaultid,objectid,C_Support.get_object_type(objectname))
  assert Page_vaults.isObjectNotInVault(vaultid,objectname), "expected to not find #{objectname} in #{vaultname}, but did find it"
end

When(/^"([^"]*)" tries to delete non\-empty vault "([^"]*)"$/) do |username, vaultname|
  userid = C_Support.get_user_id(username)
  vaultid = C_Support.get_vault_id(vaultname)

  assert C_Support.get_db_handler.verify_user_is_member_of_vault(userid,vaultid,"admin"), "Expected user #{username} to be admin member of vault #{vaultname}"
  assert C_Support.get_db_handler.count_objects_in_vault(vaultid) > 0 , "Expected to find objects in vault #{vaultname}, but could not"
  assert Page_vaults.delete_vault(vaultid), "Expected to be able to complete delete vault procedure steps, but it failed"
  assert Page_vaults.verify_delete_vault_failed(vaultid),"Could not verify that the vault deletion of #{vaultname} failed!"
end

When(/^user "([^"]*)" tries to leave vault "([^"]*)" as the last admin$/) do |username, vaultname|
  #assumes user is member of vault verified
  #assumes user is admin in vault verified

  userid = C_Support.get_user_id(username)
  vaultid = C_Support.get_vault_id(vaultname)
  assert C_Support.get_db_handler.count_members_of_vault(vaultid,'admin') == 1

  assert Page_vaults.isAtVaultsPage()

  assert Page_vaults.leave_vault(userid,vaultid),"Expected to be able to complete the leave vault procedure, but it failed"
  assert Page_vaults.verify_leave_vault_failed(vaultid),"Could not verify that the leave-vault procedure failed!"
end

When(/^user "([^"]*)" deletes vault "([^"]*)" with any number of objects$/) do |username, vaultname|
  userid = C_Support.get_user_id (username)
  vaultid = C_Support.get_vault_id(vaultname)
  assert C_Support.get_db_handler.verify_user_is_member_of_vault(userid,vaultid,"admin"), "Expected user #{username} to be admin member of vault #{vaultname}"
  assert Page_vaults.isAtVaultsPage()
  objects = C_Support.get_db_handler.get_all_active_object_names_in_vault(vaultid)
  assert Page_vaults.delete_all_objects_in_vault(vaultid),"Could not verify the deletion of all objects in #{vaultname}"
  for o in objects
    C_Support.get_db_handler.auditlog_verify_object_deleted(userid,vaultid,o)
  end
  assert Page_vaults.delete_vault(vaultid),"Could not verify the deletion of vault #{vaultname}"
end

Then(/^user "([^"]*)" has deleted vault "([^"]*)"$/) do |username, vaultname|
  userid = C_Support.get_user_id (username)
  vaultid = C_Support.get_vault_id(vaultname)
  $stdout.puts "#{userid},#{vaultid},#{vaultname}"
  assert Page_vaults.verify_delete_vault_succeded(vaultname),"Could not verify that the vault #{vaultname} has been deleted"
  assert C_Support.get_db_handler.auditlog_verify_vault_deleted(userid,vaultid,vaultname),"Could not verify that the auditlog logged the deletion of #{vaultname}"
end

When(/^I read encrypted information of "([^"]*)" in "([^"]*)" where info should be "([^"]*)"$/) do |objectname, vaultname, info|
  vaultid = C_Support.get_vault_id(vaultname)
  objectid = C_Support.get_object_id(vaultid,objectname)
  assert Page_vaults.isAtVaultsPage()
  decrypted = Page_vaults.read_encrypted_data(vaultname,objectname)
  assert info == decrypted, "Could not verify that the decrypted info of #{objectname} is the same as the provided info"

end
