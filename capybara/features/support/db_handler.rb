require 'rubygems'
require 'mysql'

class Db_handler
  @connection = nil

  def get_con
    if @connection.nil?
      db = C_Support.get_db_login
      @connection = Mysql.new db[1],db[0],db[3],db[2]
      set_start_time
      $stdout.puts @start_time
    end
    return @connection
  end

  def set_start_time
    @start_time = execute_query('select NOW()').fetch_row[0]
  end

  def execute_log_query(q)
    return execute_query("{#{q} and stamp >= {#{@start_time}}}")
  end

  def execute_query(q)
    return get_con.query(q)
  end

  def is_username_active(un)
    lines=execute_query("select * from ss_userbase where username = '#{un}'")
    lines.num_rows.times do
      if Db_status.new(lines.fetch_row[1]).is_active
        return true
      end
    end
    return false
  end

  def is_userid_active(id)
    line=execute_query("select * from ss_userbase where id = #{id}")
    return Db_status.new(line.fetch_row[1]).is_active
  end

  def auditlog_verify_login(userid)
    query = "select id from ss_log where log like '%LOGIN%' and userid =#{userid}"
    lines = execute_log_query(query)
    
end
