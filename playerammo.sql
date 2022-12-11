CREATE TABLE `playerammo` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`serino` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`ammo` MEDIUMTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `citizenid` (`serino`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=MyISAM
AUTO_INCREMENT=12
;
