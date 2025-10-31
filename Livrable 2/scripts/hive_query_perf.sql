
SELECT COUNT(*) AS total_deces
FROM fait_deces;


SELECT COUNT(*) AS nb_deces_1983
FROM fait_deces d
WHERE d.annee_deces = '1983';


SELECT COUNT(*) AS nb_deces_region
FROM fait_deces d
JOIN dim_localisation l ON d.id_lieu = l.id_localisation
WHERE l.region = 'Auvergne-Rhône-Alpes';


SELECT t.annee, COUNT(*) AS nb_deces
FROM fait_deces d
JOIN dim_temps t ON d.id_temps = t.id_temps
GROUP BY t.annee
ORDER BY t.annee;


SELECT l.region, t.annee, COUNT(*) AS nb_deces
FROM fait_deces d
JOIN dim_localisation l ON d.id_lieu = l.id_localisation
JOIN dim_temps t ON d.id_temps = t.id_temps
GROUP BY l.region, t.annee
ORDER BY t.annee, l.region;


SELECT 
    t.annee,
    COUNT(*) AS nb_deces,
    SUM(COUNT(*)) OVER (ORDER BY t.annee ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumul_deces
FROM fait_deces d
JOIN dim_temps t ON d.id_temps = t.id_temps
GROUP BY t.annee
ORDER BY t.annee;
