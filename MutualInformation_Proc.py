#!/usr/bin/env python
# coding: utf-8


#load necessary libraries 
import numpy as np
import pandas as pd
from sklearn.feature_selection import mutual_info_classif
import matplotlib.pyplot as plt



#load the data
df = pd.read_csv('disorder_concept.csv', header= 0) 

#split the data
X = pd.crosstab(df.diseaseName,df.symptomName)
y= X.index.tolist()

#apply mutual_information classifier
mu_info = mutual_info_classif(X.to_numpy(), y, discrete_features=True)



#show results
print(mu_info)



#plot results
plt.plot(mu_info)
plt.xlabel('Features')
plt.ylabel('Mutual Info Scores')
plt.title('Histogram of mutual information Scores for each features')







