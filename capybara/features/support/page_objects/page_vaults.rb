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


end
