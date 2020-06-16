import numpy as np
import pandas as pd
from sklearn.feature_selection import VarianceThreshold
from sklearn.cluster import DBSCAN
from sklearn.metrics import pairwise_distances
from sklearn.metrics import silhouette_score


#feature_matrix = pd.read_csv("disorder_concept.csv")
df = pd.read_csv('disorder_concept.csv')
variances = pd.read_csv('df_variances.csv')


feature_matrix = pd.crosstab(df.diseaseName,df.symptomName)

# Guardamos la mtriz de distancias como un arreglo de Numpy
f_m_np = feature_matrix.to_numpy()



# Declaración de variables

# Eps (epsilon) es uno de los parámetros que debe ser especificado para DBSCAN 
# Definimos los siguientes valores para explorar los resultados:
epsilons = (0.2,
            0.3,
            0.4,
            0.5,
            0.6,
            0.7,
            0.8,
            0.9
           )

# MinPts (ms) es el otro parámetro que debe ser especificado para DBSCAN
# Definimos los siguientes valores para explorar los resultados:
ms_values = (2,
             3,
             5,
             10,
             30
            )

# Índices de similitudes a utilizar
sim_metrics = (
           'jaccard',
           'dice'
          )

# Listas que almacenan la combinación de parámetros y los resultados
indss = list() # Índices de similitud
mss = list() # Valores de MinPts
epss = list() # Valores de Eps
clusters = list() # Resultados del número de clusters
noise = list() # Resultados del número de outliers
silhouettes = list() # Resultados del coeficiente de silhouette


# Recorremos los 3 índices de similitud
for ind in sim_metrics:
    
    # Calculamos las distancias correspondientes con el índice de similitud
    distances = pairwise_distances(f_m_np, w= variances,
                                   metric = ind)
    
    # Recorremos los 4 posibles valores de MinPts
    for ms in ms_values:    

            # Recorremos los 3 valores de Eps
            for epsilon in epsilons:   

                # Generamos el modelo a partir de los parámetros
                labels = DBSCAN(eps = epsilon, 
                                       min_samples = ms, 
                                       metric = "precomputed"
                                      ).fit_predict(distances)

                # Todos los elementos son asignados como "-1"
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
                
                # Guardamos los parámetros y los resultados
                indss.append(ind)
                mss.append(ms)
                epss.append(epsilon)
                clusters.append(n_clusters)
                noise.append(n_noise)
                silhouettes.append(silh_coef)



# Reestructuramos la información en un dataframe 
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



# Vemos el contenido del dataframe
results


# Exportamos el dataframe a un fichero csv
results.to_csv('dbscan_param_opt1.csv', index = False)