class Page_vaults < Page_logged_in
  def self.isAtVaultsPage
    #verify on right path
    if Capybara.app_host+'groups.php' != current_url
      return false
    end
    #verify on a page with a div where id=objectlistwindow
    return has_css?("[id='objectlistwindow']")
  end
end
