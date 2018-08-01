print('hello world')

print(2+2)

x=4
print(x+1)

y=2.5
y=2.

s='hello'+' '+'world'
print(s)

type(x)

x=1
print('There are '+str(x)+' cars')

print('Camera %i saw car %s with confidence %f'%(5,'AB05 FDE',0.6))

l=[1,2,'car', 5.0, [5,6] ]

print(l[4])
l[4]=9

l[0:4]

s = 'hello world'
s[1]
s[0:4]

l.append('newstring')
l.remove(2)

d=dict()
d['Andrew Froggatt']='XY32 AJF'
d['Andrew Bower']='XZ85 AJB'

for i in range(0,10,4):
    print('hello world'+str(i))
    
    
x=1
while x<10:
    x=x+1
    print('while '+str(x))
    if x==1:
        print('x is one!')
    else:
        print('x is not one!')
        

f=open('myfilename.txt', 'w')
f.write('hello')
f.close()

for line in open('myfilename.txt'):
    print(line)

def myfunction(a,b):
    return a+b

x=1
y=2
z=myfunction(x,y)
print(z)


import math
print( math.sin(math.pi * 2) )
print( math.exp(2) )


import numpy as np
Z = np.zeros((2,3))
I = np.eye(3)
A = np.matrix([[1,2],[3,4]])
A[0,1] = 6
print(A[0:2, 1])
print(A.shape)
print(A.dot(A)) #matrix multiplication
print(A+1)
#add scalar



from pylab import *
xs = [1,2,3]
ys = [10, 12, 11]
plot(xs, ys, 'bx') #blue x's
hold(True) #add future plots to the same figure
plot(xs, ys, 'r-', linewidth=5) #thick red lines
text(xs[1],ys[1],'some text')
title('my graph')
ylabel('vehicle count')
gca().invert_yaxis() #flip the y axis
xticks( range(0,16), ['car', 'van', 'truck'], rotation='vertical')



import pandas as pd
import numpy as np
df=pd.read_csv('/headless/data/accidents/Accidents_2015.csv')
df.columns
df.shape
df['Number_of_Vehicles']
df[0:20]
df.iloc[7]
df.iloc[::10, :]
df.as_matrix()

I = np.eye(3)
#create a matrix
df = pd.DataFrame(I, columns=['col1','col2','col3'])#convert np to pd
df['col1']+df['col2']
#add columns
df + df
#add all columns
del df['col1']
#delete a column
df.append(df)
#append frames
df.sort_values('col2', ascending=False)
#sort by a column
df['newField']=0.
#add extra column
df[df['col2']==0]
#select rows WHERE true
df.merge(df)
#JOIN columns from frames
df = df.merge(df, how='outer').fillna(method='ffill') #align by time
df.to_csv('filename')
#save frame as CSV