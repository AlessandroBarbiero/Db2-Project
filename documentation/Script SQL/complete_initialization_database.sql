
CREATE TABLE `service_package` (
                                   `id` int NOT NULL AUTO_INCREMENT,
                                   `name` varchar(255) NOT NULL,
                                   PRIMARY KEY (`id`)
);

CREATE TABLE `user` (
                        `id` int NOT NULL AUTO_INCREMENT,
                        `username` varchar(255) NOT NULL UNIQUE,
                        `password` varchar(255) NOT NULL,
                        `email` varchar(255) NOT NULL UNIQUE,
                        PRIMARY KEY (`id`)
);

CREATE TABLE `employee` (
                            `id` int NOT NULL AUTO_INCREMENT,
                            `username` varchar(255) NOT NULL UNIQUE,
                            `password` varchar(255) NOT NULL,
                            PRIMARY KEY (`id`)
);

CREATE TABLE `validity_period` (
                                   `id` int NOT NULL AUTO_INCREMENT,
                                   `numberOfMonths` int NOT NULL,
                                   `monthlyFee` FLOAT NOT NULL,
                                   PRIMARY KEY (`id`)
);

CREATE TABLE `optional_product` (
                                    `id` int NOT NULL AUTO_INCREMENT,
                                    `name` varchar(255) NOT NULL,
                                    `monthlyFee` FLOAT NOT NULL,
                                    PRIMARY KEY (`id`)
);

CREATE TABLE `order` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `valid` bool NOT NULL,
                         `startDate` DATE NOT NULL,
                         `creation` TIMESTAMP NOT NULL,
                         `totalPrice` float NOT NULL,
                         `servicePackageId` int NOT NULL,
                         `userId` int NOT NULL,
                         `validityPeriodId` int NOT NULL,
                         PRIMARY KEY (`id`)
);

CREATE TABLE `blacklist` (
                             `userId` int NOT NULL,
                             `username` varchar(255) NOT NULL,
                             `email` varchar(255) NOT NULL,
                             `lastRejection` TIMESTAMP NOT NULL,
                             `amount` FLOAT NOT NULL,
                             PRIMARY KEY (`userId`)
);

CREATE TABLE `optional_product_choice` (
                                           `optionalProductId` int NOT NULL,
                                           `orderId` int NOT NULL,
                                           PRIMARY KEY (`optionalProductId`,`orderId`)
);

CREATE TABLE `possible_validity_period` (
                                            `validityPeriodId` int NOT NULL,
                                            `servicePackageId` int NOT NULL,
                                            PRIMARY KEY (`validityPeriodId`,`servicePackageId`)
);

CREATE TABLE `possible_extensions` (
                                       `optionalProductId` int NOT NULL,
                                       `servicePackageId` int NOT NULL,
                                       PRIMARY KEY (`optionalProductId`,`servicePackageId`)
);

CREATE TABLE `service` (
                           `id` int NOT NULL AUTO_INCREMENT,
                           `type` enum('FIXED_PHONE', 'MOBILE_PHONE', 'FIXED_INTERNET', 'MOBILE_INTERNET') NOT NULL,
                           `numberOfSms` int,
                           `numberOfMinutes` int,
                           `extraMinutesFee` FLOAT,
                           `extraSmsFee` FLOAT,
                           `numberOfGb` int,
                           `extraGbFee` FLOAT,
                           PRIMARY KEY (`id`)
);

CREATE TABLE `service_composition` (
                                       `serviceId` int NOT NULL,
                                       `servicePackageId` int NOT NULL,
                                       PRIMARY KEY (`serviceId`,`servicePackageId`)
);

CREATE TABLE `schedule_activation` (
                                       `id` int NOT NULL AUTO_INCREMENT,
                                       `orderId` int NOT NULL,
                                       `startDate` DATE NOT NULL,
                                       `endDate` DATE NOT NULL,
                                       PRIMARY KEY (`id`)
);

ALTER TABLE `order` ADD CONSTRAINT `order_fk0` FOREIGN KEY (`servicePackageId`) REFERENCES `service_package`(`id`);
ALTER TABLE `order` ADD CONSTRAINT `order_fk1` FOREIGN KEY (`userId`) REFERENCES `user`(`id`);
ALTER TABLE `order` ADD CONSTRAINT `order_fk2` FOREIGN KEY (`validityPeriodId`) REFERENCES `validity_period`(`id`);

ALTER TABLE `blacklist` ADD CONSTRAINT `blacklist_fk0` FOREIGN KEY (`userId`) REFERENCES `user`(`id`);

ALTER TABLE `optional_product_choice` ADD CONSTRAINT `optional_product_choice_fk0` FOREIGN KEY (`optionalProductId`) REFERENCES `optional_product`(`id`);
ALTER TABLE `optional_product_choice` ADD CONSTRAINT `optional_product_choice_fk1` FOREIGN KEY (`orderId`) REFERENCES `order`(`id`);

ALTER TABLE `possible_validity_period` ADD CONSTRAINT `possible_validity_period_fk0` FOREIGN KEY (`validityPeriodId`) REFERENCES `validity_period`(`id`);
ALTER TABLE `possible_validity_period` ADD CONSTRAINT `possible_validity_period_fk1` FOREIGN KEY (`servicePackageId`) REFERENCES `service_package`(`id`);

ALTER TABLE `possible_extensions` ADD CONSTRAINT `possible_extensions_fk0` FOREIGN KEY (`optionalProductId`) REFERENCES `optional_product`(`id`);
ALTER TABLE `possible_extensions` ADD CONSTRAINT `possible_extensions_fk1` FOREIGN KEY (`servicePackageId`) REFERENCES `service_package`(`id`);

ALTER TABLE `service_composition` ADD CONSTRAINT `service_composition_fk0` FOREIGN KEY (`serviceId`) REFERENCES `service`(`id`);
ALTER TABLE `service_composition` ADD CONSTRAINT `service_composition_fk1` FOREIGN KEY (`servicePackageId`) REFERENCES `service_package`(`id`);

ALTER TABLE `schedule_activation` ADD CONSTRAINT `schedule_activation_fk0` FOREIGN KEY (`orderId`) REFERENCES `order`(`id`);

# trigger_blacklist

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
END
$$

# MATERIALIZED_VIEWS
# 1
CREATE TABLE `purchases_per_package` (
                                         `servicePackageId` int NOT NULL,
                                         `totalPurchases` int NOT NULL
);
$$

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

# 2
CREATE TABLE `purchases_per_package_and_vp` (
                                                `servicePackageId` int NOT NULL,
                                                `validityPeriodId` int NOT NULL,
                                                `totalPurchases` int NOT NULL
);
$$

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

# 3
CREATE TABLE `sales_per_package` (
                                     `servicePackageId` int NOT NULL,
                                     `revenueWithOpProd` int NOT NULL,
                                     `revenueWithoutOpProd` int NOT NULL
);
$$

CREATE TRIGGER sales_per_package_init
    AFTER INSERT ON service_package
    FOR EACH ROW
    INSERT INTO sales_per_package
    values(new.id, 0, 0);
$$

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
$$

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
$$

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
$$

# 4
CREATE TABLE `average_number_opt_products_per_package` (
                                                           `servicePackageId` int NOT NULL,
                                                           `optProductsSold` int NOT NULL,
                                                           `totOrders` int NOT NULL,
                                                           `avg` float NOT NULL
);
$$

CREATE TRIGGER avg_opt_prod_init
    AFTER INSERT ON service_package
    FOR EACH ROW
    INSERT INTO average_number_opt_products_per_package
    values(new.id, 0, 0, 0);
$$

CREATE TRIGGER opt_prod_insert
    AFTER INSERT ON optional_product_choice
    FOR EACH ROW
    IF (SELECT o.valid FROM `order` o WHERE o.id = new.orderId) THEN
        UPDATE average_number_opt_products_per_package
        SET optProductsSold = optProductsSold + 1,
            `avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = (SELECT servicePackageId FROM `order` O WHERE O.id = new.orderId);
    END IF;
$$

CREATE TRIGGER avg_opt_prod_insert
    AFTER INSERT ON `order`
    FOR EACH ROW
    IF new.valid THEN
        UPDATE average_number_opt_products_per_package
        SET totOrders = totOrders + 1,
            `avg` = (optProductsSold / totOrders)
        WHERE servicePackageId = new.servicePackageId;
    END IF;
$$

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
$$

# 5.1
CREATE TABLE `insolvent_users` (
                                   `id` int NOT NULL UNIQUE,
                                   `username` varchar(255) NOT NULL UNIQUE,
                                   `email` varchar(255) NOT NULL UNIQUE
);
$$

CREATE TRIGGER add_insolvent_user
    AFTER INSERT ON `order`
    FOR EACH ROW
begin
    IF
                new.valid = false AND
                NOT EXISTS(
                        SELECT *
                        FROM insolvent_users
                        WHERE id=new.userId
                    )
    THEN
        INSERT INTO insolvent_users
            (SELECT u.id, u.username, u.email
             FROM user u
             WHERE u.id = new.userId);

    END IF;
end;
$$

CREATE TRIGGER remove_insolvent_user
    AFTER UPDATE ON `order`
    FOR EACH ROW
begin
    IF  old.valid = false AND
        new.valid = true AND
        NOT EXISTS(
                SELECT *
                FROM `order` o
                WHERE o.valid = false AND
                        new.userId = o.userId
            )
    THEN
        DELETE FROM insolvent_users
        WHERE insolvent_users.id = new.userId;
    END IF;
END
$$

# 5.2
CREATE TABLE suspended_orders (
    `id` int NOT NULL
);
$$

CREATE TRIGGER add_suspended_order
    AFTER INSERT ON `order`
    FOR EACH ROW
begin
    IF  new.valid = false
    THEN
        INSERT INTO suspended_orders
            value (new.id);

    END IF;
end;
$$

CREATE TRIGGER remove_suspended_order
    AFTER UPDATE ON `order`
    FOR EACH ROW
begin
    IF  old.valid = false AND
        new.valid = true
    THEN
        DELETE FROM suspended_orders
        WHERE suspended_orders.id = new.id;
    END IF;
END
$$

# 6
CREATE TABLE `best_seller_opt_prod` (
                                        `optionalProductId` int NOT NULL,
                                        `revenue` int NOT NULL
);
$$

CREATE TRIGGER best_seller_opt_prod_init
    AFTER INSERT ON optional_product
    FOR EACH ROW
    INSERT INTO best_seller_opt_prod
    values(new.id, 0);
$$

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
$$

CREATE TRIGGER revenue_opt_prod_update
    AFTER UPDATE ON `order`
    FOR EACH ROW
    IF old.valid = false AND new.valid = true THEN
        UPDATE best_seller_opt_prod bsop
        SET revenue = revenue + (SELECT op.monthlyFee * numberOfMonths
                                 FROM `order` o JOIN validity_period v ON  o.validityPeriodId = v.id
                                                JOIN optional_product_choice opc ON o.id = opc.orderId
                                                JOIN optional_product op ON opc.optionalProductId = op.id
                                 WHERE o.id = new.id AND op.id = bsop.optionalProductId)
        WHERE optionalProductId IN (SELECT op2.optionalProductId FROM optional_product_choice op2 WHERE op2.orderId = new.id);
    END IF;
$$

delimiter ;

# SERVICE INSERTIONS
INSERT INTO service (type, numberOfSms, numberOfMinutes, extraMinutesFee, extraSmsFee, numberOfGb, extraGbFee)
VALUES
    ('FIXED_PHONE', null, null, null, null, null, null),
    ('MOBILE_PHONE', 1000, 1000, 0.10, 0.20, null, null),
    ('MOBILE_PHONE', 1000, 2000, 0.05, 0.20, null, null),
    ('FIXED_INTERNET', null, null, null, null, 500, 3),
    ('FIXED_INTERNET', null, null, null, null, 1000, 1.5),
    ('MOBILE_INTERNET', null, null, null, null, 20 , 1),
    ('MOBILE_INTERNET', null, null, null, null, 50 , 0.5);

# VALIDITY PERIOD INSERTIONS
INSERT INTO validity_period (numberofmonths, monthlyfee)
VALUES
    (12, 20),
    (24, 18),
    (36, 15),
    (12, 30),
    (24, 28),
    (36, 25);

# EMPLOYEE REGISTRATION INSERTIONS
INSERT INTO employee (username, password)
VALUES
    ('giulia', 'giulia'),
    ('ale', 'ale');
