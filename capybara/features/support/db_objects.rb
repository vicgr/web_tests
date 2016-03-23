class Db_user

  attr_reader :id
  attr_reader :status
  attr_reader :username
  attr_reader :fullname
  attr_reader :email
  attr_reader :otpprefix
  attr_reader :clientid
  attr_reader :fingerprint
  attr_accessor :password

  def initialize(tup)
    if tup
      @id = tup[0]
      @status = Db_status.new(tup[1])
      @username= tup[2]
      @fullname = tup[3]
      @email = tup[4]
      @otpprefix = tup[5]
      @clientid = tup[6]
      @fingerprint = tup[7]
    end
  end
end

class Db_status
  @status=nil
  def initialize(stat)
    @status = stat.to_i.to_s(2).rjust(12,"0")
  end

  def has_read; @status[11]=='1' end
  def has_write; @status[10]=='1' end
  def has_admin; @status[9]=='1' end
  def has_audit; @status[8]=='1' end
  def has_eschrow; @status[7]=='1' end
  def has_alarm; @status[6]=='1' end
  def has_changepass; @status[5]=='1' end
  def is_active; @status[4]=='1' end
  def has_uglist; @status[3]=='1' end
  def is_mail; @status[2]=='1' end
  def badpolicy; @status[1]=='1' end
  def has_radius; @status[0]=='1' end

  def status; @status end

end
