-- Laboratoire 12 & 13: 10% de la note globale
-- 1.	À l’aide d’une procédure stockée et en utilisant des variables
-- a.	Créer une base de données (magasin)
-- b.	Créer les 4 tables suivantes:
-- Client	    Produit	   client_log	     produit_log
-- Id_client    Id_produit  Id_client	     Id_produit
-- Nom          Nom	        Date_insertion	 Date_insertion                               
-- Prénom       Prix	    Description	     Description
-- Email	

-- Création de la procédure stockée
CREATE PROCEDURE CreateMagasinDatabaseAndTables
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'magasin') 
    BEGIN
        CREATE DATABASE magasin;
    END

    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Client' AND type = 'U')
    BEGIN
        CREATE TABLE Client (
            Id_client INT IDENTITY(1,1) PRIMARY KEY,
            Nom VARCHAR(50) NOT NULL,
            Prenom VARCHAR(50) NOT NULL,
            Email VARCHAR(320) UNIQUE NOT NULL,
            CONSTRAINT UC_Client UNIQUE (Id_client)
        );
    END

    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Produit' AND type = 'U')
    BEGIN
        CREATE TABLE Produit (
            Id_produit INT IDENTITY(1,1) PRIMARY KEY,
            Nom VARCHAR(50) NOT NULL,
            Prix DECIMAL(10,2) NOT NULL CHECK (Prix > 0),
            CONSTRAINT UC_Produit UNIQUE (Id_produit)
        );
    END

    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'client_log' AND type = 'U')
    BEGIN
        CREATE TABLE client_log (
            Id_client INT FOREIGN KEY REFERENCES Client(Id_client) ON DELETE CASCADE,
            Date_insertion DATETIME NOT NULL,
            Description VARCHAR(50) NOT NULL,
            CONSTRAINT UC_client_log UNIQUE (Id_client)
        );
    END

    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'produit_log' AND type = 'U')
    BEGIN
        CREATE TABLE produit_log (
            Id_produit INT,
            Date_insertion DATETIME NOT NULL,
            Description VARCHAR(50) NOT NULL,
            CONSTRAINT UC_produit_log UNIQUE (Id_produit)
        );
    END
END;
GO

-- c.	Exécuter la procédure stockée
EXEC CreateMagasinDatabaseAndTables;
GO