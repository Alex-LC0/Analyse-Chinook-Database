# Analyse-Chinook-Database

Analyse des résultats de ventes de la base de donnée SQL Chinook, afin d’identifier des KPI dans : 

* Le pôle vente

* Le pôle produit

Afin de proposer des éléments de développement pour la plateforme.

*Plan de la base de donnée SQL* : 

![Base donnée LeRocha](https://private-user-images.githubusercontent.com/135025/299867754-cea7a05a-5c36-40cd-84c7-488307a123f4.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODk4MjUwOTUsIm5iZiI6MTc4OTgyNDc5NSwicGF0aCI6Ii8xMzUwMjUvMjk5ODY3NzU0LWNlYTdhMDVhLTVjMzYtNDBjZC04NGM3LTQ4ODMwN2ExMjNmNC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwOTE5JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDkxOVQxMzMzMTVaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1iNDYwMWUxNTI5MTFlN2JhODcyNzM0ODE0NWNkZjFjOTNiYjFmMGIzMWZhMGViYzExZjljMWFiMWFlNzUyYzA3JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9aW1hZ2UlMkZwbmcifQ.3KmEfujTsDd_TbKNUZib5T2cmAyE1rdI1Ed_Eld65ZM)

[Lien vers le Dashboard Google Sheet](https://docs.google.com/spreadsheets/d/1kT_GaW7bJ1dAgemWcfduzlwn4FZbAWzGctIse715TiU/edit?usp=sharing)

## Sommaire

- [Résultats clés](#résultats-clés)
- [Contexte](#contexte)
- [Méthodologie](#méthodologie)
- [Stack technique](#stack-technique)
- [Structure du repo](#structure-du-repo)
- [Lancer le projet](#lancer-le-projet)
- [Limites et pistes futures](#limites-et-pistes-futures)
- [Auteur](#auteur)

## Résultats clés

- **Les USA génèrent le plus de chiffre d'affaire**, loin devant les autres marchés.
- **Le Rock domine les ventes** tous pays confondus
- **Le format audio (MPEG)** surclasse le format vidéo MPEG4 (1956$ vs. 221$).
- **Le prix unitaire des titres n'influence pas les ventes**
- **Certains marchés sont sous exploités**, l'Asie et l'Amérique Latine possèdent peu de pays générant des ventes sur la plateforme.
- [Le Dashboard Complet](https://docs.google.com/spreadsheets/d/1kT_GaW7bJ1dAgemWcfduzlwn4FZbAWzGctIse715TiU/edit?usp=sharing)

## Contexte

Chinook est une boutique en ligne fictive vendant des morceaux et des albums de musique basée aux État-Unis, mais réalisant ses ventes sur plusieurs zones géographiques.

Cette entreprise m’a contacté afin de réaliser une analyse complète de sa plateforme sous deux angles majeurs : les ventes et le produit. Leur objectif est de récupérer un ensemble de données concrètes leur permettant de lancer leur future  grande phase de développement.

Dans ce contexte, les dirigeants ont formulé un ensemble de questions, auquel je vais devoir répondre : 

**Pôle ventes et clients :**

- Comment le revenu par mois à-t-il évolué ?

- Quel est le panier moyen par client ? 

- Quels sont les 5 clients ayant le plus d’achats sur la plateforme ? 

- Comment se répartissent les ventes par pays ? Existe-il des marchés sous-exploités ?

- Quels sont les 5 pays ayant le plus de ventes sur la plateforme ?

**Pôle produits :** 

- Quelles sont les 5 artistes ayant le plus de vente sur la plateforme ? Lesquels ne possèdent aucunes ventes ?

- Quel type de média reçoit le plus de ventes ?

- Quel genre musical est le plus populaire sur la plateforme ?

- Quel est le genre musical le plus populaire en fonction du pays ?


La réponse à ces questions va permettre l’orientation de la future phase de développement autour des points clés de la société, mais également, permettre d’éviter les choix à l’aveugle et la mise en place de stratégies inefficaces comparée aux données en présence.  

## Méthodologie

1. **Récupération des données** dans une base SQL (SQLite), et compréhension des tables en présence.

2. **Nettoyage** : Vérification des valeurs NULL, des doublons 

3. **Analyse via requêtes SQL** afin de récupérer les données essentielles pour répondre aux différentes questions, avec export en .csv afin de pouvoir réutiliser les données dans d’autres contextes. 

4. **Visualisation graphique** sous Python (matplotlib.pyplot) afin de comprendre les variations de chiffre d'affaires, mais également pour traiter plus rapidement une visualisation par année avec Pandas. 

5. **Importation des fichiers csv** sur Google Sheet pour la construction d’un dashboard dynamique basé sur des listes interchangeables en fonction de la valeur d’intérêt. 

## Stack Technique

- SQL (SQLite)
- Python 3
- pandas
- matplotlib, seaborn
- Google Sheet

## Structure du Repo
````
├── data/
│   └── Chinook_Sqlite.sqlite      # Base de données Chinook (auteur : lerocha)
├── output_sql/                    # Ensemble des .csv exportés depuis SQL pour Python/GSheet
│   └── *.csv
├── query_chinook.sql              # Ensemble des requêtes SQL
├── analyse_python.ipynb           # Notebook d'analyse des éléments de chiffre d'affaire
├── Dashboard_JPG                  # Dashboard résumant les résultats clés (version statique)
│   └── Dashbord_Pôle_Vente.jpg
│   └── Dashbord_Pôle_Produit.jpg
├── requirements.txt               # Ensemble des packages et librairies utiles pour lire l'analyse
└── README.md
````

## Lancer le projet

### Prérequis
- Python 3.9 ou supérieur
- pip

### Installation

1. **Cloner le repo**
```bash
   git clone https://github.com/Alex-LC0/nom-du-repo.git
   cd Analyse-Chinook-Database
```

2. **Installer les dépendances**
```bash
   pip install -r requirements.txt
```

3. **Base de données**
   Le fichier `Chinook_Sqlite.sqlite` est inclus dans ce repo (dossier `/data`), prêt à l'emploi.

4. **Explorer les requêtes SQL**
   Les requêtes utilisées pour l'analyse sont disponibles dans `query_chinook.sql`. Tu peux les exécuter avec l'extension VS Code [SQLite](https://marketplace.visualstudio.com/items?itemName=alexcvzz.vscode-sqlite), ou via n'importe quel client SQLite de ton choix.

5. **Lancer l'analyse Python**
```bash
   jupyter notebook analyse_python.ipynb
```
   Le notebook lit les fichiers `.csv` exportés dans `/Output_Sql` (résultats des requêtes SQL) et génère les visualisations.

6. **Consulter le dashboard interactif**
   Le dashboard final est disponible ici : [lien vers ton Google Sheet]
   Une version statique (`dashboard.jpg`) est également incluse dans ce repo pour un aperçu rapide sans avoir à ouvrir Google Sheets.


## Limites et pistes futures

- L’analyse ne réalise pas de statistiques complexe sur les ventes, notamment des corrélation réelle entre le genre et les achats, cela pourrait être une piste future afin de confirmer les données actuelles

- La plage de données est assez faible, seule 4 années de données sont présente dans la base, ne permettant pas de réellement voir des tendance, notamment pour les ventes mensuelles.

- Présence de pays avec un faible echantillon. Certaines zone géographique enregistre peu de vente, ce qui rend la comparaison et les données plus complexe à validé d’un point de vu statistique. 

- Le faible effectif de salarié, ne permettant pas de proposer une analyse RH étant donné que les 3 salariés reliés aux clients travaillent avec les “bons” et le “mauvais” clients. 

## Auteur

- Alexis LE CALVEZ (Data Analyse)
- [lerocha](https://github.com/lerocha/chinook-database?tab=License-1-ov-file) (Base de donnée Chinook)
