-- 3.	Créer un trigger sur la table produit après suppression en insérant le id_produit, 
-- la date de suppression et le mot 'supprimé’ dans les colonnes de la table produit_log.
-- Sélection de la base de données
USE magasin;
GO
-- Insérer un nouveau produit
INSERT INTO Produit (Nom, Prix)
VALUES ('Ordinateur portable 14"', 599.99);
GO
-- Création du trigger sur la table Produit
IF OBJECT_ID('trg_Produit_AfterDelete', 'TR') IS NOT NULL
DROP TRIGGER trg_Produit_AfterDelete;
GO

CREATE TRIGGER trg_Produit_AfterDelete
ON Produit
AFTER DELETE
AS
BEGIN
    INSERT INTO produit_log (Id_produit, Date_insertion, Description)
    SELECT d.Id_produit, GETDATE(), 'supprimé'
    FROM deleted d;
END;
GO

-- Supprimer un produit
DELETE FROM Produit
WHERE Id_produit = 1;
GO

-- Vérifier l'insertion dans la table Produit et produit_log
SELECT p.Id_produit, p.Nom, p.Prix, pl.Date_insertion, pl.Description
FROM Produit p
JOIN produit_log pl ON p.Id_produit = pl.Id_produit;
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