class Page_vaults < Page_logged_in
  def self.isAtVaultsPage
    #verify on right path
    if Capybara.app_host+'groups.php' != current_url.split('#')[0]
      return false
    end
    #verify on a page with a div where id=objectlistwindow
    return has_css?("[id='objectlistwindow']")
  end
  def self.isVaultInList(v_id)
    begin
      has_css?("[id = 'bartitle#{v_id}']")
    rescue
      return false
    end
    return true
  end

  def self.openVault(v_id)
    if !isVaultOpen?(v_id)
      find(:css, "[id = 'bartitle#{v_id}']").click
    end
  end

  def self.isVaultOpen?(v_id)
    return find(:css, "[id = 'bartitle#{v_id}']")['class'] == 'bars _on'
  end

  def self.isLoggedInAsAdmin
    has_css?("[id = 'newgroup']") && has_css?("[id = 'users']")
  end
  def self.isLoggedInAsWrite
    has_css?("[id = 'newgroup']") && !has_css?("[id = 'users']")
  end
  def self.isLoggedInAsRead
    !has_css?("[id = 'newgroup']") && !has_css?("[id = 'users']")
  end
  def self.hasAudit
    return has_css?("[id='audit']")
  end
  def self.hasUgList
    #how?
    #divide on admin, write, read?
    return true
  end

  def self.isObjectInVault(vaultid,objectname)
    return find(:css,"[id=bar#{vaultid}]").has_content?(objectname)
  end

  def self.create_new_item_server(vaultid, itemname)
    openVault(vaultid)
    click_button "bar#{vaultid}add"
    choose 'templateid1'
    click_button "cont#{vaultid}"
    itemdata = C_Support.get_newitem_server(itemname)
    fill_in 'host',:with=> itemname
    fill_in 'username',:with=> itemdata[1]
    if itemdata[2]== ''
      click_button 'gen'
    else
      fill_in 'password',:with => itemdata[2]
    end
    if itemdata[3]
      check 'password_alarm'
    end
    fill_in 'info',:with=>itemdata[4]
    fill_in 'cryptedinfo',:with=>itemdata[5]
    click_button 'submitbutton'
    return true
  end

  def self.create_new_vault(vaultname)
    vaultdata = C_Support.get_newvault_info(vaultname)
    click_button "newgroup"
    fill_in 'groupname',:with=>vaultname
    select vaultdata[0], :from=> 'policy'
    fill_in 'info',:with=>vaultdata[1]
    click_button 'submitbutton'
    return true
  end

  def self.read_encrypted_data(vaultname,objectname)
    v_id = C_Support.get_vault_id(vaultname)
    self.openVault(v_id)
    o_id = C_Support.get_object_id(v_id,objectname)
    decrypted = false
    if has_css? ("[id*=':#{o_id}:']")
      el = find(:css,"[id*=':#{o_id}:']")
      el .click
      decrypted = el.find(:css,"[class='obfuscate']").text
    end
    return decrypted
  end

  def self.copy_object(vault_from_id,objectname)
    self.openVault(vault_from_id)
    o_type = C_Support.get_object_type(objectname)
    objectid = C_Support.get_object_id(vault_from_id,objectname)
    check "mod_#{vault_from_id}_#{o_type}_#{objectid}"
    find(:css, "[id='copy_#{vault_from_id}']") .click
    return true
  end

  def self.paste_object(vault_to_id)
    self.openVault(vault_to_id)
    find(:css, "[id='paste_#{vault_to_id}']") .click
    page.driver.browser.switch_to.alert .accept
    return true
  end

end
