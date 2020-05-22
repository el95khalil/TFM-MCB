#disorder_concept query:

import pandas as pd
import mysql.connector

config = {'user': 'youness', 
          'password': 'youness1234', 
          'host': '138.4.130.153', 
          'port': '30604', 
          'database': 'modified_edsssdb'}


cnx = mysql.connector.connect(**config)

query = """  
        SELECT DISTINCT 
            d.disease_id AS diseaseId,
            d.name AS diseaseName,
            s.cui AS symptomId,
            s.name AS symptomName
        FROM
            edsssdb.disease d
                INNER JOIN
            edsssdb.has_disease hd ON hd.disorder_id = d.disease_id
                INNER JOIN
            edsssdb.document doc ON doc.document_id = hd.document_id
                AND doc.date = hd.date
                INNER JOIN
            has_section hse ON hse.document_id = doc.document_id
                AND hse.date = doc.date
                INNER JOIN
            has_text ht ON ht.document_id = hse.document_id
                AND ht.date = hse.date
                AND ht.section_id = hse.section_id
                INNER JOIN
            has_symptom hsy ON hsy.text_id = ht.text_id
                INNER JOIN
            symptom s ON s.cui = hsy.cui
        WHERE
            d.relevant = TRUE
                AND hsy.validated = TRUE
        """ 
 
data = pd.read_sql_query(query, con = cnx)

cnx.close()
data.to_csv('disorder_concept.csv')



#snapshot_source query:

import pandas as pd
import mysql.connector

config = {'user': 'youness', 
          'password': 'youness1234', 
          'host': '138.4.130.153', 
          'port': '30604', 
          'database': 'modified_edsssdb'}


cnx = mysql.connector.connect(**config)

query = """
        SELECT DISTINCT
            d.disorder_id AS disorderID,
            d.name AS disorderName,
            s.source_id AS sourceId,
            s.name AS sourceName,
            c.snapshot AS snapshot
        FROM
          disorder  d
                INNER JOIN 
          has_disorder hd ON d.disorder_id = hd.disorder_id
                INNER JOIN 
          disnet_document dd ON hd.document_id = dd.document_id AND hd.date = dd.date
                INNER JOIN 
          has_source hs ON dd.document_id = hs.document_id AND dd.date = hs.date
                INNER JOIN      
          source s ON hs.source_id = s.source_id
                INNER JOIN 
          configuration c ON s.source_id = c.source_id
        """  


data = pd.read_sql_query(query, con = cnx)

cnx.close() 
data.to_csv('snapshot_source.csv')
