-- === PEUPLEMENT DIMENSIONS ===

INSERT OVERWRITE TABLE dim_patient
SELECT DISTINCT
    CAST(id AS BIGINT),
    CASE WHEN sexe = 'M' THEN 'H' ELSE 'F' END AS anom_sexe,
    FLOOR(DATEDIFF(current_date, date_naissance)/365) AS age
FROM staging_patients;

INSERT OVERWRITE TABLE dim_etablissement
SELECT DISTINCT
    identifiant_organisation,
    nom_etablissement,
    code_region,
    region
FROM staging_etablissements;

INSERT OVERWRITE TABLE dim_diagnostic
SELECT DISTINCT
    code_diag,
    libelle
FROM staging_diagnostics;

INSERT OVERWRITE TABLE dim_professionnel_sante
SELECT DISTINCT
    id_prof_sante,
    sha2(nom,256) AS anom_nom,
    sha2(prenom,256) AS anom_prenom,
    categorie_professionnelle,
    code_specialite
FROM staging_professionnels;

-- === PEUPLEMENT FAITS ===

INSERT OVERWRITE TABLE fait_consultation PARTITION (annee)
SELECT
    num_consultation,
    id_patient,
    id_prof_sante,
    code_diag,
    identifiant_organisation,
    temps_id,
    localisation_id,
    YEAR(date_consultation) AS annee
FROM staging_consultations;

INSERT OVERWRITE TABLE fait_hospitalisation PARTITION (annee)
SELECT
    num_hospitalisation,
    id_patient,
    identifiant_organisation,
    code_diag,
    temps_id,
    localisation_id,
    YEAR(date_hospitalisation) AS annee
FROM staging_hospitalisations;

INSERT OVERWRITE TABLE fait_deces PARTITION (annee)
SELECT
    anom_sexe,
    localisation_id_deces,
    temps_id_deces,
    YEAR(date_deces) AS annee
FROM staging_deces;

INSERT OVERWRITE TABLE fait_satisfaction_qualite PARTITION (annee)
SELECT
    identifiant_organisation,
    code_indicateur,
    localisation_id,
    temps_id,
    AVG(valeur) AS valeur,
    2020 AS annee
FROM staging_satisfaction
GROUP BY identifiant_organisation, code_indicateur, localisation_id, temps_id;
