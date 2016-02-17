require 'capybara/cucumber'

Capybara.default_driver = :selenium
Capybara.app_host = "https://t1.storedsafe.com/"
Capybara.run_server = false
