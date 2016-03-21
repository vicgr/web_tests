require 'rubygems'
require 'mysql'

class Db_handler
  @connection = nil
  "def initialization
    db = C_Support.get_db_login
    @connection = Mysql.new db[1],db[0],db[3],db[2]
  end"

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
    q = "select * from ss_userbase where username = '#{un}'"
    lines=execute_query(q)
    lines.num_rows.times do
      $stdout.puts lines.fetch_row.join("\s")
    end
    return true
  end

  def is_userid_active(id)
    true
  end
end
