import mysql.connector
import os
import sys

a = input("enter password for db")
cnx = mysql.connector.connect(user='victor', host ='t1.storedsafe.com',database='storedsafe',password = a)
cursor = cnx.cursor()

class db_user():
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


def get_user_status():
    #user-tuple:
    #{id, status, username, fullname, email, otp prefix, client-id, fingerprint
    
    #status:
    cursor.execute ("select * from ss_userbase where username = 'Victor'")

    #print ("found "+cursor.rowcount+" rows with username = victor")
    if cursor.rowcount == 0:
        return
    
    u = []
    for i in cursor:
        u.append(db_user(i))

    for i in u:
        if i.status.is_active():
            print("user:",i.username,"found active")
        

def ex_(qu):
    cursor.execute(qu)

    print("result:")

    for i in cursor:
        print(i)

def cls():
    os.system('cls' if os.name == 'nt' else 'clear')

q = "show tables"
ex_(q)

while True:
    q=input("enter next command: ")

    if(q == 'u'):
        get_user_status()
        break
    
    if(q == 'q' or q == 'quit' or q == 'exit'):
        print("closing")
        break
    if(q == 'clear' or q=='clr' or q=='cls'):
        cls()
    else:
        try:
            ex_(q)
        except:
            print(sys.exc_info()[0])
    
cnx.close()
