#mapnik is not installed in itslive as its authors are updating it at the time of writing.
#to install the latest development version yourself for future versions, follow the instructions from,
# https://github.com/mapnik/mapnik/wiki/UbuntuInstallation

import ogr
import mapnik

def createShapeFile():
    driver = ogr.GetDriverByName('ESRI Shapefile')
    datasource = driver.CreateDataSource('test.shp')
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

def makeStyleMyShape():
    s = mapnik.Style()
    rule_poly = mapnik.Rule() # rule object to hold symbolizers
    polygon_symbolizer = mapnik.PolygonSymbolizer()
    polygon_symbolizer.fill = mapnik.Color('#ffff00')
    rule_poly.symbols.append(polygon_symbolizer) # add the symbolizer to the rule object
    line_symbolizer = mapnik.LineSymbolizer()
    line_symbolizer.stroke = mapnik.Color('rgb(50%,50%,50%)')
    line_symbolizer.stroke_width = 0.1
    rule_poly.symbols.append(line_symbolizer) # add the symbolizer to the rule object
    s.rules.append(rule_poly) # now add the rule to the style and we're done
    return s

def renderMap():
    m = mapnik.Map(600,600)
    mapnik.load_map(m, 'mini_osm.xml')
    s_my = makeStyleMyShape()
    m.append_style('mystyle',s_my)

    layer = mapnik.Layer("osm")	
    ds = mapnik.Osm(file="/home/charles/data/osm/dcc.osm")
    layer.datasource = ds		
    layer.styles.append('cf')
    m.layers.append(layer)

    layer2 = mapnik.Layer("myshape")
    ds = mapnik.Shapefile(file="test.shp")
    layer2.datasource = ds              
    layer2.styles.append('mystyle')
    m.layers.append(layer2)

    m.zoom_all()
    mapnik.render_to_file(m, 'dcc.png', 'png')

createShapeFile()
renderMap()
