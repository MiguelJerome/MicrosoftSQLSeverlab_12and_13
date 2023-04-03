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