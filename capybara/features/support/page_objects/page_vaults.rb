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

end
