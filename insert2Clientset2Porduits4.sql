-- 4. Insérer deux clients dans la table client et deux produits dans la table produit
-- Sélection de la base de données
USE magasin;
GO

-- Insérer deux clients dans la table Client
INSERT INTO Client (Nom, Prenom, Email)
VALUES ('Ait Ali', 'Laila', '2691473@collegelacite.ca'),
       ('Bessier', 'Loovens', '2703243@collegelacite.ca');
GO

-- Insérer deux produits dans la table Produit
INSERT INTO Produit (Nom, Prix)
VALUES ('Ordinateur portable 15"', 749.99),
       ('Carte graphique GTX 1050 Ti', 249.99);
GO

-- Vérifier l'insertion dans la table Client et client_log
SELECT c.Id_client, c.Nom, c.Prenom, c.Email, cl.Date_insertion, cl.Description
FROM Client c
JOIN client_log cl ON c.Id_client = cl.Id_client;
GO

-- Vérifier l'insertion dans la table Produit
SELECT * FROM Produit;
GO

-- Vérifier l'insertion dans la table produit_log
SELECT * FROM produit_log;
GO
