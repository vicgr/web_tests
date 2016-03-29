require 'capybara'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'json'
require 'selenium-webdriver'
require 'capybara/dsl'


def do_capybara_setup
  include Capybara::DSL
  set_driver
  Capybara.app_host = "https://t1.storedsafe.com/"
  Capybara.run_server = false
  Capybara.current_session.instance_variable_set(:@touched, false)
  Capybara.ignore_hidden_elements = false
end

class C_Support
  @@driver = nil
  def self.driver=(val)
    @@driver = val
  end
  def self.driver
    return @@driver
  end

  @@users = nil
  @@dblogin = nil
  @@dbhandler = nil

  def self.load_file
    @@users = Hash .new
    File.open('../safe_stored.txt','r') do |f|
      while l = f.gets
        obj = JSON.parse(l)

        if obj['__type__'] == 'userlogin'
          @@users.store(obj['username'].chomp, [obj['id'].chomp, obj['password'].chomp+obj['otp'].chomp])
        end
        if obj['__type__'] == 'DbInfo'
          @@dblogin =[obj['user'],obj['host'],obj['database'],obj['password']]
        end

      end
    end
  end
  def self.Get_next_yubikey
    puts "press yubikey"
    return $stdin.gets.chomp
  end
  def self.get_login(user)
    if @@users.nil?
      load_file
    end
    return @@users.fetch(user)[1]
  end
  def self.get_user_id(user)
    if @@users.nil?
      load_file
    end
    return @@users.fetch(user)[0]
  end
  def self.get_db_handler
    if @@dbhandler.nil?
      @@dbhandler = Db_handler .new
    end
    return @@dbhandler
  end
  def self.get_db_login
    if @@dblogin.nil?
      load_file
    end
    return @@dblogin
  end
end

do_capybara_setup
