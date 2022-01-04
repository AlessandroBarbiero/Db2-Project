CREATE VIEW `purchases_per_package_view` (servicePackageId, servicePackageName, totalPurchases) as
    SELECT s.id, s.name, count(*)
    FROM service_package s, `order` o
    WHERE s.id = o.servicePackageId AND o.valid = true
    GROUP BY s.id;

# MATERIALIZED VIEW
CREATE TABLE `purchases_per_package` (
                                        `servicePackageId` int NOT NULL,
                                        `totalPurchases` int NOT NULL
);

DELIMITER $$

CREATE TRIGGER total_purchases_after_insert_sp
    AFTER INSERT ON service_package
    FOR EACH ROW
            INSERT INTO purchases_per_package
                values(new.id, 0)
$$

CREATE TRIGGER total_purchases_after_insert_order
    AFTER INSERT ON `order`
    FOR EACH ROW
        begin
            IF  new.valid = true
            THEN
                UPDATE purchases_per_package
                    SET totalPurchases = totalPurchases + 1
                    WHERE new.servicePackageId = purchases_per_package.servicePackageId;
            END IF;
        END
$$

CREATE TRIGGER total_purchases_after_update_order
    AFTER UPDATE ON `order`
    FOR EACH ROW
        begin
            IF  old.valid = false AND new.valid = true
            THEN
                UPDATE purchases_per_package
                SET totalPurchases = totalPurchases + 1
                WHERE new.servicePackageId = purchases_per_package.servicePackageId;
            END IF;
        END
$$

DELIMITER ;