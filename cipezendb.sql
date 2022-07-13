CREATE DATABASE IF NOT EXISTS `cipezen`
USE `cipezen`;

CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `limit` int(11) DEFAULT -1,
  `weight` int(11) DEFAULT 1,
  `canRemove` int(11) unsigned DEFAULT 1,
  `description` longtext DEFAULT '',
  `other` longtext DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `players` (
  `rockstarlicense` varchar(50) DEFAULT NULL,
  `money` longtext DEFAULT NULL,
  `position` longtext DEFAULT NULL,
  `permission` longtext DEFAULT 'player',
  `inventory` longtext DEFAULT NULL,
  `weapons` longtext DEFAULT NULL,
  `job` text DEFAULT 'unemployed',
  `jobgrade` int(11) DEFAULT 0,
  `backpack` text DEFAULT NULL,
  `skin` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `uniqueitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `description` longtext DEFAULT '',
  `other` longtext DEFAULT '[]',
  `owner` longtext DEFAULT NULL,
  `weight` int(11) DEFAULT 1,
  `canRemove` int(11) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;