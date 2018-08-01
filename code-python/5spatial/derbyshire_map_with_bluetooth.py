#this extends the code from ch3 and ch4 to use geopandas

import psycopg2
import pandas as pd
import geopandas as gpd
from pylab import *

con = psycopg2.connect(database='mydatabasename', user='root')
cur = con.cursor()

def importRoads():
    #(data has come from openstreetmap, then ogr2ogr )
    print("importing roads...")
    sql = "DROP TABLE IF EXISTS Road;"
    cur.execute(sql)
    sql = "CREATE TABLE Road (name text, geom geometry, highway text);"
    cur.execute(sql)
    fn_osm_shp = "/headless/data/dcc.osm.shp/lines.shp"
    df_roads = gpd.GeoDataFrame.from_file(fn_osm_shp)
    df_roads = df_roads.to_crs({'init': 'epsg:27700'})
    for index, row in df_roads.iterrows():
        sql="INSERT INTO Road VALUES ('%s', '%s', '%s');"%(row.name, row.geometry, row.highway )
#        print(sql)
        cur.execute(sql)
    con.commit()
    
def importBluetoothSites():
    print("importing sites...")
    sql = "DROP TABLE IF EXISTS BluetoothSite;"
    cur.execute(sql)
    sql = "CREATE TABLE BluetoothSite ( id serial PRIMARY KEY, siteID text, geom geometry);"
    cur.execute(sql)
    con.commit()    
    fn_sites = "/headless/data/dcc/web_bluetooth_sites.csv"
    df_sites = pd.read_csv(fn_sites, header=1)   #dataframe. header is which row to use for the field names.
    for i in range(0, df_sites.shape[0]):      
        #munging to extract the coordinates - the arrive in National Grid
        locationstr = str(df_sites.iloc[i]['Grid'])
        bng_east  = locationstr[0:6]
        bng_north = locationstr[6:12]
        sql = "INSERT INTO BluetoothSite (siteID, geom) VALUES ('%s', 'POINT(%s %s)');"%(df_sites.iloc[i]['Site ID'], bng_east, bng_north )
        cur.execute(sql)
    con.commit()
        
def importDetections():
    print("importing detections...")
    sql = "DROP TABLE IF EXISTS Detection;"
    cur.execute(sql)    
    sql = "CREATE TABLE Detection ( id serial, siteID text, mac text, timestamp timestamp );"
    cur.execute(sql)    
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
    
def plotRoads():   
    print("plotting roads...")
    sql = "SELECT * FROM Road;"
    df_roads = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='geom') #
    for index, row in df_roads.iterrows():
        (xs,ys) = row['geom'].coords.xy
        color='y'
        #road colour by type
        if row['highway']=="motorway":
            color = 'b'
        if row['highway']=="trunk":
            color = 'g'
        #if not color=='y':  #only plot major roads
        plot(xs, ys, color)

def plotBluetoothSites():    
    sql = "SELECT siteID, geom FROM BluetoothSite;"
    df_sites = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='geom') #
    for index, row in df_sites.iterrows():
        (xs,ys) = row['geom'].coords.xy
        plot(xs, ys, 'bo')


    
importRoads()
importBluetoothSites()
#importDetections()
plotRoads()
plotBluetoothSites()
