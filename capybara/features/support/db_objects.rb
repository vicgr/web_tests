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

  def compare_status(status, privilege: nil, audit: nil,eschrow: nil,alarm: nil,changepass: nil,active: nil,uglist: nil,mail: nil,bad_policy: nil,radius: nil)
    #privilege should be 'read','write' or 'admin'
    #the rest booleans!

    if !privilege.nil?
      if privilege == 'admin'
        if !has_admin
          return false
        end
      elsif privilege == 'write'
        if !has_write
          return false
        end
      elsif privilege == 'read'
        if !has_read
          return false
        end
      else
        return false
        #raise error?
      end
    end

    if !audit.nil?
      if has_audit != audit
        return false
      end
    end

    if !eschrow.nil?
      if has_eschrow != eschrow
        return false
      end
    end

    if !alarm.nil?
      if has_alarm != alarm
        return false
      end
    end

    if !changepass.nil?
      if has_changepass != changepass
        return false
      end
    end

    if !active.nil?
      if is_active != active
        return false
      end
    end

    if !uglist.nil?
      if has_uglist != uglist
        return false
      end
    end

    if !mail.nil?
      if is_mail!=mail
        return false
      end
    end

    if !bad_policy.nil?
      if badpolicy!=bad_policy
        return false
      end
    end

    if !radius.nil?
      if has_radius != radius
        return false
      end
    end

    return true
  end

end
