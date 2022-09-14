#!/usr/bin/python
import datetime
import re
import getpass
import urllib
import urllib2
import cookielib
import socket

timeout = 15
socket.setdefaulttimeout(timeout)


#username = raw_input('Username: a510116 ')
#password = getpass.getpass('Pass Window: ')
#
##This should be the base url you wanted to access.
#baseurl = 'http://http://skysv.mu.renesas.com/'
#
##Create a password manager
#manager = urllib2.HTTPPasswordMgrWithDefaultRealm()
#manager.add_password(None, baseurl, username, password)
#
##Create an authentication handler using the password manager
#auth = urllib2.HTTPBasicAuthHandler(manager)
#
##Create an opener that will replace the default urlopen method on further calls
#opener = urllib2.build_opener(auth)
#urllib2.install_opener(opener)
#
##Here you should access the full url you wanted to open

# HTTP header
http_header = {
      "User-Agent" : "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/533.2 (KHTML, like Gecko) Chrome/5.0.342.3 Safari/533.2"
#      "Accept" : "text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,text/png,*/*;q=0.5",
#      "Accept-Language" : "en-us,en;q=0.5",
#      "Accept-Charset" : "ISO-8859-1",
#      "Content-type": "application/x-www-form-urlencoded",
}

# Input account information
username = raw_input('Username: hau.huynh.ry@rvc.renesas.com ')
password = getpass.getpass('Password: ')
employeeid = raw_input('Your ID number:  ')

# Enable cookie in memory
cookieJarInMemory = cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookieJarInMemory));
urllib2.install_opener(opener)
#print "after init, cookieJarInMemory=",cookieJarInMemory

url_login = "http://172.29.139.61/SignIn.aspx"
page = urllib2.urlopen(url_login).read()
viewstate           = re.search('<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="(.*)" />', page).group(1)
viewstategenerator  = re.search('<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="(.*)" />', page).group(1)
eventvalidation     = re.search('<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="(.*)" />', page).group(1)

post_val = {
#    '__EVENTTARGET': '',
#    '__EVENTARGUMENT': '',
    '__VIEWSTATE': viewstate,
    '__VIEWSTATEGENERATOR': viewstategenerator,
    '__EVENTVALIDATION': eventvalidation,
    'tbUsername': username,
    'tbPassword': password,
    'btLogin': 'Login',
    'checkRemember': 'on'
}
params = urllib.urlencode(post_val)

# Prepare and submit request
req = urllib2.Request(url_login, params, http_header)
res = urllib2.urlopen(req)
#print res.read()

### DONE LOGIN ###

url_Monthly_List = "http://172.29.139.61/Report/ByMonthly_List.aspx"
page = urllib2.urlopen(url_Monthly_List).read()
viewstate           = re.search('<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="(.*)" />', page).group(1)
viewstategenerator  = re.search('<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="(.*)" />', page).group(1)

if datetime.datetime.now().day > 25 :
  date = datetime.datetime.now() + datetime.timedelta(days=10) # Must jump to next month
else :
  date = datetime.datetime.now()

date = datetime.datetime.now()
year = date.year
month = date.month
  

post_val = {
    'ScriptManager1'        : 'ScriptManager1|btnSearch',
#    '__EVENTTARGET'         : '',
#    '__EVENTARGUMENT'       : '',
#    '__LASTFOCUS'           : '',
    '__VIEWSTATE'           : viewstate,
    '__VIEWSTATEGENERATOR'  : viewstategenerator,
#    'ddlDepartmentList'     : "",
    'ddlYearList'           : year,
    'ddlMonthLis'           : month,
#    'ddlEmployeeList'       : '',
#    'cboGroup'              : '',
    'txtEmployee' : employeeid,
    'btnSearch' : 'Search'
}
params = urllib.urlencode(post_val)

print 'Request month: ',month,'/',year
print 'ID: ',employeeid

# Prepare and submit request
req = urllib2.Request(url_Monthly_List, params, http_header)
res = urllib2.urlopen(req)
page = res.read()

file = open('MonthlyAttendanceReport.html','w')
file.write(page)
file.close()

print "Page is exported to MonthlyAttendanceReport.html\n"
