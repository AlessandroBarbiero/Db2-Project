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
	UPDATE average_number_opt_products_per_package
		SET optProductsSold = optProductsSold + 1,
			`avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = (SELECT servicePackageId FROM `order` O WHERE O.id = new.orderId);
       
# cancellazione di un opt product
CREATE TRIGGER opt_prod_delete
AFTER DELETE ON optional_product_choice
FOR EACH ROW
	UPDATE average_number_opt_products_per_package
		SET optProductsSold = optProductsSold - 1,
			`avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = (SELECT servicePackageId FROM `order` O WHERE O.id = old.orderId);
        
# inserimento di un ordine
CREATE TRIGGER avg_opt_prod_insert
AFTER INSERT ON `order`
FOR EACH ROW
	UPDATE average_number_opt_products_per_package 
		SET totOrders = totOrders + 1,
			`avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = new.servicePackageId;

# cancellazione di un ordine 
CREATE TRIGGER avg_opt_prod_delete
AFTER DELETE ON `order`
FOR EACH ROW
	UPDATE average_number_opt_products_per_package 
		SET totOrders = totOrders - 1,
			`avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = old.servicePackageId;
	
# query finale
# SELECT servicePackageId, `avg`
# FROM average_number_opt_products_per_package