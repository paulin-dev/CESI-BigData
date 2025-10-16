# Architecture

## Stack technique
La stack technique proposée pour la plateforme de données du CHU est conçue pour répondre aux exigences de sécurité, de conformité RGPD, de scalabilité et d’interopérabilité avec les outils de business intelligence (BI). Elle s’appuie sur des technologies open source éprouvées dans le domaine du Big Data.

### 1. **Sources de données**
- **PostgreSQL**  
  Base de données relationnelle utilisée pour stocker les données médico-administratives structurées (ex. : dossiers patients, actes, etc.).
- **Fichiers CSV**  
  Fichiers plats contenant des données externes (ex. : informations sur les établissements hospitaliers, données de décès).
- **Fichiers plats**  
  Autres fichiers structurés ou semi-structurés, ici pour la satisfaction des patients (questionnaires, retours, etc.).

### 2. **ETL & Intégration (Apache NiFi)**
- **Apache NiFi**  
  Outil open source d’orchestration ETL permettant de :
  - Extraire les données depuis les différentes sources (bases, fichiers, etc.)
  - Transformer les données (nettoyage, anonymisation, formatage, etc.)
  - Charger les données transformées dans la plateforme de stockage (Hadoop)
  - Gérer à la fois les flux batch (périodiques) et temps réel (CDC – Change Data Capture pour les modifications en direct sur PostgreSQL)
- **ETL**  
  Le projet exploite des sources de données variées (structurées et non structurées) et implique le traitement de données médicales sensibles soumises au RGPD. Deux approches étaient envisageables : ETL (Extract, Transform, Load) ou ELT (Extract, Load, Transform).

  L’approche ETL a été retenue car elle permet :
  - d’anonymiser et transformer les données avant leur chargement, renforçant la sécurité
  - de réduire le risque en évitant la conservation de données identifiantes en clair
  - de respecter les exigences du RGPD et de la CNIL (anonymisation, traçabilité, contrôle d’accès)
  - d’assurer la conformité d’hébergement HDS pour les données de santé
  - de faciliter les audits et la preuve de conformité (logs, versions, DPIA)

  Le choix d’un ETL pur s’impose ici pour sa simplicité, sa maîtrise et sa conformité, garantissant la protection des données sensibles et la structuration fiable du data warehouse.

### 3. **Entrepôt de données (Data Warehouse - Apache Hadoop)**
- **HDFS (Hadoop Distributed File System)**  
  Système de fichiers distribué pour stocker de gros volumes de données de façon scalable et fiable.
- **Hive Metastore (+ PostgreSQL)**  
  Composant de catalogage des tables et schémas de données, permettant à différents outils d’accéder aux métadonnées. Ici, le Metastore peut s’appuyer sur une base PostgreSQL pour stocker ses informations.
- **HiveServer2**  
  Serveur SQL (Hive) permettant d’interroger les données stockées sur Hadoop via des requêtes SQL standardisées (HiveQL), compatible avec de nombreux outils de BI et d’analyse.

### 4. **Analyse & Visualisation**
- **Hue**  
  Interface web facilitant l’exploration, la requête et la visualisation des données stockées sur Hadoop (notamment via Hive).
- **Power BI**  
  Outil de business intelligence de Microsoft, utilisé pour créer des tableaux de bord interactifs et visualiser les KPIs à partir des données du data warehouse.


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
