require 'capybara'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'json'
require 'selenium-webdriver'
require 'capybara/dsl'
require 'minitest/autorun'


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
  @@vaultmembers = nil
  @@dbhandler = nil
  @@vaults = nil
  @@newitem_servers = nil

  def self.load_file
    @@users = Hash .new
    @@vaults = Hash .new
    @@newitem_servers = Hash .new
    @@vaultmembers = Hash .new {|h,k| h[k]=[]}
    File.open('../safe_stored.txt','r') do |f|
      while l = f.gets
        obj = JSON.parse(l)

        if obj['__type__'] == 'userlogin'
          @@users.store(obj['username'].chomp, [obj['id'].chomp, obj['password'].chomp+obj['otp'].chomp])
        elsif obj['__type__'] == 'DbInfo'
          @@dblogin =[obj['user'],obj['host'],obj['database'],obj['password']]
        elsif obj['__type__'] == 'vaultmember'
          @@vaultmembers[obj['username']] << obj['vaultname']
        elsif obj['__type__'] == 'vault'
          @@vaults.store(obj['vaultname'],obj['vaultid'])
        elsif obj['__type__'] == 'newitem'
          if obj['itemtype'] == 'server'
            @@newitem_servers.store(obj['itemname'].chomp, [obj['host'].chomp,obj['username'].chomp,obj['password'].chomp,obj['alert if decrypted'].chomp=="True",obj['information'].chomp,obj['sensitive information'].chomp])
          end
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
  def self.get_vault_id(vault)
    if @@vaults.nil?
      load_file
    end
    return @@vaults.fetch(vault)
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
  def self.get_newitem_server(itemname)
    if @@newitem_servers.nil?
      load_file
    end
    return @@newitem_servers.fetch(itemname)
  end
end

do_capybara_setup
