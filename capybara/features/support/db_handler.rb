require 'rubygems'
require 'mysql2'
require 'date'

class Db_handler
  @connection = nil

  def get_con
    if @connection.nil?
      db = C_Support.get_db_login
      Mysql2::Client.default_query_options.merge!(:as => :array)
      @connection = Mysql2::Client.new(:host=>db[1],:username=>db[0],:database=>db[2],:password=>db[3])

      set_start_time
    end
    return @connection
  end

  def execute_query(q)
    return get_con.query(q)
  end

  def set_start_time
    execute_query('select NOW()').each do |row|
      @start_time = row[0]
    end
    return @start_time

  end

  def execute_log_query(q)
    q2 = "#{q} and stamp >='#{@start_time}'"
    return execute_query( q2 )
  end

  def is_username_active(un)
    lines=execute_query("select * from ss_userbase where username = '#{un}'").each do |row|
      return Db_status.new(row[1]).is_active
    end
    return false
  end

  def get_user_status_by_id(id)
    execute_query("select * from ss_userbase where id = '#{id}'").each do |row|
      return Db_status.new(row[1])
    end
    return false
  end

  def is_userid_active(id)
    return get_user_status_by_id(id).is_active
  end

  def get_user_by_id(id)
    execute_query("select * from ss_userbase where id = '#{id}'").each do |row|
      return Db_user.new(row)
    end
  end

  def verify_user_is_member_of_vault(u_id,v_id,priv=nil)
    query = "select groupid,userid,status from ss_groupkeys where groupid = #{v_id} and userid = #{u_id}"
    execute_query(query).each do |row|
      if row.nil?
        return false
      end
      if priv.nil? #returns the status as a string
        if Db_status.new(row[2]) .has_admin
          return 'admin'
        elsif  Db_status.new(row[2]) .has_write
          return 'write'
        elsif Db_status.new(row[2]) .has_read
          return 'read'
        end
      else
        if priv == 'admin'
          return Db_status.new(row[2]) .has_admin
        elsif priv == 'write'
          return Db_status.new(row[2]) .has_write
        elsif priov == 'read'
          return Db_status.new(row[2]) .has_read
        end
      end
      return false
    end
  end

  def count_members_of_vault(vaultid,priv=nil)
    query = "select status from ss_groupkeys where groupid=#{vaultid}"
    count = 0
    execute_query(query).each do |row|
      if row.nil?
        return false
      end
      if priv.nil?
        count +=1
      elsif priv == 'admin'
        if Db_status.new(row[0]) .has_admin
          count  +=1
        end
      elsif priv == 'write'
        if Db_status.new(row[0]) .has_write
          count  +=1
        end
      elsif priv == 'read'
        if Db_status.new(row[0]) .has_read
          count  +=1
        end
      end
    end
    return count
  end

  def get_newest_item_id(vaultid,objectname)
    execute_query("select id,status from ss_objects where groupid = #{vaultid} and objectname='#{objectname}'").each do |row|
      if Db_status.new(row[1]) .is_active
        return row[0]
      end
    end
    return false
  end

  def get_new_vault_id(vaultname)
    execute_query("select MAX(id) from ss_groups where groupname = '#{vaultname}'").each do |row|
      return row[0]
    end
    return false
  end

  def get_db_user_status(userid)
    execute_query("select status from ss_userbase where id = #{userid}").each do |row|
      return Db_status.new(row[0])
    end
  end

  def count_objects_in_vault(vaultid)
    nr =0
    execute_query("select status from ss_objects where groupid = #{vaultid}").each do |row|
      if Db_status.new(row[0]) .is_active()
        nr+=1
      end
    end
    return nr
  end

  def auditlog_verify_login(userid) ##Verifies that _any_ login event has happened for the user _after_ @starttime!
    execute_log_query("select id from ss_log where event like '%LOGIN%' and userid = #{userid}").each do |row|
      return row
    end
    return false
  end

  def auditlog_verify_logout(userid) ##Verifies that _any_ logout event has happened for the user _after_ @starttime!
    execute_log_query("select id from ss_log where event like '%LOGOUT%' and userid = #{userid}").each do |row|
      return row
    end
    return false
  end

  def auditlog_verify_authfailure_apikey ##Verifies that _any_ authfailure event has happened _after_ @starttime!
    execute_log_query("select * from ss_log where event like '%AUTHFAILURE (APIKEY)%'").each do |row|
      return row
    end
    return false
  end

  def auditlog_verify_item_creation(userid,vaultid,objectid)
    #execute_log_query
    execute_query("select * from ss_log where userid=#{userid} and groupid=#{vaultid} and objectid=#{objectid} and event like '%OBJECT CREATED%'").each do |row|
      return row
    end
    return false
  end

  def auditlog_verify_vault_creation(userid,vaultname)
    v_id=C_Support.get_db_handler.get_new_vault_id(vaultname)
    execute_log_query("select * from ss_log where userid=#{userid} and groupid = #{v_id} and event like '%VAULT CREATED:#{vaultname}%'").each do |row|
      return row
    end
    return false
  end

  def auditlog_verify_object_decryption(userid, v_id, o_id)
       query = "select id from ss_log where userid=#{userid} and groupid=#{v_id} and objectid=#{o_id} and event like '%ALARM DECRYPTED%'"
       execute_log_query(query).each do |row|
         return row
       end
       return false
     end

   def auditlog_verify_object_copied(userid, v_id_f, o_id, v_id_t)
       query = "select id from ss_log where userid=#{userid} and groupid=#{v_id_f} and objectid=#{o_id} and event like '%COPY TO VAULT: #{v_id_t}%'"
       execute_log_query(query).each do |row|
         return row
       end
       return false
     end

  def auditlog_verify_object_moved(userid, v_id_f, o_id, v_id_t)
    query = "select id from ss_log where userid=#{userid} and groupid=#{v_id_f} and objectid=#{o_id} and event like '%MOVED TO VAULT: #{v_id_t}%'"
    execute_log_query(query).each do |row|
      return row
    end
    return false
  end
  def auditlog_verify_object_deleted(userid, vaultid, objectname)
    query = "select id from ss_log where userid=#{userid} and groupid=#{vaultid} and event like '%OBJECT DELETED:#{objectname}%'"
    print query
    execute_log_query(query).each do |row|
      return row
    end
    return false
  end
end
