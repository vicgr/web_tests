require 'capybara/cucumber'
require 'minitest/autorun'
require 'capybara/poltergeist'

#Capybara.default_driver = :selenium
Capybara.default_driver =:poltergeist
Capybara.app_host = "https://t1.storedsafe.com/"
Capybara.run_server = false
Capybara.current_session.instance_variable_set(:@touched, false)
Capybara.ignore_hidden_elements = false
include Capybara::DSL

class C_Support
  def self.Get_next_yubikey
    puts "press yubikey"
    return $stdin.gets
  end
end
