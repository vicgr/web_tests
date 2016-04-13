#!python3
class testentry:
    testnr =0
    testname=""
    def __init__(self,testnr_, testname_):
        self.testnr=testnr_
        self.testname = testname_

class TestSuccess(testentry):
    successentry =""
    type = "success"

    def __init__(self,testnr_,testname_,successentry_):
        self.successentry=successentry_
        testentry.__init__(self,testnr_,testname_)

    def getentry(self):
        return [self.testnr,self.testname,self.type,self.successentry]

class TestError(testentry):
    result =""
    expectedresult=""
    type ="failure"

    def __init__(self, testnr_,testname_,result_,expected_):
        self.result = result_
        self.expectedresult = expected_
        testentry.__init__(self,testnr_,testname_)

    def getenry(self):
        return [self.testnr,self.testname,self.type,self.expectedresult,self.result]


#Super-simple testreport generator. #Uses the testentry subclasses to generate a report
#TODO: make better
class testreporter:
    testlist = []

    def log_webdriver(self,driver):
        self.testlist.append(["webdriver:"+driver])

    def add_success(self,testnr_,testname_,successentry_):
        self.testlist.append(TestSuccess(testnr_,testname_,successentry_).getentry())

    def add_failure(self,testnr_,testname_,errorresult_,expectedresult_):
        self.testlist.append(TestError(testnr_,testname_,errorresult_,expectedresult_).getenry())

    def printreport(self):
        print("TESTREPORT")
        for entry in self.testlist:
            for content in entry:
                print("| "+str(content), end = ' ')
            print ('\n')

    def clear(self):
        testlist = []