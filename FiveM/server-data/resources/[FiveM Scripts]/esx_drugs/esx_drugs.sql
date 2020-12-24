USE `es_extended`;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('marijuana', 'Marijuana', 40, 0, 1),
	('weed', 'Weed', 14, 0, 1),
	('coca_leaf', 'Coca Leaf', 40, 0, 1),
	('coke', 'Coke', 40, 0, 1),
	('poppyresin', 'Poppy', 160, 0, 1),
	('heroin', 'Heroin', 80, 0, 1),
	('meth', 'Meth', 30, 0, 1)
;

INSERT INTO `licenses` (`type`, `label`) VALUES
	('weed', 'Weed License'),
	('coke', 'Coke license'),
	('meth', 'Meth license'),
	('heroin', 'Heroin license')
;