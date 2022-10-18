CREATE DATABASE  IF NOT EXISTS `test_linkedin_test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `test_linkedin_test`;
-- MySQL dump 10.13  Distrib 8.0.27, for macos11 (x86_64)
--
-- Host: localhost    Database: test_linkedin_test
-- ------------------------------------------------------
-- Server version	8.0.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `campaign_mapping`
--

DROP TABLE IF EXISTS `campaign_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `campaign_mapping` (
  `campaign_id` int NOT NULL,
  `impression_id` int DEFAULT NULL,
  KEY `impression_id_idx` (`impression_id`),
  CONSTRAINT `impression_id` FOREIGN KEY (`impression_id`) REFERENCES `impressions` (`impression_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `campaign_mapping`
--

LOCK TABLES `campaign_mapping` WRITE;
/*!40000 ALTER TABLE `campaign_mapping` DISABLE KEYS */;
INSERT INTO `campaign_mapping` VALUES (1,334),(4,202),(2,236),(1,246),(4,205),(4,216);
/*!40000 ALTER TABLE `campaign_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clicks_table`
--

DROP TABLE IF EXISTS `clicks_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clicks_table` (
  `impression_id` int DEFAULT NULL,
  `member_id` int DEFAULT NULL,
  `no_clicks` int NOT NULL,
  KEY `member_id_idx` (`member_id`,`impression_id`),
  KEY `impression_id_idx` (`impression_id`,`member_id`),
  CONSTRAINT `impression_id_` FOREIGN KEY (`impression_id`) REFERENCES `impressions` (`impression_id`),
  CONSTRAINT `member_id_` FOREIGN KEY (`member_id`) REFERENCES `impressions` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clicks_table`
--

LOCK TABLES `clicks_table` WRITE;
/*!40000 ALTER TABLE `clicks_table` DISABLE KEYS */;
INSERT INTO `clicks_table` VALUES (334,7,1),(202,22,1),(246,12,0),(205,11,1),(216,21,0);
/*!40000 ALTER TABLE `clicks_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `combined_campaigns`
--

DROP TABLE IF EXISTS `combined_campaigns`;
/*!50001 DROP VIEW IF EXISTS `combined_campaigns`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `combined_campaigns` AS SELECT 
 1 AS `impression_id`,
 1 AS `member_id`,
 1 AS `campaign_id`,
 1 AS `num_clicks`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `groups_dim`
--

DROP TABLE IF EXISTS `groups_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups_dim` (
  `groupid` int NOT NULL AUTO_INCREMENT,
  `admins` int NOT NULL,
  `group_age` varchar(20) NOT NULL,
  PRIMARY KEY (`groupid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_dim`
--

LOCK TABLES `groups_dim` WRITE;
/*!40000 ALTER TABLE `groups_dim` DISABLE KEYS */;
INSERT INTO `groups_dim` VALUES (1,2,'3-5'),(2,2,'>5'),(3,3,'3-5');
/*!40000 ALTER TABLE `groups_dim` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups_member_engagement`
--

DROP TABLE IF EXISTS `groups_member_engagement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups_member_engagement` (
  `memberid` int NOT NULL,
  `groupid` int NOT NULL,
  `month` enum('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC') NOT NULL,
  `posts_created` int NOT NULL,
  `post_likes` int NOT NULL,
  `post_views` int NOT NULL,
  KEY `groupid__idx` (`groupid`),
  KEY `memberid__idx` (`memberid`),
  CONSTRAINT `groupid_` FOREIGN KEY (`groupid`) REFERENCES `groups_dim` (`groupid`),
  CONSTRAINT `memberid_` FOREIGN KEY (`memberid`) REFERENCES `groups_members` (`memberid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_member_engagement`
--

LOCK TABLES `groups_member_engagement` WRITE;
/*!40000 ALTER TABLE `groups_member_engagement` DISABLE KEYS */;
INSERT INTO `groups_member_engagement` VALUES (22,1,'JAN',1,1,7),(16,2,'JAN',4,2,3),(5,3,'JAN',2,8,8),(25,2,'FEB',1,2,4),(34,2,'FEB',20,100,300),(102,1,'FEB',10,5,15);
/*!40000 ALTER TABLE `groups_member_engagement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups_members`
--

DROP TABLE IF EXISTS `groups_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups_members` (
  `memberid` int NOT NULL,
  `groupid` int NOT NULL,
  `memberengagement` enum('LOW','MEDIUM','HIGH') NOT NULL,
  `industry` varchar(50) NOT NULL,
  PRIMARY KEY (`memberid`),
  KEY `groupid_idx` (`groupid`),
  CONSTRAINT `groupid` FOREIGN KEY (`groupid`) REFERENCES `groups_dim` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_members`
--

LOCK TABLES `groups_members` WRITE;
/*!40000 ALTER TABLE `groups_members` DISABLE KEYS */;
INSERT INTO `groups_members` VALUES (5,3,'MEDIUM','Healthcare'),(16,2,'LOW','Retail'),(22,1,'MEDIUM','Media'),(25,2,'LOW','Education'),(34,2,'HIGH','Media'),(102,1,'MEDIUM','Education');
/*!40000 ALTER TABLE `groups_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `impressions`
--

DROP TABLE IF EXISTS `impressions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `impressions` (
  `impression_id` int NOT NULL,
  `member_id` int NOT NULL,
  PRIMARY KEY (`impression_id`),
  KEY `MEMBER_ID` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `impressions`
--

LOCK TABLES `impressions` WRITE;
/*!40000 ALTER TABLE `impressions` DISABLE KEYS */;
INSERT INTO `impressions` VALUES (334,7),(205,11),(246,12),(236,13),(216,21),(202,22);
/*!40000 ALTER TABLE `impressions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `combined_campaigns`
--

/*!50001 DROP VIEW IF EXISTS `combined_campaigns`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `combined_campaigns` (`impression_id`,`member_id`,`campaign_id`,`num_clicks`) AS select `ci`.`impression_id` AS `impression_id`,`ci`.`member_id` AS `member_id`,`ci`.`campaign_id` AS `campaign_id`,`CLK`.`no_clicks` AS `num_clicks` from ((select `C`.`campaign_id` AS `campaign_id`,`I`.`impression_id` AS `impression_id`,`I`.`member_id` AS `member_id` from (`campaign_mapping` `C` left join `impressions` `I` on((`C`.`impression_id` = `I`.`impression_id`)))) `CI` left join `clicks_table` `CLK` on((`ci`.`impression_id` = `CLK`.`impression_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-12-30 12:49:11
