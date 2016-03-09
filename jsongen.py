import json

class s_db:
    def __init__(self,user,host,db,password):
        self.user = user
        self.host = host
        self.database = db
        self.password = password
    
        

class s_user:
    def __init__(self,username,fullname,password,email,p,h_a,h_u,h_c,a):
        self.username = username
        self.fullname = fullname
        self.password = password
        self.email = email
        self.privilege = p
        self.has_Audit = h_a
        self.has_UG = h_u
        self.has_Changepass = h_c
        self.is_Active = a
        
    def get_dict(self):
        return dict(__type__= "User", username = self.username,
                    fullname = self.fullname, password =self.password,
                    email = self.email, privilege = self.privilege,
                    has_Audit = self.has_Audit, has_UG = self.has_UG,
                    has_Changepass = self.has_Changepass,
                    is_Active=self.is_Active)

    def printme(self):
        print(self.username)
        print(self.fullname)
        print(self.password)
        print(self.email)
        print(self.privilege)
        print(self.has_Audit)
        print(self.has_UG)
        print(self.has_Changepass)
        print(self.is_Active)
        

def from_json(obj):
    if '__type__' in obj:
        if obj['__type__'] == 'User':
            return s_user(obj['username'], obj['fullname'],
                          obj['password'], obj['email'],
                          obj['privilege'],obj['has_Audit'],
                          obj['has_UG'],obj['has_Changepass'],
                          obj['is_Active'])

        if obj['__type__'] == 'DbInfo':
            return s_db(obj['user'],obj['host'],obj['database'],obj['password'])
    
    return obj

user = s_user("vg","V G","test thing", "vicgr563@student.liu.se", 1, True, False, False,True)
s = user.get_dict()
user.printme()
j=json.dumps(s)
s = json.loads(j)
user2= from_json(s)
print(j)
user2.printme()


"""
f = open('safe_stored.txt','r')
l = f.readline()
print(l)
p = json.loads(l)
u = from_json(p)
print(u)



u = s_db()
s = u.get_dict()    
j = json.dumps(s)
print(j)
"""
