class Page_vaults < Page_logged_in
  def self.isAtVaultsPage
    #verify on right path
    if Capybara.app_host+'groups.php' != current_url.split('#')[0]
      return false
    end
    #verify on a page with a div where id=objectlistwindow
    return has_css?("[id='objectlistwindow']")

    def self.open_vault(v_id)
    end
    def self.is_vault_open?(v_id)
      $stdout.puts find('bartitle'+v_id)['class']
    end
  end

end
