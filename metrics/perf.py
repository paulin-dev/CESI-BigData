#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Built-in imports
import time

# 3rd party imports
from pyhive import hive
import pandas as pd

# Constants
QUERIES = {
    'Q1_SimpleSelect': '''
        SELECT COUNT(*) AS total_deces
        FROM fait_deces;
    ''',
    
    'Q2_SimpleFilteredSelect':
        '''
        SELECT COUNT(*) AS nb_deces_1983
        FROM fait_deces d
        WHERE d.annee_deces = '1983';
    ''',

    'Q3_FilteredSelect': '''
        SELECT COUNT(*) AS nb_deces_region
        FROM fait_deces d
        JOIN dim_localisation l ON d.id_lieu = l.id_localisation
        WHERE l.region = 'Auvergne-Rhône-Alpes';
    ''',

    'Q4_Aggregation': '''
        SELECT t.annee, COUNT(*) AS nb_deces
        FROM fait_deces d
        JOIN dim_temps t ON d.id_temps = t.id_temps
        GROUP BY t.annee
        ORDER BY t.annee;
    ''',

    'Q5_Join': '''
        SELECT l.region, t.annee, COUNT(*) AS nb_deces
        FROM fait_deces d
        JOIN dim_localisation l ON d.id_lieu = l.id_localisation
        JOIN dim_temps t ON d.id_temps = t.id_temps
        GROUP BY l.region, t.annee
        ORDER BY t.annee, l.region;
    ''',

    'Q6_AnalyticFunction': '''
        SELECT 
          t.annee,
          COUNT(*) AS nb_deces,
          SUM(COUNT(*)) OVER (ORDER BY t.annee ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumul_deces
        FROM fait_deces d
        JOIN dim_temps t ON d.id_temps = t.id_temps
        GROUP BY t.annee
        ORDER BY t.annee;
    '''
}


# Connection parameters
conn = hive.Connection(
    host='localhost',
    port=10000,
    username='hive',
    database='default',
    auth='NONE'
)
cursor = conn.cursor()


def execute(query: str) -> float:
    start = time.perf_counter()
    cursor.execute(query)
    cursor.fetchall()
    return time.perf_counter()-start


def main():
    try:
        results = []
        for name, query in QUERIES.items():
            duration = execute(query.strip().strip(';'))  # Remove trailing semicolon
            results.append({'Query': name, 'Duration (s)': duration})

        df = pd.DataFrame(results)
        #df.to_csv('metrics/hive_query_perf_without_opt.csv', index=False)
        df.to_csv('metrics/hive_query_perf_with_opt.csv', index=False)

    finally:
        cursor.close()
        conn.close()


if __name__ == '__main__':
    main()
