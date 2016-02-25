class stored_user():

	def __init__(self,tup):
		self.id = tup[0]
		self.status = obj_status(tup[1])
		self.username= tup[2]
		self.fullname = tup[3]
		self.email = tup[4]
		self.otpprefix = tup[5]
		self.clientid = tup[6]
		self.fingerprint = tup[7]


class obj_status():
	def __init__(self,s):
		self.status = bin(s)[2:]
		self.status = "0"*(12-len(self.status))+self.status
	def has_read(self):
		return self.status[11]=='1'
	def has_write(self):
		return self.status[10]=='1'
	def has_admin(self):
		return self.status[9]=='1'
	def has_audit(self):
		return self.status[8]=='1'
	def has_eschrow(self):
		return self.status[7]=='1'
	def has_alarm(self):
		return self.status[6]=='1'
	def has_changepass(self):
		return self.status[5]=='1'
	def is_active(self):
		return self.status[4]=='1'
	def has_uglist(self):
		return self.status[3]=='1'
	def is_mail(self):
		return self.status[2]=='1'
	def badpolicy(self):
		return self.status[1]=='1'
	def has_radius(self):
		return self.status[0]=='1'
	def _get(self):
		return self.status
	def _set(self,s):
		self.status = bin(s)[2:]
		self.status = "0"*(12-len(self.status))+self.status