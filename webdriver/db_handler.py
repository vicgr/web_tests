import mysql.connector
from db_objects import stored_user


class db_executor(object):

    def __init__(self, p,h,d, u, timed):

        if p is None:
            p = input("please enter database password: ")
        if h is None:
            h = input("please enter host: ")
        if d is None:
            d = input("please enter database: ")
        if u is None:
            u = input("please enter user: ")
        self.connection = mysql.connector.connect(user=u, host =h,database=d,password = p)
        self.cursor = self.connection.cursor()
        self.update = True
        self.last_query = None
        self.last_result = []
        self.timed = timed
        if timed:
            self.cursor.execute("select now()")
            self.start_time = self.cursor.fetchone()[0]


    def execute_log_query(self, query):
        if self.timed:
            query += (" and stamp >= '{time}'".format(time = self.start_time))

        return self.execute_query(query)

    def execute_query(self,query):

        if not self.update and query == self.last_query:
            return self.last_result

        self.last_query = query

        self.cursor.execute(query)
        r = []
        for i in self.cursor:
            r.append(i)
            #TODO: print(i)

        self.last_result = r

        return r

    def reset_time(self):
        self.cursor.execute("select NOW()")
        self.start_time = self.cursor.fetchone()[0]


class DB_handler(object):

    db_exec = None
    db_log = None

    def __init__(self, p = None, h = None, d=None,u=None, t = False):
        self.db_exec = db_executor(p,h,d,u,t)


    def action_performed(self):
        self.update = True

    #returns true if _any_ active user exists with the given username
    def active_user_with_username(self,name):
        res = self.db_exec.execute_query("select * from ss_userbase where username = '"+ name+"'")

        #if s is null or empty (-> False)
        if not res:
            return False

        for usr in res:
            if stored_user(usr).status.is_active():
                return True

        return False

    #given a username and is active-status, returns a set of users with the given username
    #If is_active = True, returns only active users, if false, only inactive members
    #Otherwise, it will return all users, regardless of status
    #By default, returns only active users
    def get_user_with_username(self,username,is_active = True):
        res = self.db_exec.execute_query("select * from ss_userbase where username ='"+username+"'")

        ret=[]
        if not res:
            return ret

        if type(is_active) == bool:
            for usr in res:
                susr = stored_user(usr)
                if susr.status.is_active() == is_active:
                    ret.append(susr)
        else:
            for usr in res:
                ret.append(stored_user(usr))

        return ret

    def expect_event_auth_failure(self): #any failed login?
        query ="select * from ss_log where event like '%AUTH FAILURE%'"
        return self.db_exec.execute_log_query(query)

    def expect_event_login(self,username):
        query ="select l.id, l.stamp, l.userid, u.username, l.event from ss_log as l join ss_userbase as u on l.userid = u.id and u.username = '"+username+"' and l.event like '%LOGIN%'"
        return  self.db_exec.execute_log_query(query)


    def expect_event_logout(self,user_):
        #if providing id
        if(type(user_)==int):
            query = "select * from ss_log where userid = "+user_+" and event like '%LOGOUT%'"
        #if providing username
        elif (type(user_)==str):
            query = "select * from ss_log as l join ss_userbase as u on l.userid=u.id where u.username = '"+user_+"' and l.event like '%LOGOUT%'"
        else:
            return None
        return self.db_exec.execute_log_query(query)

    def get_user_by_id(self,id):


        return stored_user(self.db_exec.execute_query("select * from ss_userbase where id = "+id)[0])



    def reset_time(self):
        self.db_exec.reset_time()
