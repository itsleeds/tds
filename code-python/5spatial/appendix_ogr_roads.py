import ogr     #use the low level OGR library
from pylab import *

#in this example we plot a map using OGR
ds = ogr.Open("/headless/data/dcc.osm.shp/lines.shp") #datasource
layer = ds.GetLayer(0)
nameList = []
for feature in layer:
    col="y"
    #change the colour if its an interesting road type
    highwayType = feature.GetField("highway")
    if highwayType != None:
        col="k"
    if highwayType=="trunk":
        col="g"
    name = feature.GetField("name")
    nameList.append(name)
    #get the features set of point locations (a wiggly line)
    geomRef=feature.GetGeometryRef()
    x=[geomRef.GetX(i) for i in range(geomRef.GetPointCount())]
    y=[geomRef.GetY(i) for i in range(geomRef.GetPointCount())]
    plot(x,y, col)
    
    