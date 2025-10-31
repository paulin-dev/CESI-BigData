SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
SET hive.enforce.bucketing = true;


CREATE TABLE dim_patient (
    id_patient BIGINT,
    anom_sexe STRING,
    age INT
)
COMMENT 'Dimension patient (anonymisée)'
PARTITIONED BY (anom_sexe STRING)
CLUSTERED BY (id_patient) INTO 8 BUCKETS
STORED AS PARQUET;


CREATE TABLE dim_diagnostic (
    code_diag STRING,
    diagnostic STRING
)
COMMENT 'Dimension diagnostic médical'
PARTITIONED BY (diagnostic STRING)
CLUSTERED BY (code_diag) INTO 8 BUCKETS
STORED AS PARQUET;


CREATE TABLE dim_diagnostic (
    code_diag STRING,
    diagnostic STRING
)
COMMENT 'Dimension diagnostic médical'
STORED AS PARQUET;


CREATE TABLE dim_etablissement (
    identifiant_organisation STRING,
    nom_etablissement STRING,
    code_region STRING,
    region STRING
)
COMMENT 'Dimension des établissements hospitaliers'
STORED AS PARQUET;


CREATE TABLE dim_localisation (
    localisation_id STRING,
    code_region STRING,
    region STRING,
    code_commune STRING,
    nom_commune STRING,
    pays STRING
)
COMMENT 'Dimension géographique (région, commune, pays)'
PARTITIONED BY (libelle_region STRING)
CLUSTERED BY (localisation_id) INTO 8 BUCKETS
STORED AS PARQUET;


CREATE TABLE dim_temps (
    temps_id STRING,
    date_entiere DATE,
    mois INT,
    trimestre INT
)
COMMENT 'Dimension temporelle'
PARTITIONED BY (annee INT)
CLUSTERED BY (temps_id) INTO 8 BUCKETS
STORED AS PARQUET;


CREATE TABLE dim_indicateur_qualite (
    code_indicateur STRING,
    nom_indicateur STRING,
    type_indicateur STRING
)
COMMENT 'Dimension des indicateurs de satisfaction'
STORED AS PARQUET;
