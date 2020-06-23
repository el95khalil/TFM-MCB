#!/usr/bin/env python
# coding: utf-8

# In[11]:


#load necessary libraries 
import numpy as np
import pandas as pd
from sklearn.feature_selection import mutual_info_classif
import matplotlib.pyplot as plt
import seaborn as sns


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
ax= sns.distplot(mu_info, hist=True, kde=False, bins='auto', color='blue', hist_kws={'edgecolor':'black'})
ax.set(xlabel='Mutual Information',ylabel='Count')
plt.title('Histogram of Mutual Information Distribution')
#plt.savefig('MI.png')




