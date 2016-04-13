#!python3
import json

class stored_user():

    def compare(self,user):
        if self.id == user.id and \
            self.status.compare(user.status) and \
            self.username== user.username and \
            self.fullname == user.fullname and \
            self.email == user.email and \
            self.otpprefix ==  user.otpprefix and \
            self.clientid ==  user.clientid and \
            self.fingerprint == user.fingerprint:
            return True
        else:
            return False

    def __init__(self,tup=None):
        self.password = None
        if tup is not None:
            self.id = tup[0]
            self.status = obj_status(tup[1])
            self.username= tup[2]
            self.fullname = tup[3]
            self.email = tup[4]
            self.otpprefix = tup[5]
            self.clientid = tup[6]
            self.fingerprint = tup[7]

    def initWithJson(self,o):
        self.id=o["id"]
        self.status = o["status"]
        self.username=o["username"]
        self.fullname=o["fullname"]
        self.email=o["email"]
        self.otpprefix=o["otpprefix"]
        self.clientid=o["clientid"]
        self.fingerprint=o["fingerprint"]
        self.password = o["password"]

    def __dict__(self):

        return dict(
            __type__='User',id =self.id,username=self.username,fullname = self.fullname,email =self.email,
            otpprefix = self.otpprefix, clientid = self.clientid, fingerprint = self.fingerprint,
            status = self.status._get()
        )



class obj_status():

    def __init__(self,s=None):
        if s is not None:
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
        return ""+self.status
    def _set(self,s):
        self.status = bin(s)[2:]
        self.status = "0"*(12-len(self.status))+self.status

    def fromjson(self,s):
        self.status = s

    def compare(self,obj):
        return type(obj) == type(self) and self.status == obj.status