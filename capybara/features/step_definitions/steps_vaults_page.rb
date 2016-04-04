Given(/^vault "([^"]*)" is in the list of vaults$/) do |vaultname|
  assert Page_vaults .isVaultInList(C_Support.get_vault_id(vaultname))
end

When(/^I open vault "([^"]*)"$/) do |vaultname|
  Page_vaults.openVault(C_Support.get_vault_id(vaultname))
  assert Page_vaults.isVaultOpen?(C_Support.get_vault_id(vaultname))
end
