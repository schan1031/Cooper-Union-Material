import csv
import numpy as np
import timeit
from sklearn import linear_model
from sklearn import neighbors
import time

# train_rev2.csv has 47686351 data points
# train_small.csv has 199229 data points
# train_smallest.csv has 99 data points

# test_rev2 has 4769401 data points
# test_small has 999 data points

# read in test data
f_len = 4577464

classified = 0.14*np.ones((f_len,1))
#print(classified)
print(classified.shape)
#print(ID)
np.savetxt("./min_log_loss.csv",classified,fmt='%s',delimiter=',')
