CREATE TABLE IF NOT EXISTS `properties` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `price` int(11) NOT NULL,
    `x` FLOAT DEFAULT NULL,
    `y` FLOAT DEFAULT NULL,
    `z` FLOAT DEFAULT NULL,
    `shell` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;