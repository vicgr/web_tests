class Page_logged_in
  def self.isLoggedIn(fullname)

    return has_content? fullname

  end
end
