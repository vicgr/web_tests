#require 'spec_helper'
require 'capybara'

Capybara.app_host = "https://t1.storedsafe.com/"
Capybara.run_server = false
Capybara.default_driver = :selenium

session = Capybara::Session.new :selenium
session.visit("")


Capybara.


if session.has_title? session.title do
  puts "yas"
end
puts "no"


end
