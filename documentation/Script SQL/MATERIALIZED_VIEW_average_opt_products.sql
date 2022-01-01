# creazione tabella della media di opt products per package
CREATE TABLE `average_number_opt_products_per_package` (
                                        `servicePackageId` int NOT NULL,
                                        `optProductsSold` int NOT NULL,
                                        `totOrders` int NOT NULL,
                                        `avg` float NOT NULL
);

# inizializzazione delle avg per ogni service package
CREATE TRIGGER avg_opt_prod_init
AFTER INSERT ON service_package
FOR EACH ROW
		INSERT INTO average_number_opt_products_per_package
			values(new.id, 0, 0, 0);

# inserimento di un opt product
CREATE TRIGGER opt_prod_insert
AFTER INSERT ON optional_product_choice
FOR EACH ROW
    IF (SELECT o.valid FROM `order` o WHERE o.id = new.orderId) THEN
	UPDATE average_number_opt_products_per_package
		SET optProductsSold = optProductsSold + 1,
			`avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = (SELECT servicePackageId FROM `order` O WHERE O.id = new.orderId);
	END IF;

# inserimento di un ordine
CREATE TRIGGER avg_opt_prod_insert
AFTER INSERT ON `order`
FOR EACH ROW
    IF new.valid THEN
	UPDATE average_number_opt_products_per_package 
		SET totOrders = totOrders + 1,
			`avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = new.servicePackageId;
	END IF;

# aggiornamento
CREATE TRIGGER opt_prod_update
AFTER UPDATE ON `order`
FOR EACH ROW
    IF old.valid = false AND new.valid = true THEN
        UPDATE average_number_opt_products_per_package
        SET totOrders = totOrders + 1,
            optProductsSold = optProductsSold + (SELECT COUNT(opc.optionalProductId) FROM optional_product_choice opc WHERE opc.orderId = new.id),
            `avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = new.servicePackageId;
    END IF;
