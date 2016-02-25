#import simplejson as json
import json
"""
class s_privileges:
    def __init__(self,p,h_a,h_u,h_c,a):
        #1 = read, 2= write, 4=admin
        self.privilege = p
        self.has_Audit = h_a
        self.has_UG = h_u
        self.has_Changepass = h_c
        self.is_Active = a

    def get_dict(self):
        return dict(privilege = self.privilege, has_Audit = self.has_Audit,
                    has_UG = self.has_UG, has_Changepass = self.has_Changepass,
                    is_Active=self.is_Active)

    def printme(self):
        print(self.privilege)
        print(self.has_Audit)
        print(self.has_UG)
        print(self.has_Changepass)
        print(self.is_Active)
"""
        

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
        #self.privileges = s_privileges(p,h_a,h_u,h_c,a)
        
    def get_dict(self):
        """return dict(__type__= "User", username = self.username,
                    fullname = self.fullname, password =self.password,
                    email = self.email, privileges = self.privileges.get_dict())
                    """
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
        #self.privileges.printme()
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
    
    return obj

user = s_user("vg","V G","test thing", "vicgr563@student.liu.se", 1, True, False, False,True)
s = user.get_dict()
user.printme()
j=json.dumps(s)
s = json.loads(j)
user2= from_json(s)
print()
user2.printme()
