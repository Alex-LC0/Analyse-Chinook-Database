-- SQLite

# Comment les ventes annuelles ont évolués ? 

SELECT 
    STRFTIME('%Y', Invoice.InvoiceDate) as Date,
    SUM(Invoice.Total) as Revenus
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY STRFTIME('%Y', Invoice.InvoiceDate);

#Comment les ventes mensuelles ont évolués ?

SELECT 
    STRFTIME('%m-%Y', Invoice.InvoiceDate) as Date,
    SUM(Invoice.Total) as Revenus
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY STRFTIME('%m-%Y', Invoice.InvoiceDate)
ORDER BY Invoice.InvoiceDate;


#Quel est le panier moyen par client ?

SELECT 
    Customer.FirstName || ' ' || Customer.LastName as Client,
    AVG(Invoice.Total) as Panier_Moyen
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Customer.CustomerId
ORDER BY Panier_Moyen DESC;


# Quels sont les 5 clients ayant le plus d’achats sur la plateforme ? 

SELECT 
    Customer.FirstName || ' ' || Customer.LastName as Client, 
    SUM(Invoice.Total) as Revenus
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Customer.CustomerId
ORDER BY Revenus ASC
LIMIT 5;

# Combien de commandes ont ils réalisé sur la plateforme ?

SELECT 
    Customer.FirstName || ' ' || Customer.LastName as Client,
    COUNT(Invoice.InvoiceDate) as Achats
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
WHERE Customer.CustomerId IN (
    SELECT 
    Customer.CustomerId 
    FROM Invoice
    JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
    GROUP BY Customer.CustomerId
    ORDER BY SUM(Invoice.Total) DESC
    LIMIT 5
)
GROUP BY Customer.CustomerId
ORDER BY SUM(Invoice.Total);

# Depuis quelle année commande ils sur la plateforme ?

SELECT 
    Customer.FirstName || ' ' || Customer.LastName as Client,
    MIN(Invoice.InvoiceDate) as Date
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
WHERE Customer.CustomerId IN (
    SELECT 
    Customer.CustomerId 
    FROM Invoice
    JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
    GROUP BY Customer.CustomerId
    ORDER BY SUM(Invoice.Total) DESC
    LIMIT 5
)
GROUP BY Customer.CustomerId
ORDER BY SUM(Invoice.Total);

# Quels répartitions de ventes par pays ?

SELECT Customer.Country, SUM(Invoice.Total) as Total_Pays
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Customer.Country
ORDER BY Total_Pays DESC;

# Quels 5 pays ayant le plus de ventes sur la plateforme ?

SELECT Customer.Country, SUM(Invoice.Total) as Total_Pays
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Customer.Country
ORDER BY Total_Pays DESC
LIMIT 5;


#Quel est le panier moyen par pays ?

SELECT 
    Customer.Country,
    AVG(Invoice.Total) as Panier_Moyen,
    COUNT(DISTINCT Customer.CustomerId) as nb_clients
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Customer.Country
ORDER BY nb_clients DESC;


# Checking des null dans Artistes 

SELECT * 
FROM Artist
WHERE Artist.Name IS NULL;

# Checking des doublons dans Artistes

SELECT Artist.Name, COUNT(*)
FROM Artist
GROUP BY Artist.Name
HAVING COUNT(*) >1;


#Quels sont les 5 artistes ayant le plus de vente sur la plateforme ?

SELECT Artist.Name as Artist, SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) as chiffre_affaire
FROM Artist
JOIN Album ON Album.ArtistId = Artist.ArtistId
JOIN Track ON Track.AlbumId = Album.AlbumId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Artist.Name
ORDER BY chiffre_affaire ASC
LIMIT 6
;

#Quels sont les artistes ayant réalisé aucunes ventes ?

SELECT Artist.Name as Artist
FROM Artist
LEFT JOIN Album ON Album.ArtistId = Artist.ArtistId
LEFT JOIN Track ON Track.AlbumId = Album.AlbumId
LEFT JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Artist.ArtistId, Artist.Name
HAVING COUNT(InvoiceLine.InvoiceLineId) = 0;

# Quel type de média reçoit le plus de ventes ?

SELECT MediaType.Name, SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) as chiffre_affaire
FROM MediaType
JOIN Track ON MediaType.MediaTypeId = Track.MediaTypeId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY MediaType.Name
ORDER BY chiffre_affaire DESC;

# Quelle est la dernière date d'achat de ces média : 

SELECT MediaType.Name, Invoice.InvoiceDate
FROM Invoice
JOIN Track ON MediaType.MediaTypeId = Track.MediaTypeId
JOIN MediaType ON MediaType.MediaTypeId = Track.MediaTypeId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
WHERE MediaType.MediaTypeId IN (
   SELECT MediaType.MediaTypeId
    FROM MediaType
    JOIN Track ON MediaType.MediaTypeId = Track.MediaTypeId
    JOIN Album ON Track.AlbumId = Album.AlbumId
    JOIN Artist ON Album.ArtistId = Artist.ArtistId
    JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
    GROUP BY MediaType.Name
    ORDER BY SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) DESC 
)
GROUP BY MediaType.Name
ORDER BY MIN(Invoice.InvoiceDate) DESC;


# Quel genre musical génére le plus de vente ?

SELECT Genre.Name, SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) as chiffre_affaire
FROM Genre
JOIN Track ON Genre.GenreId = Track.GenreId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Genre.Name
ORDER BY chiffre_affaire DESC;

# Quel est le genre musical favori par pays ?

WITH ventes_par_pays AS (
    SELECT 
        Customer.Country, 
        Genre.Name as Genre,
        SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) as Revenus,
        COUNT(DISTINCT Invoice.InvoiceId) as nb_clients,
        RANK() OVER (
            PARTITION BY Customer.Country
            ORDER BY SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) DESC
        ) AS Rang
    FROM Customer
    JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
    JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    JOIN Track ON InvoiceLine.TrackId = Track.TrackId
    JOIN Genre ON Track.GenreId = Genre.GenreId
    GROUP BY Customer.Country, Genre.Name
)
SELECT Country, Genre, Revenus, nb_clients
FROM ventes_par_pays
WHERE Rang = 1
ORDER BY Revenus DESC;

#Nombre total d'achat par pays

SELECT 
    Customer.Country,
    COUNT(DISTINCT Invoice.InvoiceId) AS nb_achats
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY Customer.Country
ORDER BY SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) DESC;

# Quel est le prix unitaire des musiques ayant le plus de revenus sur la plateforme ?

SELECT Track.Name, Track.UnitPrice, SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) as Revenus
FROM Track
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.Name
ORDER BY Revenus DESC;

# Quel est le prix unitaire des musiques les plus achetés sur la plateforme ?

SELECT Track.Name, Track.UnitPrice, SUM(InvoiceLine.Quantity) as nb_ventes
FROM Track
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.Name
ORDER BY nb_ventes DESC;

#Quel est l'employé qui gére les 5 meilleurs clients : 

SELECT 
    Employee.FirstName || ' ' || Employee.LastName as Employé, 
    Customer.FirstName || ' ' || Customer.LastName as Client, 
    SUM(Invoice.Total) as CA
FROM Employee
JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Client
ORDER BY CA DESC
LIMIT 5;

#Quel est le Chiffre d'Affaire par employé ?

SELECT 
    Employee.FirstName || ' ' || Employee.LastName as Employé,
    SUM(Invoice.Total) as CA
FROM Employee
JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Employé
ORDER BY CA DESC;

#Quel est l'employé qui gère les clients les moins rentables ?

SELECT 
    Employee.FirstName || ' ' || Employee.LastName as Employé,
    Customer.FirstName || ' ' || Customer.LastName as Client,
    SUM(Invoice.Total) as CA
FROM Employee
JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Client
ORDER BY CA ASC
LIMIT 5;