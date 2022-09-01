-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.17-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


USE `testserver`;

CREATE TABLE IF NOT EXISTS `cryptohistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(256) NOT NULL DEFAULT '',
  `crypto` varchar(256) NOT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`date`,`crypto`) USING BTREE,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28222 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `cryptoplayers` (
  `identifier` varchar(512) DEFAULT NULL,
  `walletHash` varchar(1024) DEFAULT NULL,
  `cryptobalance` double DEFAULT 0,
  `cryptos` longtext DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `crypto_player_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fromWallet` varchar(1024) DEFAULT NULL,
  `toWallet` varchar(1024) DEFAULT NULL,
  `date` varchar(512) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `crypto` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `crypto_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `walletHash` varchar(1024) DEFAULT NULL,
  `date` varchar(512) DEFAULT NULL,
  `type` varchar(64) DEFAULT NULL,
  `crypto` varchar(64) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
