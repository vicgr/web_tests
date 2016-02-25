import mysql.connector
from db_objects import stored_user

class DB_handler():

    def __init__(self):
        a = input("please enter database password: ")
        self.connection = mysql.connector.connect(user='victor', host ='t1.storedsafe.com',database='storedsafe',password = a)
        self.cursor = self.connection.cursor()

        self.update = True
        #self.connection = None
        #self.cursor = None
        self.last_query = None
        self.last_result = []

    def execute_query(self,query):

        if not self.update and query == self.last_query:
            return self.last_result

        self.last_query = query
        print("executing query:",query)

        self.cursor.execute(query)
        r = []
        for i in self.cursor:
            r.append(i)

        self.last_result = r
        return r

    def action_performed(self):
        self.update = True

    def active_user_with_username(self,name):
        print("q;", name)
        res = self.execute_query("select * from ss_userbase where username = '"+ name+"'")

        #if s is null or empty (-> False)
        if not res:
            return False

        for usr in res:
            if stored_user(usr).status.is_active():
                return True
