#!/usr/bin/env python
# coding: utf-8


# Import the necessary libraries
import numpy as np
import pandas as pd
import array as arr
from sklearn.feature_selection import mutual_info_classif

from sklearn.cluster import DBSCAN
from sklearn.metrics import pairwise_distances
from sklearn.metrics import silhouette_score

#load the data
df = pd.read_csv('disorder_concept.csv', header= 0) 

X = pd.crosstab(df.diseaseName,df.symptomName)
y= X.index.tolist()
mu_info = mutual_info_classif(X.to_numpy(), y, discrete_features=True)


# Save the distance metric as a numpy array
f_m_np = X.to_numpy()



# Eps (epsilon) is one of the parameters that must be specified for DBSCAN
# We define the following values to explore the results:
epsilons = (0.3,
            0.4,
            0.5,
            0.6,
            0.7,
            0.8,
            0.9
           )

# MinPts (ms) is the other parameter that must be specified for DBSCAN
# We define the following values to explore the results:
ms_values = (2,
             3,
             5,
             10,
             30
            )

# Similarity indices to use
sim_metrics = (
           'jaccard',
           'dice'
          )

# Lists to store the combination of parameters and results
indss = list() # Indices of similarities 
mss = list() # Values of MinPts
epss = list() # Values of Eps
clusters = list() # Number clusters
noise = list() # Number of outliers
silhouettes = list() # Results of the silhouette coefficient


# Loop  through the 2 similarity indices 
for ind in sim_metrics:
    
    # Calculate the corresponding distances with the similarity index
    distances = pairwise_distances(f_m_np, w= mu_info,
                                   metric = ind)
    
    # Loop through the 5 values of MinPts
    for ms in ms_values:    

            # Loop through the 8 values of Eps
            for epsilon in epsilons:   

                # Generate the model from the parameters
                labels = DBSCAN(eps = epsilon, 
                                       min_samples = ms, 
                                       metric = "precomputed"
                                      ).fit_predict(distances)

                # All elements are assigned as "-1"
                if not 0 in labels:
                    n_clusters = 0
                    n_noise = list(labels).count(-1)
                    silh_coef = -1

                else:
                    n_clusters = len(set(labels)) - (1 if -1 in labels else 0)
                    n_noise = list(labels).count(-1)
                    silh_coef = silhouette_score(distances,
                                                 labels,
                                                 metric = 'precomputed')
                
                # Save the parameters and results
                indss.append(ind)
                mss.append(ms)
                epss.append(epsilon)
                clusters.append(n_clusters)
                noise.append(n_noise)
                silhouettes.append(silh_coef)



# Restructure the information in a dataframe
results = pd.DataFrame(list(zip(indss,
                                mss,
                                epss,
                                clusters,
                                noise,
                                silhouettes)),
                        columns = ['Similarity',
                                   'MinPts',
                                   'Epsilon',
                                   'Cluster',
                                   'Noise',
                                   'Silhouette'])



# See the content of the dataframe
results


# Export the dataframe to a csv file
results.to_csv('dbscan_param_opt2.csv', index = False)
