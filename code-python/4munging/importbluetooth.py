#this extends the code from ch3 to use pandas and datetimes

import psycopg2
import pandas as pd


con = psycopg2.connect(database='mydatabasename', user='root')
cur = con.cursor()

sql = "DROP TABLE IF EXISTS BluetoothSite;"
cur.execute(sql)
sql = "DROP TABLE IF EXISTS Detection;"
cur.execute(sql)


#NB we store timestamp as text here. Later we will use datetime tools to represeent it properly.
sql = "CREATE TABLE Detection ( id serial, siteID text, mac text, timestamp timestamp );"
cur.execute(sql)
#NB we store location as text here. Later we will use GIS tools to represent it properly.
sql = "CREATE TABLE BluetoothSite ( id serial PRIMARY KEY, siteID text, location text);"
cur.execute(sql)

con.commit()

#see how pandas makes life easier than in chapter 3:

fn_sites = "/headless/data/dcc/web_bluetooth_sites.csv"
df_sites = pd.read_csv(fn_sites, header=1)   #dataframe. header is which row to use for the field names.
for i in range(0, df_sites.shape[0]):
    sql = "INSERT INTO BluetoothSite (siteID, location) VALUES ('%s', '%s');"%(df_sites.iloc[i]['Site ID'], df_sites.iloc[i]['Grid'])
    cur.execute(sql)
con.commit()
    

dir_detections = "/headless/data/dcc/bluetooth/"
import os
import re
import datetime
for fn in sorted(os.listdir(dir_detections)):  #import ALL sensor files
    print("processing file: "+fn)
    
    m = re.match("vdFeb14_(.+).csv", fn)  #use regex to extract the sensor ID
    if m is None:  #if there was no regex match
        continue   #ignore any non detection files
        
    siteID = m.groups()[0]
    fn_detections = dir_detections+fn
    df_detections = pd.read_csv(fn_detections, header=0)   #dataframe. header is which row to use for the field names.
    
    #here we use Python's DateTime library to store times properly
    for i in range(0, df_detections.shape[0]):
        datetime_text = df_detections.iloc[i]['Unnamed: 0']
        dt = datetime.datetime.strptime(datetime_text ,  "%d/%m/%Y %H:%M:%S" ) #proper Python datetime   
        sql = "INSERT INTO Detection (siteID, timestamp, mac) VALUES ('%s', '%s', '%s');"%(siteID, dt, df_detections.iloc[i]['Number Plate'])
        cur.execute(sql)
con.commit()


