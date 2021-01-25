CREATE TABLE `gangs` (
	`name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`label` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`weaponStocks` INT(11) NULL DEFAULT '0',
	`itemStocks` INT(11) NULL DEFAULT '0',
	`gangFunds` INT(11) NULL DEFAULT '0'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

INSERT INTO `gangs` (`name`, `label`, `weaponStocks`, `itemStocks`, `gangFunds`) VALUES
	('Gang1', 'Gang Name', 5, 10, 10000),
	('Gang2', 'Gang Name', 5, 10, 10000),
	('Gang3', 'Gang Name', 5, 10, 10000),
	('Gang4', 'Gang Name', 5, 10, 10000),
	('Gang5', 'Gang Name', 5, 10, 10000),
	('Gang6', 'Gang Name', 5, 10, 10000)
;

ALTER TABLE `users` ADD `gang` VARCHAR(30) NULL, ADD `gang_rank` TINYINT(5) NULL;

INSERT INTO `items` (`name`, `label`, `limit`) VALUES
	('kevlar_cloth', 'Kevlar cloth', 10),
	('kevlar', 'Kevlar', 5)
;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('Gang1_black_money', 'Gang1 Stash', 1),
	('Gang1_black_money', 'Gang2 Stash', 1),
	('Gang1_black_money', 'Gang3 Stash', 1),
	('Gang1_black_money', 'Gang4 Stash', 1),
	('Gang1_black_money', 'Gang5 Stash', 1),
	('Gang1_black_money', 'Gang6 Stash', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('Gang1', 'Gang1 Stash', 1),
	('Gang2', 'Gang2 Stash', 1),
	('Gang3', 'Gang3 Stash', 1),
	('Gang4', 'Gang4 Stash', 1),
	('Gang5', 'Gang5 Stash', 1),
	('Gang6', 'Gang6 Stash', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('Gang1', 'Gang1 Stash', 1),
	('Gang2', 'Gang2 Stash', 1),
	('Gang3', 'Gang3 Stash', 1),
	('Gang4', 'Gang4 Stash', 1),
	('Gang5', 'Gang5 Stash', 1),
	('Gang6', 'Gang6 Stash', 1)
;
