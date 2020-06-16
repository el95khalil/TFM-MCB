#!/usr/bin/env python
# coding: utf-8


#import necessary libraries
import numpy as np
import pandas as pd
from sklearn.feature_selection import VarianceThreshold
import matplotlib.pyplot as plt



#load data
df = pd.read_csv('disorder_concept.csv', header= 0)
crosstab = pd.crosstab(df.diseaseName,df.symptomName)



#apply variancethreshold
selector = VarianceThreshold()
results  = selector.fit(crosstab)
thr_var  = results.variances_

#show results
print(thr_var)


#plot the distribution of all the variances
plt.plot(thr_var)
plt.xlabel('Features')
plt.ylabel('Variance Threshold')
plt.title('Histogram of features versus Variance Threshols')






