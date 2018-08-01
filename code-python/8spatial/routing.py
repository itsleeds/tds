import geopandas as gpd     
import psycopg2
import pyproj
from pylab import * 
import pyproj


#before using this you need to make a link-breaked version of the roads in yoru database
#this is done with the osm2pgrourting tool. 
#before use it requires a security setup: (for security reasons it wqill only run on a database which has a password setup):

#$ sudo -u postgres psql
# \password
# (enter 'postgres' for the password twice)
# Ctrl-D (to exit psql)

#Then run the link-breaking with:
#$ osm2pgrouting -f data/dcc.osm -d mydatabasename -W postgres


#this is NOT the same as importing osm via shapefiles yourself into a Road table
#as it splits links up into smaller units to make a routable network.

#you also need to do
# $ psql -d mydatabasename
# CREATE EXTENSION pgrouting
#in psql, to enable postgres routing extension.


wgs84  = pyproj.Proj(init='epsg:4326')  #WGS84
bng    = pyproj.Proj(init='epsg:27700') #british national grid

#set up plotting
clf()
hold(True)

#set up database connection
con = psycopg2.connect(database='mydatabasename', user='root')
cur = con.cursor()



#routing - gives a list of edge gids (not osm_ids, which may be split up into smaller gids by osm2pgr)
def doRouting():
    sql = "SELECT * FROM pgr_dijkstra('SELECT gid AS id,source,target,length AS cost FROM ways', 170,750, directed := false), ways WHERE ways.gid=pgr_dijkstra.edge;"
    df_route = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='the_geom')
    b_route=dict()
    routeEdgesOsmIDs = df_route['edge']
    for i in routeEdgesOsmIDs:
        b_route[i]=1
    return b_route


def makeMap(route):
    sql = "SELECT * FROM ways;"  #NB using osm2pgrouting link-breaked tables, not original OSM roads
    df_roads = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='the_geom')
    for i in range(0,df_roads.shape[0]):
        road = df_roads.iloc[i]
        lons = road['the_geom'].coords.xy[0] #coordinates in latlon
        lats = road['the_geom'].coords.xy[1]
        gid = int(road.gid)
        xs=[]
        ys=[]
        n_segments = len(lons)
        for j in range(0, n_segments):
            (x,y) = pyproj.transform(wgs84, bng, lons[j], lats[j]) #project to BNG -- uses nonISO lonlat convention 
            xs.append(x)
            ys.append(y)
        color='y'
        if gid in route:  #color the route in red, other roads yellow
            color='r'
        plot(xs, ys, color)

route = doRouting()
makeMap(route)
