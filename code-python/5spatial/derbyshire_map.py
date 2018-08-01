import psycopg2
import pandas as pd
import geopandas as gpd
import sys
from pylab import *

con = psycopg2.connect(database='mydatabasename', user='root') 	
cur = con.cursor()

sql = "DROP TABLE IF EXISTS Road;"
cur.execute(sql)
sql = "CREATE TABLE Road (name text, geom geometry, highway text);"
cur.execute(sql)

#importing roads shapefile to database
#(this has come from openstreetmap, then ogr2ogr )
fn_osm_shp = "/headless/data/dcc.osm.shp/lines.shp"
df_roads = gpd.GeoDataFrame.from_file(fn_osm_shp)
df_roads = df_roads.to_crs({'init': 'epsg:27700'})
for index, row in df_roads.iterrows():
    sql="INSERT INTO Road VALUES ('%s', '%s', '%s');"%(row.name, row.geometry, row.highway )
    print(sql)
    cur.execute(sql)
con.commit()
#road plotting
sql = "SELECT * FROM Road;"
df_roads = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='geom') #
print(df_roads)
for index, row in df_roads.iterrows():
    (xs,ys) = row['geom'].coords.xy
    color='y'
    #road colour by type
    if row['highway']=="motorway":
        color = 'b'
    if row['highway']=="trunk":
        color = 'g'
    plot(xs, ys, color)