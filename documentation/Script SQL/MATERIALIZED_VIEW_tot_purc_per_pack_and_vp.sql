CREATE TABLE `purchases_per_package_and_vp` (
                                         `servicePackageId` int NOT NULL,
                                         `validityPeriodId` int NOT NULL,
                                         `servicePackageName` varchar(255) NOT NULL,
                                         `totalPurchases` int NOT NULL
);

DELIMITER $$

CREATE TRIGGER total_purchases_vp_after_insert_sp
    AFTER INSERT ON possible_validity_period
    FOR EACH ROW
        begin
            INSERT INTO purchases_per_package_and_vp
                (SELECT new.servicePackageId, new.validityPeriodId, sp.name, 0
                 FROM service_package sp
                 WHERE sp.id = new.servicePackageId);
        end; $$


CREATE TRIGGER total_purchases_vp_after_insert_order
    AFTER INSERT ON `order`
    FOR EACH ROW
        begin
            IF  new.valid = true
            THEN
                UPDATE purchases_per_package_and_vp
                SET totalPurchases = totalPurchases + 1
                WHERE new.servicePackageId = purchases_per_package_and_vp.servicePackageId
                  AND new.validityPeriodId = purchases_per_package_and_vp.validityPeriodId;
            END IF;
        END $$

CREATE TRIGGER total_purchases_vp_after_update_order
    AFTER UPDATE ON `order`
    FOR EACH ROW
        begin
            IF  old.valid = false AND new.valid = true
            THEN
                UPDATE purchases_per_package_and_vp
                SET totalPurchases = totalPurchases + 1
                WHERE new.servicePackageId = purchases_per_package_and_vp.servicePackageId
                  AND new.validityPeriodId = purchases_per_package_and_vp.validityPeriodId;
            END IF;
        END $$

CREATE TRIGGER total_purchases_vp_after_delete_sp
    AFTER DELETE ON service_package
    FOR EACH ROW
        DELETE FROM purchases_per_package_and_vp
        WHERE purchases_per_package_and_vp.servicePackageId = old.id $$

DELIMITER ;