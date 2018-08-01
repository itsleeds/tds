import ogr

import subprocess

def createShapeFile():
    driver = ogr.GetDriverByName('ESRI Shapefile')
    datasource = driver.CreateDataSource('towncenter.shp')
    layer = datasource.CreateLayer('layerName',geom_type=ogr.wkbPolygon)
    lonmin = -1.4366
    latmin = 53.2242
    lonmax = -1.4102
    latmax = 53.2396
    myRing = ogr.Geometry(type=ogr.wkbLinearRing)
    myRing.AddPoint(lonmin, latmin)#LowerLeft
    myRing.AddPoint(lonmin, latmax)#UpperLeft
    myRing.AddPoint(lonmax, latmax)#UpperRight
    myRing.AddPoint(lonmax, latmin)#Lower Right
    myRing.AddPoint(lonmin,latmin)#close ring
    myPoly = ogr.Geometry(type=ogr.wkbPolygon)
    myPoly.AddGeometry(myRing)
    feature = ogr.Feature( layer.GetLayerDefn() )
    feature.SetGeometry(myPoly)
    layer.CreateFeature(feature)
    feature.Destroy()   #flush memory
    datasource.Destroy()

createShapeFile()


#convert shapefile to JSON
subprocess.call("ogr2ogr -f GeoJSON -s_srs wgs84 -t_srs wgs84 towncenter.json.tmp towncenter.shp", shell=True)

#add head and tail text to JSON to make it work in Leaflet
subprocess.call(' echo "var towncenter =" > head && echo ";" > tail &&  cat head towncenter.json.tmp tail > towncenter.json; rm head && rm tail', shell=True)

subprocess.call("firefox webpage.html", shell=True)
