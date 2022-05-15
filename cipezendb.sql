-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versione server:              10.4.21-MariaDB - mariadb.org binary distribution
-- S.O. server:                  Win64
-- HeidiSQL Versione:            11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dump della struttura del database cipezen
CREATE DATABASE IF NOT EXISTS `cipezen` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `cipezen`;

-- Dump della struttura di tabella cipezen.items
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `limit` int(11) DEFAULT NULL,
  `canRemove` int(11) unsigned DEFAULT 1,
  `description` longtext DEFAULT '[]',
  `other` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dump dei dati della tabella cipezen.items: ~0 rows (circa)
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
/*!40000 ALTER TABLE `items` ENABLE KEYS */;

-- Dump della struttura di tabella cipezen.players
CREATE TABLE IF NOT EXISTS `players` (
  `rockstarlicense` varchar(50) DEFAULT NULL,
  `money` longtext DEFAULT NULL,
  `position` longtext DEFAULT NULL,
  `permission` longtext DEFAULT 'player',
  `inventory` longtext DEFAULT NULL,
  `weapons` longtext DEFAULT NULL,
  `job` text DEFAULT 'unemployed',
  `jobgrade` int(11) DEFAULT 0,
  `maxSlots` int(11) DEFAULT 10,
  `skin` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dump dei dati della tabella cipezen.players: ~0 rows (circa)
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
/*!40000 ALTER TABLE `players` ENABLE KEYS */;

-- Dump della struttura di tabella cipezen.uniquepitems
CREATE TABLE IF NOT EXISTS `uniquepitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `other` longtext DEFAULT '[]',
  `owner` longtext DEFAULT NULL,
  `canRemove` int(11) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;

-- Dump dei dati della tabella cipezen.uniquepitems: ~1 rows (circa)
/*!40000 ALTER TABLE `uniquepitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `uniquepitems` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
