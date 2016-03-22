require 'rubygems'
require 'mysql'

class Db_handler
  @connection = nil

  def get_con
    if @connection.nil?
      db = C_Support.get_db_login
      @connection = Mysql.new db[1],db[0],db[3],db[2]
      return @connection
    end
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
end
