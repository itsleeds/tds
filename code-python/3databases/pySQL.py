import psycopg2
con = psycopg2.connect(database='mydatabasename', user='root')
cur = con.cursor()

sql = "SELECT * FROM Detection;"
cur.execute(sql)
mylist = cur.fetchall()
print(mylist)


sql = "INSERT INTO Detection (camera, licencePlate, confidence, timestamp) VALUES (9, 'A06 NPR', 0.78, '2014-04-28:10:18:21');"
cur.execute(sql)
con.commit()