
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
                                       `servicePackageId` int NOT NULL
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


