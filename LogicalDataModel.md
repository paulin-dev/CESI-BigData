# Modèle Lgique de données

Pour répondre aux besoins analytiques du groupe Cloud Healthcare Unit (CHU), nous avons choisi d’adopter un schéma constellation plutôt qu’un schéma en étoile classique. Ce choix se justifie par plusieurs raisons liées au contexte de notre projet et aux analyses attendues par les utilisateurs :

Multiples faits pour différents indicateurs :

Les utilisateurs souhaitent analyser à la fois les consultations, les hospitalisations, les décès et les scores de satisfaction.

Chacune de ces entités représente un fait distinct avec ses propres mesures et dimensions associées. **Le schéma constellation permet de modéliser plusieurs faits partageant différentes dimensions.**

Partage des dimensions communes :

Les faits (consultation, hospitalisation, décès, satisfaction) partagent des dimensions telles que Patient, Établissement, Localisation, Temps, Diagnostic.

Le schéma constellation permet de centraliser ces dimensions pour tous les faits concernés, ce qui simplifie l’entretien, améliore la cohérence et réduit la redondance des données.

Flexibilité pour les analyses multi-indicateurs :

Le schéma constellation est particulièrement adapté aux requêtes complexes et croisements multiples, par exemple :

- Taux d’hospitalisation par sexe et âge vs taux de consultation par diagnostic.

- Comparaison des décès par région avec la satisfaction des patients par établissement.

Évolutivité et maintenance :

Les nouvelles mesures ou indicateurs pourront être intégrés sous forme de nouveaux faits, en réutilisant les dimensions déjà existantes.

Le schéma constellation permet ainsi **une scalabilité**, ce qui est essentiel dans le contexte hospitalier où les sources de données sont hétérogènes et en croissance continue.

## Modèle logique de données : Constellation

### Schéma initial — Données complètes sans anonymisation :

```mermaid
flowchart LR

erDiagram
	direction TB

	DIM_PATIENT {
		int Id_patient
		string Num
		string Code
		string Nom
		string Prenom
		string Adresse
		string Code_diag
	}

	DIM_MUTUELLE {
		int Id_Mut
		string Nom
		string Adresse
	}

	DIM_PROFESSIONNEL_SANTE {
		string Id_prof_sante
		string Civilite
		string Categorie_professionnelle
		string Nom
		string Prenom
		string Profession
		string Type_identifiant
		string Code_specialite
	}

	DIM_ACTIVITE_PROFESSIONNELLE {
		string Identifiant
		string Identifiant_organisation
		string Mode_exercice
	}

	DIM_SPECIALITE {
		string Code_specialite
		string Fonction
		string Specialite
	}

	DIM_DIAGNOSTIC {
		string Code_diag
		string Diagnostic
	}

	DIM_MEDICAMENT {
		string Code_CIS
		string Denomination
		string Forme_pharmaceutique
		string Voies_d_administration
		string Statut_administratif
		string Type_de_procedure
		string Etat_de_commercialisation
		date Date_AMM
		string StatutBdm
		string Num_autorisation_europeenne
		string Titulaire
		string Surveillance_renforcee
	}

	DIM_ETABLISSEMENT {
		string finess_etablissement_juridique
		string finess_site
		string identifiant_organisation
		string raison_sociale_site
		string adresse
		string cedex
		string code_commune
		string code_postal
		string commune
		string complement_destinataire
		string complement_point_geographique
		string email
		string enseigne_commerciale_site
		string pays
		string siren_site
		string siret_site
		string telecopie
		string telephone
		string telephone_2
		string type_voie
		string voie
	}

	DIM_LOCALISATION {
		string Localisation_ID
		string Type_Localisation "Patient_Naissance / Patient_Deces / Etablissement"
		string Code_reg
		string Libelle_region
		string Code_commune
		string Nom_commune
		string Pays
		string Finess
	}

	DIM_TEMPS {
		string Temps_ID
		date Date
		int Annee
		int Mois
		int Trimestre
		int Jour
		string Jour_semaine
	}

	FAIT_CONSULTATION {
		string Num_consultation
		int Id_patient
		int Id_mut
		string Id_prof_sante
		string Code_diag
		string Motif
		string Temps_ID
		string Localisation_ID
		time Heure_debut
		time Heure_fin
	}

	FAIT_PRESCRIPTION {
		string Num_consultation
		string Code_CIS
	}

	FAIT_HOSPITALISATION {
		string Num_Hospitalisation
		int Id_patient
		string identifiant_organisation
		string Code_diagnostic
		string Suite_diagnostic_consultation
		string Temps_ID
		string Localisation_ID
		int Jour_Hospitalisation
	}

	FAIT_DECES {
		string Nom
		string Prenom
		string Sexe
		string Localisation_ID_naissance
		string Localisation_ID_deces
		string Temps_ID_naissance
		string Temps_ID_deces
		string numero_acte_deces
	}

	DIM_INDICATEUR_QUALITE {
		string Code_indicateur
		string Nom_indicateur
		string Type_indicateur
		string Objectif_national
		string Source
		string Description
		string Reference
	}

	FAIT_SATISFACTION_QUALITE {
		string Finess
		string Code_indicateur
		string Localisation_ID
		string Temps_ID
		string Cat
		string Source
		float Valeur_den_etbt
		float Valeur_etbt
		float Valeur_icbas_etbt
		float Valeur_ichaut_etbt
	}

	%% RELATIONS

	DIM_PATIENT||--o{FAIT_CONSULTATION:"Id_patient"
	DIM_MUTUELLE||--o{FAIT_CONSULTATION:"Id_Mut"
	DIM_PROFESSIONNEL_SANTE||--o{FAIT_CONSULTATION:"Id_prof_sante"
	DIM_DIAGNOSTIC||--o{FAIT_CONSULTATION:"Code_diag"
	DIM_TEMPS||--o{FAIT_CONSULTATION:"Temps_ID"
	DIM_LOCALISATION||--o{FAIT_CONSULTATION:"Localisation_ID"

	FAIT_CONSULTATION||--o{FAIT_PRESCRIPTION:"Num_consultation"
	DIM_MEDICAMENT||--o{FAIT_PRESCRIPTION:"Code_CIS"

	DIM_PATIENT||--o{FAIT_HOSPITALISATION:"Id_patient"
	DIM_ETABLISSEMENT||--o{FAIT_HOSPITALISATION:"identifiant_organisation"
	DIM_DIAGNOSTIC||--o{FAIT_HOSPITALISATION:"Code_diagnostic"
	DIM_TEMPS||--o{FAIT_HOSPITALISATION:"Temps_ID"
	DIM_LOCALISATION||--o{FAIT_HOSPITALISATION:"Localisation_ID"

	DIM_LOCALISATION||--o{FAIT_DECES:"Localisation_ID_naissance / Localisation_ID_deces"
	DIM_TEMPS||--o{FAIT_DECES:"Temps_ID_naissance / Temps_ID_deces"

	DIM_SPECIALITE||--o{DIM_PROFESSIONNEL_SANTE:"Code_specialite"
	DIM_ACTIVITE_PROFESSIONNELLE||--o{DIM_ETABLISSEMENT:"identifiant_organisation"

	DIM_ETABLISSEMENT||--o{FAIT_SATISFACTION_QUALITE:"Finess"
	DIM_INDICATEUR_QUALITE||--o{FAIT_SATISFACTION_QUALITE:"Code_indicateur"
	DIM_LOCALISATION||--o{FAIT_SATISFACTION_QUALITE:"Localisation_ID"
	DIM_TEMPS||--o{FAIT_SATISFACTION_QUALITE:"Temps_ID"

	style DIM_MEDICAMENT fill:#FFF9C4,stroke:#FFD600,color:#000000
	style FAIT_SATISFACTION_QUALITE fill:#D0F0C0,stroke:#228B22,color:#000000

```

### Schéma final — Modèle logique anonymisé et optimisé selon les besoins utilisateurs : 

&nbsp;&nbsp;&nbsp;&nbsp;Un préfixe Anom est utilisé pour désigner les tables ou champs contenant des données anonymisées destinées aux statistiques finales et à la visualisation. Ces données ont été modifiées afin d’éviter tout risque de violation de confidentialité.

En cas d’évolution du modèle ou de besoin d’ajout de nouvelles données anonymisées, un script d’automatisation permettra de générer et de mettre à jour/ajouter des tables. Le modèle logique ainsi défini correspond exclusivement au jeu de données nécessaire à la visualisation et à l’analyse des indicateurs.

```mermaid
flowchart LR

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

**Suppression des tables inutiles** : DIM_MUTUELLE, DIM_MEDICAMENT, DIM_ACTIVITE_PROFESSIONNELLE | Ces données ne sont pas nécessaires pour les indicateurs demandés (aucun besoin sur mutuelles, médicaments ou activité détaillée).
**Ajout du préfixe `Anom_`** sur les attributs personnels (Nom, Prénom, Sexe) :  Respect du RGPD — ces champs doivent être anonymiser. 
**Simplification des dimensions** : Garder uniquement les dimensions utiles à l’analyse : Patient, Professionnel, Diagnostic, Etablissement, Localisation, Temps, Indicateur Qualité.
**Réduction du schéma** : Facilite la modélisation et les performances pour la visualisation.
**Utilisation de valeurs agrégées** dans FAIT_SATISFACTION_QUALITE : Permet de calculer directement les taux et scores nécessaires aux tableaux de bord. 


Avec ce modèle, on réponds au besoin des indicateurs demandés par CHU :
- **Consultations** par établissement, diagnostic, période, professionnel.  
- **Hospitalisations** par sexe, âge, diagnostic, période.  
- **Décès** par localisation et année.  
- **Satisfaction** par région et année.