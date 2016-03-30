require 'rubygems'
require 'mysql2'
require 'date'

class Db_handler
  @connection = nil

  def get_con
    if @connection.nil?
      db = C_Support.get_db_login
      #@connection = Mysql.new db[1],db[0],db[3],db[2]
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
    return execute_query( "#{q} and stamp >='#{@start_time}'")
  end

  def is_username_active(un)
    lines=execute_query("select * from ss_userbase where username = '#{un}'").each do |row|
      return Db_status.new(row[1]).is_active
    end
    return false
  end

  def is_userid_active(id)
    execute_query("select * from ss_userbase where id = '#{id}'").each do |row|
      return Db_status.new(row[1]).is_active
    end
    return false
  end

  def get_user_by_id(id)
    execute_query("select * from ss_userbase where id = '#{id}'").each do |row|
      return Db_user.new(row)
    end
  end

  def verify_user_is_member_of_vault(u_id,v_id)
    execute_query("select groupid,userid from ss_groupkeys where groupid = #{v_id} and userid = #{u_id}").each do |row|
      return row
    end
    return false
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

end
