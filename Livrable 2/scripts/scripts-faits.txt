CREATE TABLE fait_consultation (
    num_consultation STRING,
    id_patient BIGINT,
    id_prof_sante STRING,
    code_diag STRING,
    identifiant_organisation STRING,
    temps_id STRING,
    localisation_id STRING
)
COMMENT 'Fait des consultations patients'
PARTITIONED BY (annee INT)
CLUSTERED BY (code_diag) INTO 8 BUCKETS
STORED AS PARQUET;

CREATE TABLE fait_hospitalisation (
    num_hospitalisation STRING,
    id_patient BIGINT,
    identifiant_organisation STRING,
    code_diag STRING,
    temps_id STRING,
    localisation_id STRING
)
COMMENT 'Fait des hospitalisations'
PARTITIONED BY (annee INT)
CLUSTERED BY (identifiant_organisation) INTO 8 BUCKETS
STORED AS PARQUET;

CREATE TABLE fait_deces (
    anom_sexe STRING,
    localisation_id_deces STRING,
    temps_id_deces STRING
)
COMMENT 'Fait des décès par localisation et année'
PARTITIONED BY (annee INT)
STORED AS PARQUET;

CREATE TABLE fait_satisfaction_qualite (
    identifiant_organisation STRING,
    code_indicateur STRING,
    localisation_id STRING,
    temps_id STRING,
    valeur FLOAT
)
COMMENT 'Fait des notes de satisfaction par établissement et région'
PARTITIONED BY (annee INT)
STORED AS PARQUET;
