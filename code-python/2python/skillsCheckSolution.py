import sys,re,os
import operator

fn_data =  "/headless/data/accidents/Accidents_2015.csv"
d=dict()
b=True


d["1"] = 0
d["2"] = 0
d["3"] = 0
d["4"] = 0
d["5"] = 0
d["6"] = 0
d["7"] = 0

d_nv=dict()
for i in range(0, 100):
    ns=str(i)
    d_nv[ns] = 0

for line in open(fn_data):
    if b:
        b=False
        continue
    
    line=line.strip()
    fields=line.split(",")

    (Accident_Index, Location_Easting_OSGR, Location_Northing_OSGR, myLongitude, myLatitude, Police_Force, Accident_Severity, Number_of_Vehicles, Number_of_Casualties, TheDate, Day_of_Week, TheTime, Local_Authority_District,Local_Authority_Highway,Road1_Class,Road1_Number,Road_Type,Speed_limit,Junction_Detail,Junction_Control,Road2_Class,Road2_Number, Pedestrian_Crossing_Human_Control,Pedestrian_Crossing_Physical_Facilities, Light_Conditions, Weather_Conditions, Road_Surface_Conditions, Special_Conditions_at_Site, Carriageway_Hazards, Urban_or_Rural_Area, Did_Police_Officer_Attend_Scene_of_Accident, LSOA_of_Accident_Location) = fields


    d[Day_of_Week] += 1


    d_nv[Number_of_Vehicles] += 1


d_sorted = sorted(d.items(), key=operator.itemgetter(1))

d_nv_sorted = sorted(d_nv.items(), key=operator.itemgetter(1))

print(d_sorted)
print(d_nv_sorted)
