CREATE TABLE `purchases_per_package` (
                                        `servicePackageId` int NOT NULL,
                                        `servicePackageName` varchar(255) NOT NULL,
                                        `totalPurchases` int NOT NULL
);

CREATE TRIGGER total_purchases_after_insert_sp
AFTER INSERT ON service_package
FOR EACH ROW
		INSERT INTO purchases_per_package
			values(new.id, new.name, 0)