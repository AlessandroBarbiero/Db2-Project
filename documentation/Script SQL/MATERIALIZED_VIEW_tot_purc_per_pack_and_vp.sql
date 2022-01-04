CREATE VIEW `purchases_per_package_and_vp_view` (servicePackageName, numberOfMonths, monthlyFee, totalPurchases) as
    SELECT s.name, v.numberOfMonths, v.monthlyFee, count(*)
    FROM service_package s, validity_period v, `order` o
    WHERE s.id = o.servicePackageId AND v.id = o.validityPeriodId AND o.valid = true
    GROUP BY s.id, v.id;

# MATERIALIZED VIEW
CREATE TABLE `purchases_per_package_and_vp` (
                                         `servicePackageId` int NOT NULL,
                                         `validityPeriodId` int NOT NULL,
                                         `totalPurchases` int NOT NULL
);

DELIMITER $$

CREATE TRIGGER total_purchases_vp_after_insert_sp
    AFTER INSERT ON possible_validity_period
    FOR EACH ROW
        INSERT INTO purchases_per_package_and_vp
            values (new.servicePackageId, new.validityPeriodId, 0);
$$


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
        END
$$

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
        END
$$

DELIMITER ;