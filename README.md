# CESI BigData


## Architecture

```mermaid
flowchart LR

  %% Style
  classDef empty width:0,height:0;

  %% Sources de données brutes
  subgraph Sources["Sources de données"]
    A1[("PostgreSQL<br>Soins-medico-administratives")]
    A2@{ shape: processes, label: "CSV<br>Établissements hospitaliers & Décès"}
    A3@{ shape: processes, label: "Fichiers plats<br>Satisfaction patients"}
  end
  
  %% Ingestion/Intégration
  subgraph ETL["ETL & Intégration<br>(Apache NiFi)"]
    N0[ ]:::empty
    N1("Extraction")
    N2("Transformation<br>(et nettoyage)")
    N3("Chargement")
  end
  
  %% Stockage / Data Warehouse
  subgraph Hadoop["Entrepôt de données<br>(Apache Hadoop)"]
    H1[("HDFS")]
    H2[("Hive Metastore<br>(+ PostgreSQL)")]
    H3("HiveServer2")
    %%H4[(Hue - Interface Web)]
  end
  
  %% Analyse / Visualisation
  subgraph BI["Visualisation des données "]
    B1(Power BI)
    B2(Tableaux de bord<br>KPIs Santé)
  end
  
  %% Relations
  A1 e1@--- |"CDC<br>(capture des changements en temps réel)"| N0
  A2 e2@--- |"Batch"| N0
  A3 e3@--- |"Batch"| N0
  N0 e4@--> N1 --> N2 --> N3 e5@--> |"Batch"| H1 --> H3
  N3 e6@--> |"Temps réel"| H3
  H3 e7@--> B1 --> B2
  H2 --> H3
  %%H4 --> H3

  %% Animations
  e1@{ animation: slow }
  e2@{ animation: slow }
  e3@{ animation: slow }
  e4@{ animation: slow }
  e5@{ animation: slow }
  e6@{ animation: slow }
  e7@{ animation: slow }
```
