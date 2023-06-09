-- Laboratoire 12 & 13: 10% de la note globale
-- 1.	À l’aide d’une procédure stockée et en utilisant des variables
-- a.	Créer une base de données (magasin)
-- b.	Créer les 4 tables suivantes:
-- Client	    Produit	   client_log	     produit_log
-- Id_client    Id_produit  Id_client	     Id_produit
-- Nom          Nom	        Date_insertion	 Date_insertion                               
-- Prénom       Prix	    Description	     Description
-- Email	
-- Sélection de la base de données
USE magasin;
GO
-- Création de la procédure stockée
CREATE OR ALTER PROCEDURE CreateMagasinDatabaseAndTables
    @Date_insertion VARCHAR(50),
    @Description VARCHAR(50),
    @Prix VARCHAR(50),
    @Nom VARCHAR(50),
    @Prenom VARCHAR(50),
    @Email VARCHAR(50)
AS
BEGIN
    DECLARE @DatabaseName NVARCHAR(50) = 'magasin',
            @ClientTableName NVARCHAR(50) = 'Client',
            @ProduitTableName NVARCHAR(50) = 'Produit',
            @ClientLogTableName NVARCHAR(50) = 'client_log',
            @ProduitLogTableName NVARCHAR(50) = 'produit_log',
            @ClientTableSQL NVARCHAR(MAX),
            @ProduitTableSQL NVARCHAR(MAX),
            @ClientLogTableSQL NVARCHAR(MAX),
            @ProduitLogTableSQL NVARCHAR(MAX),
			@sql NVARCHAR(MAX);

SET @sql = 'IF DB_ID(''' + @DatabaseName + ''') IS NULL
BEGIN
    CREATE DATABASE ' + QUOTENAME(@DatabaseName) + ';
END';

EXEC sp_executesql @sql;

  IF OBJECT_ID(@ClientTableName, 'U') IS NULL
    BEGIN
        SET @ClientTableSQL = '
        CREATE TABLE ' + @ClientTableName + ' (
            Id_client INT IDENTITY(1,1) PRIMARY KEY,
            ' + QUOTENAME(@Nom) + ' VARCHAR(50) NOT NULL,
            ' + QUOTENAME(@Prenom) + ' VARCHAR(50) NOT NULL,
            ' + QUOTENAME(@Email) + ' VARCHAR(320) UNIQUE NOT NULL,
            CONSTRAINT UC_Client UNIQUE (Id_client),
            CONSTRAINT UC_Email UNIQUE (' + QUOTENAME(@Email) + ')
        );';
        SET @ClientTableSQL = N'USE ' + QUOTENAME(@DatabaseName) + N'; ' + @ClientTableSQL;
        EXEC sp_executesql @ClientTableSQL;
    END

    IF OBJECT_ID(@ProduitTableName, 'U') IS NULL
    BEGIN
        SET @ProduitTableSQL = '
        CREATE TABLE ' + @ProduitTableName + ' (
            Id_produit INT IDENTITY(1,1) PRIMARY KEY,
            ' + QUOTENAME(@Nom) + ' VARCHAR(50) NOT NULL,
            ' + QUOTENAME(@Prix) + ' DECIMAL(10,2) NOT NULL CHECK (' + QUOTENAME(@Prix) + ' > 0),
            CONSTRAINT UC_Produit UNIQUE (Id_produit)
        );';
        SET @ProduitTableSQL = N'USE ' + QUOTENAME(@DatabaseName) + N'; ' + @ProduitTableSQL;
        EXEC sp_executesql @ProduitTableSQL;
    END

   IF OBJECT_ID(@ClientLogTableName, 'U') IS NULL
BEGIN
    SET @ClientLogTableSQL = '
    CREATE TABLE '+@ClientLogTableName+' (
        Id_client INT NOT NULL,
        '+QUOTENAME(@Date_insertion)+' DATETIME NOT NULL,
        '+QUOTENAME(@Description)+' VARCHAR(50) NOT NULL
    );';
	SET @ClientLogTableSQL = N'USE ' + QUOTENAME(@DatabaseName) + N'; ' + @ClientLogTableSQL;
    EXEC sp_executesql @ClientLogTableSQL;
END

IF OBJECT_ID(@ProduitLogTableName, 'U') IS NULL
    BEGIN
        SET @ProduitLogTableSQL = '
        CREATE TABLE '+@ProduitLogTableName+' (
            Id_produit INT NOT NULL,
            '+QUOTENAME(@Date_insertion)+' DATETIME NOT NULL,
            '+QUOTENAME(@Description)+' VARCHAR(50) NOT NULL
        );';
		SET @ProduitLogTableSQL = N'USE ' + QUOTENAME(@DatabaseName) + N'; ' + @ProduitLogTableSQL;
        EXEC sp_executesql @ProduitLogTableSQL;
    END
END;
GO

-- c.	Exécuter la procédure stockée
EXEC CreateMagasinDatabaseAndTables 'Date_insertion', 'Description', 'Prix', 'Nom', 'Prenom', 'Email';
GO

-- 2.	Créer un trigger sur la table client après insertion en insérant le id, 
-- la date d’insertion et le mot ‘inséré’ dans les colonnes de la table client_log.
-- Sélection de la base de données
USE magasin;
GO

-- Création du trigger sur la table Client
IF OBJECT_ID('trg_Client_AfterInsert', 'TR') IS NOT NULL
DROP TRIGGER trg_Client_AfterInsert;
GO

CREATE TRIGGER trg_Client_AfterInsert
ON Client
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO client_log (Id_client, Date_insertion, Description)
    SELECT i.Id_client, GETDATE(), 'inséré'
    FROM inserted i;
END;
GO

-- Insérer un nouveau client
INSERT INTO Client (Nom, Prenom, Email)
VALUES ('Benslimane', 'Abderraouf', '2706014@collegelacite.ca')
GO

-- Vérifier l'insertion dans la table Client et client_log
SELECT c.Id_client, c.Nom, c.Prenom, c.Email, cl.Date_insertion, cl.Description
FROM Client c
JOIN client_log cl ON c.Id_client = cl.Id_client;
GO

-- 3.	Créer un trigger sur la table produit après suppression en insérant le id_produit, 
-- la date de suppression et le mot 'supprimé’ dans les colonnes de la table produit_log.
-- Sélection de la base de données
USE magasin;
GO

-- Vérifier si le trigger existe, et le supprimer s'il existe
IF OBJECT_ID('trg_AfterDelete_Produit', 'TR') IS NOT NULL
DROP TRIGGER trg_AfterDelete_Produit;
GO

-- Création du trigger après suppression sur la table Produit
CREATE TRIGGER trg_AfterDelete_Produit
ON Produit
AFTER DELETE
AS
BEGIN
    DECLARE @id_produit INT;
    DECLARE @date_suppression DATETIME;
    DECLARE @description VARCHAR(50);

    SELECT @id_produit = Id_produit FROM deleted;
    SET @date_suppression = GETDATE();
    SET @description = 'supprimé';

    INSERT INTO produit_log (Id_produit, Date_insertion, Description)
    VALUES (@id_produit, @date_suppression, @description);
END;
GO

-- Test du trigger
-- Insérer un produit pour le tester
INSERT INTO Produit (Nom, Prix)
VALUES ('Écouteurs Bluetooth', 49.99);
GO

-- Supprimer le produit pour déclencher le trigger
DELETE FROM Produit
WHERE Id_produit = 1;
GO

-- Vérifier que le trigger a bien inséré une entrée dans produit_log
SELECT * FROM produit_log;
GO

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


-- 5. Supprimer un produit
-- Sélection de la base de données
USE magasin;
GO

-- Supprimer le produit avec Id_produit 2
DELETE FROM Produit
WHERE Id_produit = 2;
GO

-- Vérifier l'insertion dans la table Produit
SELECT * FROM Produit;
GO

-- Vérifier l'insertion dans la table produit_log
SELECT * FROM produit_log;
GO

-- 6. Afficher les éléments des tables client_log et produit_log
-- Sélection de la base de données
USE magasin;
GO

-- Afficher les éléments de la table client_log
SELECT * FROM client_log;
GO

-- Afficher les éléments de la table produit_log
SELECT * FROM produit_log;
GO

