#!/usr/bin/env python
# coding: utf-8

# In[11]:


#load necessary libraries 
import numpy as np
import pandas as pd
from sklearn.feature_selection import mutual_info_classif
import matplotlib.pyplot as plt


# In[2]:


#load the data
df = pd.read_csv('disorder_concept.csv', header= 0) 

#split the data
X = pd.crosstab(df.diseaseName,df.symptomName)
y= X.index.tolist()

#apply mutual_information classifier
mu_info = mutual_info_classif(X.to_numpy(), y, discrete_features=True)


# In[4]:


#show results
print(mu_info)


# In[10]:


#plot results
plt.plot(mu_info)
plt.xlabel('Features')
plt.ylabel('Mutual Info Scores')
plt.title('Histogram of mutual information Scores for each features')


# In[ ]:




