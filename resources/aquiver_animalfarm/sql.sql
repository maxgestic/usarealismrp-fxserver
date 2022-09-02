CREATE TABLE IF NOT EXISTS `af_composts` (
  `farmId` int DEFAULT NULL,
  `compostStrid` varchar(128) DEFAULT NULL,
  `shitAmount` int DEFAULT NULL,
  KEY `farmId` (`farmId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `af_farms_base` (
  `farmId` int NOT NULL AUTO_INCREMENT,
  `ownerIdentifier` varchar(255) DEFAULT NULL,
  `ownerName` varchar(255) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `x` int DEFAULT NULL,
  `y` int DEFAULT NULL,
  `z` int DEFAULT NULL,
  `img` text,
  `name` varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL,
  `locked` tinyint DEFAULT NULL,
  `milk` int DEFAULT '0',
  `egg` int DEFAULT '0',
  `meal` int DEFAULT '0',
  KEY `id` (`farmId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `af_paddock_animals` (
  `aid` int NOT NULL AUTO_INCREMENT,
  `farmId` int NOT NULL,
  `paddockStrid` varchar(128) CHARACTER SET utf8mb4 NOT NULL,
  `hunger` int DEFAULT NULL,
  `age` double DEFAULT NULL,
  `thirst` int DEFAULT NULL,
  `animalType` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL,
  `milk` int DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `health` int DEFAULT NULL,
  `extra` double DEFAULT NULL,
  PRIMARY KEY (`aid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=150 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `af_paddock_upgrades` (
  `farmId` int DEFAULT NULL,
  `paddockStrid` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL,
  `upgradeStrid` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL,
  `foodAmount` int DEFAULT NULL,
  `waterAmount` int DEFAULT NULL,
  KEY `farmId` (`farmId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;