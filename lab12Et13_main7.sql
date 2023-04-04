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
            @ProduitLogTableSQL NVARCHAR(MAX);

     IF DB_ID(@DatabaseName) IS NULL
    BEGIN
        CREATE DATABASE magasin;
    END

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