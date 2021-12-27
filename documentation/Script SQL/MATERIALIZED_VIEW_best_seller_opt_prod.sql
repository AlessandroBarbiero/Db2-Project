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

# cancellazioni
CREATE TRIGGER revenue_opt_prod_delete
    AFTER DELETE ON optional_product_choice
    FOR EACH ROW
    UPDATE best_seller_opt_prod
    SET revenue = revenue - (SELECT op.monthlyFee * numberOfMonths
                             FROM `order` o JOIN validity_period v ON  o.validityPeriodId = v.id
                                            JOIN optional_product_choice opc ON o.id = opc.orderId
                                            JOIN optional_product op ON opc.optionalProductId = op.id
                             WHERE o.id = old.orderId AND op.id = old.optionalProductId)
    WHERE optionalProductId = old.optionalProductId;
        
# query finale
# SELECT optionalProductId, revenue
# FROM best_seller_opt_prod
# ORDER BY revenue desc
# LIMIT 1