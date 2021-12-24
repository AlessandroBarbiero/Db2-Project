DELIMITER $$

CREATE TRIGGER blacklist_population
AFTER INSERT ON `order`
FOR EACH ROW
BEGIN
	IF new.valid = false AND 
		(SELECT count(*) 
		FROM `order` o
		WHERE o.valid = false AND 
			new.userId = o.userId) >= 3
	THEN
		IF exists
			(SELECT *
            FROM blacklist
            WHERE new.userId = blacklist.userId)
		THEN
			UPDATE blacklist
            SET blacklist.lastRejection = new.creation, blacklist.amount = new.totalPrice
            WHERE blacklist.userId = new.userId;
		ELSE
			INSERT INTO blacklist
				(SELECT u.id, u.username, u.email, new.creation, new.totalPrice
				FROM user u
				WHERE new.userId = u.id);
		END IF;
	END IF;
END $$

DELIMITER ;
