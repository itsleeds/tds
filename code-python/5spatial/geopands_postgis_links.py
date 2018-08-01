#example read and write with geopandas and postGIS

import psycopg2
import sys
import psycopg2
import pandas as pd
import geopandas as gpd


import pyproj
lat = 53.232350; lon = -1.422151
projSrc = pyproj.Proj(proj="latlon", ellps="WGS84", datum="WGS84")
projDst = pyproj.Proj(proj="utm", utm_zone="30U", ellps="clrk66")
(east_m, north_m)=pyproj.transform(projSrc, projDst,lon,lat) #non-ISO!
print(east_m, north_m)



con = psycopg2.connect(database='mydatabasename', user='root') 	
cur = con.cursor()

sql = "DROP TABLE IF EXISTS BluetoothSite;"
cur.execute(sql)
sql = "DROP TABLE IF EXISTS Detection;"
cur.execute(sql)
sql = "DROP TABLE IF EXISTS Route;"
cur.execute(sql)
sql = "DROP TABLE IF EXISTS City;"
cur.execute(sql)


sql = "CREATE TABLE BluetoothSite (siteID text, geom geometry);"
cur.execute(sql)

sql = "CREATE TABLE Route (name text, geom geometry);"
cur.execute(sql)

sql = "CREATE TABLE City (name text, geom geometry);"
cur.execute(sql)


sql = "INSERT INTO BluetoothSite VALUES ('ID1003', 'POINT(0 -4)'), ('ID9984', 'POINT(1 1)');"
cur.execute(sql)
sql = "INSERT INTO Route VALUES ('route1', 'LINESTRING(0 0,-1 1)'), ('route2', 'LINESTRING(0 0, 1 1)');"
cur.execute(sql)
sql = "INSERT INTO City VALUES ('Chesterfield', 'POLYGON((0 0, 0 5, 5 5, 5 0, 0 0))');"
cur.execute(sql)

con.commit()

#using geopandas to retreive GIS data
sql = "SELECT siteID, geom FROM BluetoothSite;"
gdf=gpd.GeoDataFrame.from_postgis(sql,con,geom_col='geom' )
print(gdf)

#Note that if we convert GIS to non-GIS data *inside* the databsae, 
#then we don't need geopandas, and just use pandas instead.
sql = "SELECT ST_X(geom), ST_Y(geom) FROM BluetoothSite;"
df = pd.read_sql_query(sql,con)
print(df)


sql = "SELECT * FROM BluetoothSite;"
df = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='geom')
print(df['geom'][0].coords.xy) #get coordinates as numbers
for index, row in df.iterrows(): #loop over rows
    print(row)

#tell GeoPandas what coordinate system the numbers are in
df.crs = {'init': 'epsg:4326', 'no_defs' : True }

#use GeoPandas to convert them to a different one.
df = df.to_crs(epsg=27700)

