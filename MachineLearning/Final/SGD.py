import csv
import numpy as np
import timeit
from sklearn import linear_model
from sklearn import neighbors
import time

# file io
fname = "train"
if fname == "train_small.csv":
    f_len = 500000
else:
    if fname ==  "train_smallest.csv":
        f_len = 99
    else:
        if fname == "train":
            f_len = 40428967
        else:
            f_len = 0
            
file_in = open(fname)
csv_reader = csv.reader(file_in)
header = next(csv_reader)
targets = np.zeros((f_len,1))
features = np.zeros((f_len,13))
index = 0

# iterate over each row and read in data
start = time.time()
for row in csv_reader:
    if index == f_len:
        print("index has exceeded matrix dimensions \nwriting data to file")
        break
    targets[index] = np.array(row[1]).astype(np.float)
    features[index,:]=np.array(row[2:5]+row[14:24]).astype(np.float)
    index = index + 1
end = time.time()
file_in.close()
out = np.hstack((targets,features))
print("Feature matrix dimensions: ",out.shape)
#np.savetxt("./features_rev2.csv",out,fmt='%s',delimiter=',')
print("It took ",end-start," seconds to read in training data")



# test_rev2 has 4769401 data points
# test_small has 999 data points

# read in test data
fname = "test"
if fname == "test":
    f_len = 4577464
else:
    if fname == "test_small.csv":
        f_len = 199999
    else:
        f_len = 0

file_in = open(fname)
csv_reader = csv.reader(file_in)
header = next(csv_reader)
ID = np.array((f_len,),dtype='object')
test_features = np.zeros((f_len,13))
index = 0

# iterate over each row and read in data
start = time.time()
for row in csv_reader:
    if index == f_len:
        print("index has exceeded matrix dimensions \nwriting data to file")
        break
    #ID[index] = row[0]
  #  t = np.array(row[1:4]+row[15:17]+row[18:26])
 #   print(t.shape,row[1:4])
    test_features[index,:]=np.array(row[1:4]+row[13:23]).astype(np.float)
    index = index + 1
end = time.time()
file_in.close()
print("Test feature matrix dimensions: ",test_features.shape)
#np.savetxt("./test_features_smallest.csv",out,fmt='%s',delimiter=',')
print("It took ",end-start," seconds to read in test data")

# create and train model
# logistic regression
start = time.time()
n_neighbors = 10
#classifier = neighbors.KNeighborsRegressor(n_neighbors,weights='uniform')
classifier = linear_model.SGDClassifier(loss='log')
classifier = classifier.fit(features,np.ravel(targets))
end = time.time()
print("It took ",end-start," seconds to train the model")

# use model to preduct outputs
start = time.time()
classified = classifier.predict_proba(test_features)
end = time.time()
print("It took ",end-start," seconds to classify the data")
#print(classified)
print(classified.shape)
#print(ID)

for x in classified:
    if x[1] == 0:
        x[0] = .14
    elif x[1] == 1:
        x[0] = .86
'''
print("correcting zeros")
for x in classified:
    if x == 0:
        x[...] = 0.1
'''
np.savetxt("./test_classified.csv",classified[:,0],fmt='%s',delimiter=',')
