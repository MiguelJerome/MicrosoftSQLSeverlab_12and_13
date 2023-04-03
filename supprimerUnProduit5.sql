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