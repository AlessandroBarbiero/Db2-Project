
CREATE TABLE `ServicePackage` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `Service` (
	`id` int NOT NULL AUTO_INCREMENT,
	`type` enum('FIXED_PHONE', 'MOBILE_PHONE', 'FIXED_INTERNET', 'MOBILE_INTERNET') NOT NULL,
	`numberOfSms` int NOT NULL,
	`numberOfMinutes` int NOT NULL,
	`extraMinutesFee` FLOAT NOT NULL,
	`extraSmsFee` FLOAT NOT NULL,
	`numberOfGb` int NOT NULL,
	`extraGbFee` FLOAT NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `ServiceComposition` (
	`serviceId` int NOT NULL,
	`servicePackageId` int NOT NULL
);


CREATE TABLE `User` (
	`id` int NOT NULL AUTO_INCREMENT,
	`password` varchar(255) NOT NULL,
	`username` varchar(255) NOT NULL UNIQUE,
	`email` varchar(255) NOT NULL UNIQUE,
	PRIMARY KEY (`id`)
);

CREATE TABLE `Employee` (
	`id` int NOT NULL AUTO_INCREMENT,
	`password` varchar(255) NOT NULL,
	`username` varchar(255) NOT NULL UNIQUE,
	PRIMARY KEY (`id`)
);

CREATE TABLE `ValidityPeriod` (
	`id` int NOT NULL AUTO_INCREMENT,
	`numberOfMonths` int NOT NULL,
	`monthlyFee` FLOAT NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `OptionalProduct` (
	`name` varchar(255) NOT NULL,
	`monthlyFee` FLOAT NOT NULL,
	PRIMARY KEY (`name`)
);

CREATE TABLE `Order` (
	`id` int NOT NULL AUTO_INCREMENT,
	`valid` bool NOT NULL,
	`startDate` DATE NOT NULL,
	`creation` TIMESTAMP NOT NULL,
	`servicePackageId` int NOT NULL,
	`userId` int NOT NULL,
	`validityPeriodId` int NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `BlackList` (
	`userId` int NOT NULL,
	`username` varchar(255) NOT NULL,
	`email` varchar(255) NOT NULL,
	`lastRejection` TIMESTAMP NOT NULL,
	`amount` FLOAT NOT NULL,
	PRIMARY KEY (`userId`)
);

CREATE TABLE `OptionalProductChoice` (
	`optionalProductName` varchar(255) NOT NULL,
	`orderId` int NOT NULL,
	PRIMARY KEY (`OptionalProductName`,`orderId`)
);

CREATE TABLE `PossibleValidityPeriod` (
	`validityPeriodId` int NOT NULL,
	`servicePackageId` int NOT NULL,
	PRIMARY KEY (`validityPeriodId`,`servicePackageId`)
);

CREATE TABLE `PossibleExtentions` (
	`optionalProductName` varchar(255) NOT NULL,
	`servicePackageId` int NOT NULL,
	PRIMARY KEY (`optionalProductName`,`servicePackageId`)
);

ALTER TABLE `Order` ADD CONSTRAINT `Order_fk0` FOREIGN KEY (`servicePackageId`) REFERENCES `ServicePackage`(`id`);
ALTER TABLE `Order` ADD CONSTRAINT `Order_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`id`);
ALTER TABLE `Order` ADD CONSTRAINT `Order_fk2` FOREIGN KEY (`validityPeriodId`) REFERENCES `ValidityPeriod`(`id`);

ALTER TABLE `BlackList` ADD CONSTRAINT `BlackList_fk0` FOREIGN KEY (`userId`) REFERENCES `User`(`id`);

ALTER TABLE `OptionalProductChoice` ADD CONSTRAINT `OptionalProductChoice_fk0` FOREIGN KEY (`OptionalProductName`) REFERENCES `OptionalProduct`(`name`);
ALTER TABLE `OptionalProductChoice` ADD CONSTRAINT `OptionalProductChoice_fk1` FOREIGN KEY (`orderId`) REFERENCES `Order`(`id`);

ALTER TABLE `PossibleValidityPeriod` ADD CONSTRAINT `PossibleValidityPeriod_fk0` FOREIGN KEY (`validityPeriodId`) REFERENCES `ValidityPeriod`(`id`);
ALTER TABLE `PossibleValidityPeriod` ADD CONSTRAINT `PossibleValidityPeriod_fk1` FOREIGN KEY (`servicePackageId`) REFERENCES `ServicePackage`(`id`);

ALTER TABLE `PossibleExtentions` ADD CONSTRAINT `PossibleExtentions_fk0` FOREIGN KEY (`optionalProductName`) REFERENCES `OptionalProduct`(`name`);
ALTER TABLE `PossibleExtentions` ADD CONSTRAINT `PossibleExtentions_fk1` FOREIGN KEY (`servicePackageId`) REFERENCES `ServicePackage`(`id`);

ALTER TABLE `ServiceComposition` ADD CONSTRAINT `ServiceComposition_fk0` FOREIGN KEY (`serviceId`) REFERENCES `Service`(`id`);
ALTER TABLE `ServiceComposition` ADD CONSTRAINT `ServiceComposition_fk1` FOREIGN KEY (`servicePackageId`) REFERENCES `ServicePackage`(`id`);







