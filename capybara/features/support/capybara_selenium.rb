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

  @@dblogin = nil
  @@dbhandler = nil

  @@users = nil
  @@vaults = nil
  @@newvaults = nil
  @@vaultmembers = nil
  @@newitem_servers = nil
  @@objects = nil
  @@objecttypes = nil

  def self.load_file
    @@users = Hash .new
    @@vaults = Hash .new
    @@newvaults = Hash .new
    @@vaultmembers = Hash .new {|h,k| h[k]=[]}
    @@newitem_servers = Hash .new
    @@objects = Hash .new
    @@objecttypes = Hash .new

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
          @@objecttypes.store(obj['itemname'].chomp,obj['type'].chomp)
          if obj['itemtype'] == 'server'
            @@newitem_servers.store(obj['itemname'].chomp, [obj['host'].chomp,obj['username'].chomp,obj['password'].chomp,obj['alert if decrypted'].chomp=="True",obj['information'].chomp,obj['sensitive information'].chomp])
          end
        elsif obj['__type__'] == 'newvault'
          @@newvaults.store(obj['vaultname'].chomp,[obj['policy'].chomp,obj['information'].chomp])
        elsif obj['__type__'] == 'object'
          @@objecttypes.store(obj['objectname'].chomp,obj['objecttype'].chomp)
          @@objects.store(obj['objectname'].chomp,[obj['vaultid'].chomp,obj['objectid'].chomp])
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
    begin
      return @@vaults.fetch(vault)
    rescue KeyError
      return get_db_handler.get_new_vault_id(vault)
    end
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
  def self.get_newvault_info(vaultname)
    if @@newvaults.nil?
      load_file
    end
    return @@newvaults.fetch(vaultname)
  end
  def self.get_object_id(vaultid,objectname)
    if @@objects.nil?
      load_file
    end
    begin
      return @@objects.fetch(objectname)[1]
    rescue KeyError
      return get_db_handler.get_newest_item_id(vaultid,objectname)
    end
  end
  def self.get_object_type(objectname)
    if @@objecttypes.nil?
      load_file
    end
    return @@objecttypes.fetch(objectname)
  end
end

do_capybara_setup
