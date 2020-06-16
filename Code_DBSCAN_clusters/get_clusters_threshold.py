#!/usr/bin/env python
# coding: utf-8

# # Inspección de los clusters que se forman con DBSCAN

# **Author: Lucía Prieto Santamaría** (lucia.prieto.santamaria@alumnos.upm.es)


# Importamos las librerías necesarias

import pandas as pd
import numpy as np

from sklearn.cluster import DBSCAN
from sklearn.metrics import pairwise_distances
from sklearn.metrics import silhouette_score




# Obtenemos el dataframe con los identificadores y nombres de las enfermedades
df = pd.read_csv('disorder_concept.csv')

# Del csv con las relaciones diseorder-feature obtenemos la lista de enfermedades con la que estamos trabajando
diseases = df['diseaseId'].unique()
variances = pd.read_csv('df_variances.csv')


# Declaración de variables

# Valores para los parámetros de DBSCAN previamente optimizados
index = 'dice'
epsilon = 0.8
ms = 2

# Nombre de la característica con la que se está trabajando
feature = 'symptomName'

# Diccionario en el que vamos a almacenar las enfermedades que hay dentro de cada cluster
clusters_diseases = {}


# Leemos el fichero csv con la matriz de características que hemos generado 
# con el script "generate_boolean_matrices.py"

feature_matrix = pd.crosstab(df.diseaseName,df.symptomName)


# Guardamos la mtriz de distancias como un arreglo de Numpy
f_m_np = feature_matrix.to_numpy()


# Calculamos las distancias correspondientes con el índice de similitud
distances = pairwise_distances(f_m_np, w=variances,
                               metric = index)


# Generamos el modelo a partir de los parámetros
labels = DBSCAN(eps = epsilon, 
                       min_samples = ms, 
                       metric = "precomputed"
                      ).fit_predict(distances)

# Evaluación del modelo anterior
#      --> Coeficiente de silhouette
#      --> Número de clusters
#      --> Número de outliers
silh_coef = silhouette_score(distances,
                             labels,
                             metric = 'precomputed')
n_clusters =  len(set(labels)) - (1 if -1 in labels else 0) 
n_noise = list(labels).count(-1)


# Estructuramos las enfermedades para saber cuáles pertenecen a cada cluster
for i in range(len(diseases)): 
    if labels[i] != -1:
        if labels[i] in clusters_diseases:
            clusters_diseases[labels[i]].append(diseases[i])
        else:
            clusters_diseases[labels[i]] = [diseases[i]] 


# Escribimos los resultados en un fichero

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
            # Obtenemos el nombre de la enfermedad a partir del dataframe diseases_names
            dis_name = df.loc[df["diseaseId"] == dis]["diseaseName"].values[0]
            fileout.write(str("\t" + str(dis) + "\t" + str(dis_name) + "\n"))
            
        fileout.write(str("\tNumber of diseases: " + str(len(diseases_list)) + "\n\n\n"))


print('--> DONE!')





