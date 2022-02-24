CREATE VIEW `best_seller_opt_prod` as
SELECT optionalProductId, COALESCE(SUM(op.monthlyFee * vp.numberOfMonths),0) as revenue
FROM optional_product op JOIN optional_product_choice opc on op.id = opc.optionalProductId
                        JOIN `order` o on opc.orderId = o.id
                        JOIN validity_period vp on vp.id = o.validityPeriodId
WHERE o.valid
GROUP BY optionalProductId
ORDER BY revenue desc
LIMIT 1;

# creazione tabella
CREATE TABLE `best_seller_opt_prod` (
                                        `optionalProductId` int NOT NULL,
                                        `revenue` int NOT NULL
);

# inizializzazione
CREATE TRIGGER best_seller_opt_prod_init
AFTER INSERT ON optional_product
FOR EACH ROW
		INSERT INTO best_seller_opt_prod
			values(new.id, 0);
            
            
# inserimenti
CREATE TRIGGER revenue_opt_prod_insert
AFTER INSERT ON optional_product_choice
FOR EACH ROW
    IF (SELECT o.valid FROM `order` o WHERE o.id = new.orderId) THEN
	UPDATE best_seller_opt_prod
		SET revenue = revenue + (SELECT op.monthlyFee * numberOfMonths
								FROM `order` o JOIN validity_period v ON  o.validityPeriodId = v.id
									JOIN optional_product_choice opc ON o.id = opc.orderId
									JOIN optional_product op ON opc.optionalProductId = op.id
                                WHERE o.id = new.orderId AND op.id = new.optionalProductId)
        WHERE optionalProductId = new.optionalProductId;
	END IF;

# aggiornamenti
CREATE TRIGGER revenue_opt_prod_update
    AFTER UPDATE ON `order`
    FOR EACH ROW
    IF old.valid = false AND new.valid = true THEN
        UPDATE best_seller_opt_prod bsop
        SET revenue = revenue +
                      (SELECT op.monthlyFee * numberOfMonths
                      FROM `order` o JOIN validity_period v ON  o.validityPeriodId = v.id
                            JOIN optional_product_choice opc ON o.id = opc.orderId
                            JOIN optional_product op ON opc.optionalProductId = op.id
                      WHERE o.id = new.id AND op.id = bsop.optionalProductId)
        WHERE optionalProductId IN (SELECT op2.optionalProductId
                                FROM optional_product_choice op2
                                WHERE op2.orderId = new.id);
    END IF;
        

