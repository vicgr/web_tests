require 'capybara/cucumber'
require 'minitest/autorun'
require 'capybara/poltergeist'

#Capybara.default_driver = :selenium
Capybara.default_driver =:poltergeist
Capybara.app_host = "https://t1.storedsafe.com/"
Capybara.run_server = false
Capybara.current_session.instance_variable_set(:@touched, false)