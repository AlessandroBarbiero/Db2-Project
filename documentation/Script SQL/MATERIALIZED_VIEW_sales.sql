# creazione tabella 
CREATE TABLE `sales_per_package` (
                                        `servicePackageId` int NOT NULL,
                                        `revenueWithOpProd` int NOT NULL,
                                        `revenueWithoutOpProd` int NOT NULL
);

# inizializzazione 
CREATE TRIGGER sales_per_package_init
AFTER INSERT ON service_package
FOR EACH ROW
		INSERT INTO sales_per_package
			values(new.id, 0, 0);
            
# inserimenti
CREATE TRIGGER all_insert
AFTER INSERT ON `order`
FOR EACH ROW
    IF new.valid THEN
	UPDATE sales_per_package
		SET revenueWithoutOpProd = revenueWithoutOpProd + (SELECT monthlyFee * numberOfMonths
															FROM `order` o JOIN validity_period v ON o.validityPeriodId = v.id
                                                            WHERE o.id = new.id),
			revenueWithOpProd = revenueWithOpProd + (SELECT monthlyFee * numberOfMonths
															FROM `order` o JOIN validity_period v ON o.validityPeriodId = v.id
                                                            WHERE o.id = new.id)
        WHERE servicePackageId = new.servicePackageId;
	END IF;
        
CREATE TRIGGER update_revenue_after_opt_prod_choice_insert
AFTER INSERT ON optional_product_choice
FOR EACH ROW
    IF (SELECT o.valid FROM `order` o WHERE o.id = new.orderId) THEN
	UPDATE sales_per_package
		SET revenueWithOpProd = revenueWithOpProd + (SELECT op.monthlyFee * numberOfMonths
															FROM `order` o JOIN validity_period v ON o.validityPeriodId = v.id
																JOIN optional_product_choice opc ON o.id = opc.orderId JOIN optional_product op ON opc.optionalProductId = op.id
                                                            WHERE o.id = new.orderId AND op.id = new.optionalProductId)
        WHERE servicePackageId = (SELECT o.servicePackageId FROM `order` o WHERE o.id = new.orderId);
	END IF;

# aggiornamenti
CREATE TRIGGER revenue_update
AFTER UPDATE ON `order`
FOR EACH ROW
    IF old.valid = false AND new.valid = true THEN
        UPDATE sales_per_package
        SET revenueWithoutOpProd = revenueWithoutOpProd + (SELECT monthlyFee * numberOfMonths
                                                           FROM `order` o JOIN validity_period v ON o.validityPeriodId = v.id
                                                           WHERE o.id = new.id),
            revenueWithOpProd = revenueWithOpProd +
                                (SELECT monthlyFee * numberOfMonths
                                 FROM `order` o JOIN validity_period v ON o.validityPeriodId = v.id
                                 WHERE o.id = new.id) +
                                (SELECT COALESCE(SUM(op.monthlyFee * numberOfMonths), 0)
                                 FROM `order` o JOIN validity_period v ON o.validityPeriodId = v.id
                                                JOIN optional_product_choice opc ON o.id = opc.orderId JOIN optional_product op ON opc.optionalProductId = op.id
                                 WHERE o.id = new.id)
        WHERE servicePackageId = new.servicePackageId;
    END IF;

# coalesce: funzione che ritorna il primo valore non nullo tra i parametri passati
        
        
        
        