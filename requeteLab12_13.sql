-- création de la procédure stockée
CREATE PROCEDURE Insertion_client_produit (
    @Nom_client VARCHAR(50),
    @Prenom_client VARCHAR(50),
    @Email_client VARCHAR(50),
    @Nom_produit VARCHAR(50),
    @Prix_produit DECIMAL(10,2)
)
AS
BEGIN
    -- insertion du client
    DECLARE @Id_client INT
    INSERT INTO Client (Nom, Prénom, Email)
    VALUES (@Nom_client, @Prenom_client, @Email_client)
    SET @Id_client = SCOPE_IDENTITY()
    
    -- insertion du produit
    DECLARE @Id_produit INT
    INSERT INTO Produit (Nom, Prix)
    VALUES (@Nom_produit, @Prix_produit)
    SET @Id_produit = SCOPE_IDENTITY()
    
    -- insertion dans les logs
    INSERT INTO client_log (Id_client, Date_insertion, Description)
    VALUES (@Id_client, GETDATE(), 'inséré')
    
    INSERT INTO produit_log (Id_produit, Date_insertion, Description)
    VALUES (@Id_produit, GETDATE(), 'inséré')
END
GO

-- création du trigger après insertion sur la table Client
CREATE TRIGGER Insertion_client_log
ON Client
AFTER INSERT
AS
BEGIN
    INSERT INTO client_log (Id_client, Date_insertion, Description)
    SELECT Id_client, GETDATE(), 'inséré'
    FROM inserted
END
GO

-- création du trigger après suppression sur la table Produit
CREATE TRIGGER Suppression_produit_log
ON Produit
AFTER DELETE
AS
BEGIN
    INSERT INTO produit_log (Id_produit, Date_insertion, Description)
    SELECT Id_produit, GETDATE(), 'supprimé'
    FROM deleted
END
GO