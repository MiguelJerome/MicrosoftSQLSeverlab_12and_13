IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'magasin') 
-- Création de la base de données
BEGIN
    CREATE DATABASE magasin;
END
GO

-- Sélection de la base de données
USE magasin;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Client' AND type = 'U')
BEGIN
    -- Création de la table Client
    CREATE TABLE Client (
        Id_client INT IDENTITY(1,1) PRIMARY KEY,  -- Clé primaire avec IDENTITY pour la table Client
        Nom VARCHAR(50) NOT NULL,   -- Nom du client (ne peut pas être NULL)
        Prenom VARCHAR(50) NOT NULL, -- Prénom du client (ne peut pas être NULL)
        Email VARCHAR(320) UNIQUE NOT NULL   -- Email du client (doit être unique et non vide)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Produit' AND type = 'U')
BEGIN
    -- Création de la table Produit
    CREATE TABLE Produit (
        Id_produit INT IDENTITY(1,1) PRIMARY KEY, -- Clé primaire avec IDENTITY pour la table Produit
        Nom VARCHAR(50) NOT NULL,   -- Nom du produit (ne peut pas être NULL)
        Prix DECIMAL(10,2) NOT NULL CHECK (Prix > 0) -- Prix du produit (ne peut pas être NULL, doit être supérieur à 0)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'client_log' AND type = 'U')
BEGIN
    -- Création de la table client_log
    CREATE TABLE client_log (
        Id_client INT FOREIGN KEY REFERENCES Client(Id_client) ON DELETE CASCADE, -- Clé étrangère vers la table Client (supprime les logs associés si le client est supprimé)
        Date_insertion DATETIME NOT NULL, -- Date d'insertion du log (ne peut pas être NULL)
        Description VARCHAR(50) NOT NULL  -- Description du log (ne peut pas être NULL)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'produit_log' AND type = 'U')
BEGIN
    -- Création de la table produit_log
    CREATE TABLE produit_log (
        Id_produit INT FOREIGN KEY REFERENCES Produit(Id_produit) ON DELETE CASCADE, -- Clé étrangère vers la table Produit (supprime les logs associés si le produit est supprimé)
        Date_insertion DATETIME NOT NULL, -- Date d'insertion du log (ne peut pas être NULL)
        Description VARCHAR(50) NOT NULL  -- Description du log (ne peut pas être NULL)
    );
END
GO
