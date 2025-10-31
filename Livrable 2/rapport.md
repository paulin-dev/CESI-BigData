# Livrable 2 

## Script de création des tables

Les fichiers `scripts/create_dimensions.sql` et `scripts/create_faits.sql` contiennent les scripts SQL pour la création des tables de dimensions et de faits respectivement (avec partitionnement et bucketing). Des jobs NiFi ont été utilisés pour automatiser le processus de création des tables.

## Jobs NiFi pour le peuplement des tables

Les captures d'écran suivantes montrent les jobs Apache NiFi créés pour le peuplement des tables de l'entrepôt de données. Les jobs ont été exportés au format JSON et sont disponibles dans le dossier `jobs/`.

### Job fait_consultation_detailed
*Version détaillée des processors*
![Job fait_consultation_detailed](images/job_fait_consultation_detailed.png)

### Job fait_deces
![Job fait_deces](images/job_fait_deces.png)

### Job fait_hospitalisation
![Job fait_hospitalisation](images/job_fait_hospitalisation.png)

### Job fait_satisfaction
![Job fait_satisfaction](images/job_fait_satisfaction.png)

### Job dim_diagnostic
![Job dim_diagnostic](images/job_dim_diagnostic.png)

### Job dim_etablissement
![Job dim_etablissement](images/job_dim_etablissement.png)

### Job dim_localisation
![Job dim_localisation](images/job_dim_localisation.png)

### Job dim_patient
![Job dim_patient](images/job_dim_patient.png)

### Job dim_professionnel_sante
![Job dim_professionnel_sante](images/job_dim_professionnel_sante.png)

### Job dim_specialite
![Job dim_specialite](images/job_dim_specialite.png)


## Vérification des données

L'interface Hue a été utilisée pour vérifier les données présentes dans les tables de l'entrepôt de données.

![Vérification des données](images/hue_tables.png)
![Vérification des données](images/hue_data.png)

## Évaluation de la performance

Les rêquêtes SQL utilisées pour évaluer la performance d'accès à l'entrepôt de données sont disponibles dans le fichier `scripts/hive_query_perf.sql`. Voici un graphe illustrant les temps de réponses obtenus lors de l'exécution de ces requêtes :

![Performance Graph](images/hive_query_perf_comparison.png)
