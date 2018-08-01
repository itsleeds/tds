import pandas as pd
import psycopg2
con = psycopg2.connect(database='mydatabasename', user='root')
sql = 'SELECT * FROM Detection;'
dataFrame = pd.read_sql_query(sql,con)
print(dataFrame)


my_str="michael knight"
my_int=32
my_float=1.92
s = "name: %s, age: %d years, height: %f"%(my_str, my_int, my_float)
print(s)

import datetime
#make datetime from string
dt = datetime.datetime.strptime('2017-02-11_13:00:35.067' , "%Y-%m-%d_%H:%M:%S.%f" )
#convert datetime object to human readable string
dt.strftime("%Y-%m-%d_%H:%M:%S")
#create a TimeDelta object for difference between two datetimes
delta = dt-datetime.datetime.now()
print(delta)

#or from scratch:
delta = datetime.timedelta(milliseconds=500)
#print delta as a human readable string
str(delta)
#convert delta to float number of seconds
delta.total_seconds()

import re
print( re.match("(\d+) , (\d+)", "123 , 456").groups() )

from pyparsing import Word, alphas
greet = Word( alphas ) + "," + Word( alphas ) + "!"
greeting = greet.parseString( "Hello, World!" )
print(greeting)



from pyparsing import *
survey = 'GPS,PN1,LA52.125133215643,LN21.031048525561,EL116.898812'
number = Word(nums+'.').setParseAction(lambda t: float(t[0]))
separator = Suppress(',')
latitude = Suppress('LA') + number
longitude = Suppress('LN') + number
elevation = Suppress('EL') + number
line = (Suppress('GPS,PN1,')+latitude+separator+longitude+separator+elevation)
print(line.parseString(survey))