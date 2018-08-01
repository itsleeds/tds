import psycopg2
con = psycopg2.connect(database='mydatabasename', user='root')
cur = con.cursor()

sql = "DROP TABLE IF EXISTS BluetoothSite;"
cur.execute(sql)

sql = "DROP TABLE IF EXISTS Detection;"
cur.execute(sql)


#NB we store timestamp as text here. Later we will use datetime tools to represeent it properly.
sql = "CREATE TABLE Detection ( id serial, siteID text, mac text, timestamp text );"
cur.execute(sql)

#NB we store location as text here. Later we will use GIS tools to represent it properly.
sql = "CREATE TABLE BluetoothSite ( id serial PRIMARY KEY, siteID text, location text);"
cur.execute(sql)


con.commit()

#fn for filename
fn_sites = "/headless/data/dcc/web_bluetooth_sites.csv"

count=0
for line in open(fn_sites):
    line=line.strip()
    count+=1
    if count<3:
        continue   #skip first lines
    print(line)
    (longID, siteID, locationDescription, location, direction)=line.split(",")
    #print(siteID, location)
    
    sql = "INSERT INTO BluetoothSite (siteID, location) VALUES ('%s', '%s');"%(siteID, location)
 #   print(sql)
    cur.execute(sql)

con.commit()
    

siteID = "MAC000010100"
fn_detections = "/headless/data/dcc/bluetooth/vdFeb14_MAC000010100.csv"
count=0
for line in open(fn_detections):
    line=line.strip()
    count+=1
    if count<2:
        continue   #skip first lines
    #print(line)
    (timestr, sensortype, direction, dummyA, dummyB, mac)=line.split(",")
    print(siteID, timestr, mac)
    
    sql = "INSERT INTO Detection (siteID, timestamp, mac) VALUES ('%s', '%s', '%s');"%(siteID, timestr, mac)
    print(sql)
    cur.execute(sql)

con.commit()
