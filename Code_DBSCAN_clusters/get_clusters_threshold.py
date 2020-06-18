#!/usr/bin/env python
# coding: utf-8

# Import the necessary libraries

import pandas as pd
import numpy as np

from sklearn.cluster import DBSCAN
from sklearn.metrics import pairwise_distances
from sklearn.metrics import silhouette_score




# Load the data 
df = pd.read_csv('disorder_concept.csv')
diseases = df['diseaseId'].unique()
feature = 'symptomName'
feature_matrix = pd.crosstab(df.diseaseName,df.symptomName)

#import variances from threshold results
variances = pd.read_csv('df_variances.csv')


# Values from the optimized parameters 
index = 'dice'
epsilon = 0.8
ms = 2



# Dictionary to store the diseases within each cluster
clusters_diseases = {}


# Save the distance metric as a numpy array
f_m_np = feature_matrix.to_numpy()


# Calculate the corresponding distances with the similarity index
distances = pairwise_distances(f_m_np, w=variances,
                               metric = index)


# Generate the model from the parameters
labels = DBSCAN(eps = epsilon, 
                       min_samples = ms, 
                       metric = "precomputed"
                      ).fit_predict(distances)

# Evaluation of the previous model
# -> Silhouette coefficient
# -> Number of clusters
# -> Number of outliers
silh_coef = silhouette_score(distances,
                             labels,
                             metric = 'precomputed')
n_clusters =  len(set(labels)) - (1 if -1 in labels else 0) 
n_noise = list(labels).count(-1)


# Structure the diseases to know which ones belong to each cluster
for i in range(len(diseases)): 
    if labels[i] != -1:
        if labels[i] in clusters_diseases:
            clusters_diseases[labels[i]].append(diseases[i])
        else:
            clusters_diseases[labels[i]] = [diseases[i]] 


# Save the results in txt files

foutname = "clusters_" + feature + '_' + index + "_ms" + str(ms) + "_eps" + str(epsilon) + ".txt"

with open(foutname, "w") as fileout:

    print('Writing the results in file: ', foutname)

    fileout.write("CLUSTERS for " + feature + ', '+ index + ", MS " + str(ms) + ", eps " + str(epsilon) + "\n")
    fileout.write("\t--> Number of clusters: " + str(n_clusters) + "\n")
    fileout.write("\t--> Number of outliers: " + str(n_noise) + "\n")
    fileout.write("\t--> Silhouette coefficient: " + str(silh_coef) + "\n\n")


    for clus, diseases_list in clusters_diseases.items():

        diseases_list.sort()
        fileout.write(str("Cluster " + str(clus) + ":\n"))

        for dis in diseases_list:
            # Get the name of the disease from the dataframe diseases_names
            dis_name = df.loc[df["diseaseId"] == dis]["diseaseName"].values[0]
            fileout.write(str("\t" + str(dis) + "\t" + str(dis_name) + "\n"))
            
        fileout.write(str("\tNumber of diseases: " + str(len(diseases_list)) + "\n\n\n"))


print('--> DONE!')





