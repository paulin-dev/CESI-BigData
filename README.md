# CESI BigData

&nbsp;&nbsp;&nbsp;&nbsp;Dans un contexte de transformation numérique du secteur de la santé, le groupe Cloud Healthcare Unit (CHU) souhaite mettre en place un entrepôt de données sécurisé pour exploiter, analyser et valoriser les données médicales issues de ses différents systèmes tout en garantissant la conformité au RGPD et la protection des données sensibles des patients.

## Architecture

```mermaid
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
    B2("<b>Tableaux de bord</b><br><i>(KPIs)</i>")
  end
  
  %% Relations
  A1 e1@--- |"CDC<br><i>(capture des changements en temps réel)</i>"| N0
  A2 e2@--- |"Batch"| N0
  A3 e3@--- |"Batch"| N0
  N0 e4@--> N1 --> N2 --> N3 e5@--> |"Batch"| H1 <--> H3
  N3 e6@--> |"Temps réel"| H3
  H3 e7@<--> B1 --> B2
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
```


## Modèle de données 

```mermaid
erDiagram
	direction TB

	%% === DIMENSIONS ===

	DIM_PATIENT {
		int Id_patient
		string Anom_Sexe
		int Age
	}

	DIM_PROFESSIONNEL_SANTE {
		string Id_prof_sante
		string Anom_Nom
		string Anom_Prenom
		string Categorie_professionnelle
		string Code_specialite
	}

	DIM_DIAGNOSTIC {
		string Code_diag
		string Diagnostic
	}

	DIM_ETABLISSEMENT {
		string identifiant_organisation
		string Nom_etablissement
		string Code_region
		string Region
	}

	DIM_LOCALISATION {
		string Localisation_ID
		string Code_reg
		string Libelle_region
		string Code_commune
		string Nom_commune
		string Pays
	}

	DIM_TEMPS {
		string Temps_ID
		date Date
		int Annee
		int Mois
		int Trimestre
	}

	DIM_INDICATEUR_QUALITE {
		string Code_indicateur
		string Nom_indicateur
		string Type_indicateur
	}

	%% === FAITS ===

	FAIT_CONSULTATION {
		string Num_consultation
		int Id_patient
		string Id_prof_sante
		string Code_diag
		string identifiant_organisation
		string Temps_ID
		string Localisation_ID
	}

	FAIT_HOSPITALISATION {
		string Num_Hospitalisation
		int Id_patient
		string identifiant_organisation
		string Code_diag
		string Temps_ID
		string Localisation_ID
	}

	FAIT_DECES {
		string Anom_Sexe
		string Localisation_ID_deces
		string Temps_ID_deces
	}

	FAIT_SATISFACTION_QUALITE {
		string identifiant_organisation
		string Code_indicateur
		string Localisation_ID
		string Temps_ID
		float Valeur
	}

	%% === RELATIONS ===

	DIM_PATIENT||--o{FAIT_CONSULTATION:"Id_patient"
	DIM_PROFESSIONNEL_SANTE||--o{FAIT_CONSULTATION:"Id_prof_sante"
	DIM_DIAGNOSTIC||--o{FAIT_CONSULTATION:"Code_diag"
	DIM_ETABLISSEMENT||--o{FAIT_CONSULTATION:"identifiant_organisation"
	DIM_TEMPS||--o{FAIT_CONSULTATION:"Temps_ID"
	DIM_LOCALISATION||--o{FAIT_CONSULTATION:"Localisation_ID"

	DIM_PATIENT||--o{FAIT_HOSPITALISATION:"Id_patient"
	DIM_DIAGNOSTIC||--o{FAIT_HOSPITALISATION:"Code_diag"
	DIM_ETABLISSEMENT||--o{FAIT_HOSPITALISATION:"identifiant_organisation"
	DIM_TEMPS||--o{FAIT_HOSPITALISATION:"Temps_ID"
	DIM_LOCALISATION||--o{FAIT_HOSPITALISATION:"Localisation_ID"

	DIM_LOCALISATION||--o{FAIT_DECES:"Localisation_ID_deces"
	DIM_TEMPS||--o{FAIT_DECES:"Temps_ID_deces"

	DIM_ETABLISSEMENT||--o{FAIT_SATISFACTION_QUALITE:"identifiant_organisation"
	DIM_INDICATEUR_QUALITE||--o{FAIT_SATISFACTION_QUALITE:"Code_indicateur"
	DIM_LOCALISATION||--o{FAIT_SATISFACTION_QUALITE:"Localisation_ID"
	DIM_TEMPS||--o{FAIT_SATISFACTION_QUALITE:"Temps_ID"

	style FAIT_SATISFACTION_QUALITE fill:#D0F0C0,stroke:#228B22,color:#000000
	style FAIT_CONSULTATION fill:#CFE2FF,stroke:#0044CC,color:#000000
	style FAIT_HOSPITALISATION fill:#FFF4CC,stroke:#FFCC00,color:#000000
	style FAIT_DECES fill:#FADADD,stroke:#D61A46,color:#000000
```


## Jobs

