# Architecture

## Choix ETL

Dans le cadre du projet, les sources de données sont variées et combinent des données structurées (bases de données, fichiers CSV) et non structurées (documents, fichiers texte, etc.). Compte tenu des exigences du RGPD et de la sensibilité des données médicales traitées, le choix entre les approches ETL (Extract, Transform, Load) et ELT (Extract, Load, Transform) doit être effectué avec précaution.

L’approche ETL permet de transformer et anonymiser les données avant leur chargement, garantissant ainsi une meilleure sécurité et une conformité réglementaire renforcée. 
L’ELT, plus rapide et évolutive, effectue les transformations directement dans le data Warehouse, mais exige une infrastructure fortement sécurisée, parfois complexe à mettre en place dans un cadre sensible.

Raisons majeures de privilégier ETL (liées au contexte CHU / RGPD)
Minimisation du risque : on ne conserve pas de copies longues durées de données identifiantes en clair (réduction de la « surface d’attaque »).
Pseudonymisation / anonymisation en amont : transformer (masquer, hacher, tokeniser) avant chargement permet d’appliquer des contrôles d’accès stricts et une traçabilité fine. (CNIL insiste sur la différence anonymisation/pseudonymisation et la nécessité de mesures adaptées pour les données de santé).
Conformité d’hébergement : en France les données de santé doivent être hébergées chez un hébergeur certifié HDS ou sur infrastructure interne répondant aux exigences (donc éviter d’envoyer des bruts sur un data-lake public non-certifié).
Auditabilité & preuve de conformité : ETL centralise les règles de transformation et laisse des traces (logs, versions), facilitant DPIA, audits CNIL et démonstration d’encadrement juridique.

Bien qu’une solution hybride combinant ETL et ELT puisse offrir un bon compromis entre performance et sécurité, le projet retient une approche ETL simple. Ce choix se justifie par le temps limité et la volonté de privilégier une solution plus maîtrisable en regroupant tout le processus au même endroit, tout en assurant la protection des données sensibles et la bonne structuration du data Warehouse. 



## Architecture

```mermaid
%%{init: {
  "theme": "base",
  "themeVariables": {
    "background": "transparent",
    "primaryColor": "#A2C2E2",
    "primaryTextColor": "#1a1a1a",
    "primaryBorderColor": "#5B8FB9",
    "lineColor": "#5B8FB9",
    "secondaryColor": "#B9D4E7",
    "tertiaryColor": "#F7FAFC",
    "fontSize": "14px",
    "edgeLabelBackground":"#f0f0f0",
    "nodeBorder": "2px"
  }
}}%%
flowchart LR

  %% Style
  classDef empty width:0,height:0;

  %% Sources de données brutes
  subgraph Sources["<b>Sources de données</b>"]
    A1[("<b>PostgreSQL</b><br><i>(soins-medico-administratives)</i>")]
    A2@{ shape: processes, label: "<b>CSV</b><br><i>(établissements hospitaliers & décès)</i>"}
    A3@{ shape: processes, label: "<b>Fichiers plats</b><br><i>(satisfaction patients)</i>"}
  end
  
  %% Ingestion/Intégration
  subgraph ETL["<b>ETL & Intégration</b><br>(Apache NiFi)"]
    N0[ ]:::empty
    N1("<b>Extraction</b>")
    N2("<b>Transformation</b>")
    N3("<b>Chargement</b>")
  end
  
  %% Stockage / Data Warehouse
  subgraph Hadoop["<b>Entrepôt de données</b><br>(Apache Hadoop)"]
    H1[("<b>HDFS</b>")]
    H2[("<b>Hive Metastore</b><br>(+ PostgreSQL)")]
    H3("<b>HiveServer2</b>")
    %%H4[(Hue - Interface Web)]
  end
  
  %% Analyse / Visualisation
  subgraph BI["<b>Visualisation des données</b>"]
    B1("<b>Power BI</b>")
    B2("<b>Hue</b>")
    B3("<b>Tableaux de bord</b><br><i>(KPIs)</i>")
    
  end
  
  %% Relations
  A1 e1@--- |"CDC<br><i>(capture des changements en temps réel)</i>"| N0
  A2 e2@--- |"Batch"| N0
  A3 e3@--- |"Batch"| N0
  N0 e4@--> N1 --> N2 --> N3 e5@--> |"Batch"| H1 <--> H3
  N3 e6@--> |"Temps réel"| H3
  H3 e7@<--> B2
  H3 e8@<--> B1 --> B3
  H2 <--> H3
  %%H4 --> H3

  %% Animations
  e1@{ animation: slow }
  e2@{ animation: slow }
  e3@{ animation: slow }
  e4@{ animation: slow }
  e5@{ animation: slow }
  e6@{ animation: slow }
  e7@{ animation: slow }
  e8@{ animation: slow }
```
