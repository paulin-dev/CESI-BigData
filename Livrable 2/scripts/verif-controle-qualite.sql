-- Vérifier le nombre d'enregistrements
SELECT COUNT(*) FROM dim_patient;
SELECT COUNT(*) FROM fait_hospitalisation WHERE annee = 2020;

-- Vérifier les jointures
SELECT e.region, COUNT(*) AS nb_consultations
FROM fait_consultation f
JOIN dim_etablissement e ON f.identifiant_organisation = e.identifiant_organisation
GROUP BY e.region;
