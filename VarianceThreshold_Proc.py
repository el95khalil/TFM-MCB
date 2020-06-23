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
ax= sns.distplot(thr_var, hist=True, kde=False, bins='auto', color='blue', hist_kws={'edgecolor':'black'})
ax.set(xlabel='Variance',ylabel='Count')
plt.title('Histogram of Variance Distribution')
#plt.savefig('VT.png')





