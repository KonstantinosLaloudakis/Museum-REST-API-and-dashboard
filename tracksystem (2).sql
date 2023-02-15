-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 17, 2022 at 05:10 PM
-- Server version: 10.4.20-MariaDB
-- PHP Version: 8.0.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tracksystem`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `GetNewVipVisitorsData`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetNewVipVisitorsData` ()  BEGIN
insert into
    `vipvisitorsdata` (id, time, rssi, visitor_id, sensor_id, counter)
select
    r1.*
from
    mock_data r1
    inner JOIN (
        select
            *
        from
            (
                select
                    FROM_UNIXTIME(
                        UNIX_TIMESTAMP(t1.time) - UNIX_TIMESTAMP(t1.time) mod 5
                    ) as time5,
                    t1.id as id,
                    t1.time as time,
                    t1.visitor_id as visitor_id,
                    t1.rssi as rssi
                from
                    mock_data t1
                    INNER JOIN (
                        select
                            FROM_UNIXTIME(
                                UNIX_TIMESTAMP(t2.time) - UNIX_TIMESTAMP(t2.time) mod 5
                            ) as time5,
                            max(t2.rssi) as rssi,
                            t2.visitor_id as visitor_id
                        from
                            mock_data t2
                            Inner Join (
                                SELECT
                                    id
                                from
                                    visitorids
                                where
                                    isVIP = 1
                            ) as visitorids on t2.visitor_id = visitorids.id
                        WHERE
                            t2.time >= NOW() - INTERVAL 1 MINUTE
                        GROUP BY
                            FROM_UNIXTIME(
                                UNIX_TIMESTAMP(t2.time) - UNIX_TIMESTAMP(t2.time) mod 5
                            ),
                            visitor_id
                    ) as t3 on t3.time5 = FROM_UNIXTIME(
                        UNIX_TIMESTAMP(t1.time) - UNIX_TIMESTAMP(t1.time) mod 5
                    )
                    and t3.rssi = t1.rssi
                    and t3.visitor_id = t1.visitor_id
                ORDER BY
                    RAND()
            ) AS vipVisitorDataWithMaxRssi
        GROUP by
            FROM_UNIXTIME(
                UNIX_TIMESTAMP(vipVisitorDataWithMaxRssi.time) - UNIX_TIMESTAMP(vipVisitorDataWithMaxRssi.time) mod 5
            ),
            visitor_id
    ) as r2 on r1.id = r2.id
    and r2.time5 = FROM_UNIXTIME(
        UNIX_TIMESTAMP(r1.time) - UNIX_TIMESTAMP(r1.time) mod 5
    )
    and r1.visitor_id = r2.visitor_id
    and r1.rssi = r2.rssi
WHERE
    NOT EXISTS(
        SELECT
            id
        FROM
            `vipvisitorsdata` t2
        WHERE
            t2.id = r1.id
    )
ORDER BY
    r1.time ASC;END$$

DROP PROCEDURE IF EXISTS `proc_cursor_to_loopAndInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_cursor_to_loopAndInsert` ()  BEGIN
 DECLARE CURSOR_TIME_IN INT;
 DECLARE CURSOR_ID INT;
  DECLARE CURSOR_TIME_OUT DATE;
   DECLARE done INT DEFAULT FALSE;
DECLARE i INT DEFAULT 0;
DECLARE cursor_studentEnrollDate CURSOR FOR SELECT id,time_in,time_out FROM `beacon_data_test`;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET i=0;
 OPEN cursor_studentEnrollDate;
  loop_through_rows:LOOP
    FETCH cursor_studentEnrollDate INTO CURSOR_ID,CURSOR_TIME_IN,CURSOR_TIME_OUT;
    IF CURSOR_TIME_OUT IS NULL THEN
        SET i = i + 1; 
    END IF;
    IF done THEN
      LEAVE loop_through_rows;
    END IF;
    INSERT INTO `beacon_data_test`(id,time_in,time_out,counter) VALUES(CURSOR_ID,CURSOR_TIME_IN,CURSOR_TIME_OUT,i);
  END LOOP;
  CLOSE cursor_studentEnrollDate;
End$$

DROP PROCEDURE IF EXISTS `UpdateVipCounter`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateVipCounter` ()  BEGIN
UPDATE vipvisitorscounter SET vipVisitorsCount = (Select count(*) from visitorids where isVIP = 1);
SELECT vipVisitorsCount AS new_vipVisitorsCount FROM vipvisitorscounter;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `beacon_data_test`
--

DROP TABLE IF EXISTS `beacon_data_test`;
CREATE TABLE `beacon_data_test` (
  `id` int(20) NOT NULL,
  `time_in` datetime DEFAULT NULL,
  `time_out` datetime DEFAULT NULL,
  `rssi` int(10) DEFAULT NULL,
  `visitor_id` varchar(100) NOT NULL,
  `sensor_id` varchar(100) NOT NULL,
  `counter` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `beacon_data_test`
--

INSERT INTO `beacon_data_test` (`id`, `time_in`, `time_out`, `rssi`, `visitor_id`, `sensor_id`, `counter`) VALUES
(1, '2021-09-08 19:12:04', NULL, NULL, '1', '1', 0),
(2, '2021-09-08 19:17:04', NULL, NULL, '1', '1', 0),
(5, '2021-09-08 19:22:04', NULL, NULL, '1', '1', 0),
(6, '2021-09-08 19:27:04', NULL, NULL, '1', '1', 0),
(7, NULL, '2021-09-08 19:32:04', NULL, '1', '1', 0),
(8, '2021-09-08 19:37:04', NULL, NULL, '1', '3', 1),
(9, NULL, '2021-09-08 19:42:04', NULL, '1', '3', 1),
(10, '2021-09-08 19:14:51', NULL, NULL, '2', '1', 14),
(11, '2021-09-08 19:17:19', NULL, NULL, '2', '1', 14),
(12, NULL, '2021-09-08 19:20:51', NULL, '2', '1', 14),
(13, '2021-09-12 14:33:41', NULL, NULL, '3', '2', 22),
(14, NULL, '2021-09-12 14:36:41', NULL, '3', '2', 22),
(15, '2021-09-12 13:33:41', NULL, NULL, '5', '2', 28),
(16, NULL, '2021-09-12 13:38:41', NULL, '5', '2', 28),
(17, '2021-09-12 15:33:41', NULL, NULL, '5', '4', 29),
(18, NULL, '2021-09-12 15:46:41', NULL, '5', '4', 29),
(19, '2021-09-12 16:30:41', NULL, NULL, '10', '3', 5),
(20, NULL, '2021-09-12 16:36:41', NULL, '10', '3', 5),
(21, '2021-09-12 16:40:41', NULL, NULL, '10', '5', 6),
(22, NULL, '2021-09-12 16:46:41', NULL, '10', '5', 6),
(23, '2021-09-12 17:12:41', NULL, NULL, '4', '1', 26),
(24, NULL, '2021-09-12 17:18:41', NULL, '4', '1', 26),
(25, '2021-09-12 13:49:41', NULL, NULL, '20', '3', 18),
(26, NULL, '2021-09-12 13:54:41', NULL, '20', '3', 18),
(27, '2021-09-12 14:17:41', NULL, NULL, '20', '4', 19),
(28, NULL, '2021-09-12 14:22:41', NULL, '20', '4', 19),
(29, '2021-09-12 19:40:41', NULL, NULL, '15', '3', 12),
(30, NULL, '2021-09-12 19:55:41', NULL, '15', '3', 12),
(31, '2021-09-12 16:40:41', NULL, NULL, '7', '9', 34),
(32, NULL, '2021-09-12 16:46:41', NULL, '7', '9', 34),
(33, '2021-09-12 20:12:41', NULL, NULL, '66', '1', 32),
(34, NULL, '2021-09-12 20:18:41', NULL, '66', '1', 32),
(35, '2021-10-02 19:30:05', NULL, NULL, '2', '4', 15),
(36, '2021-10-02 19:31:28', NULL, NULL, '3', '1', 23),
(37, NULL, '2021-10-02 19:32:54', NULL, '2', '4', 15),
(38, NULL, '2021-10-02 19:34:05', NULL, '3', '1', 23),
(39, '2021-10-03 18:26:21', NULL, NULL, '7', '1', 35),
(40, '2021-10-03 18:26:21', NULL, NULL, '9', '1', 38),
(41, '2021-10-03 18:26:21', NULL, NULL, '12', '1', 8),
(42, '2021-10-03 18:26:21', NULL, NULL, '14', '1', 10),
(43, NULL, '2021-10-03 18:35:21', NULL, '7', '1', 35),
(44, NULL, '2021-10-03 18:35:21', NULL, '9', '1', 38),
(45, NULL, '2021-10-03 18:35:21', NULL, '12', '1', 8),
(46, NULL, '2021-10-03 18:35:21', NULL, '14', '1', 10),
(48, '2021-09-08 19:43:53', NULL, NULL, '1', '2', 2),
(49, NULL, '2021-09-08 19:44:53', NULL, '1', '2', 2),
(50, NULL, '2021-09-08 19:46:53', NULL, '1', '0', 3),
(51, NULL, '2021-09-12 16:47:40', NULL, '10', '0', 7),
(52, NULL, '2021-10-03 18:36:40', NULL, '12', '0', 9),
(53, NULL, '2021-10-03 18:36:40', NULL, '14', '0', 11),
(54, NULL, '2021-09-12 19:57:40', NULL, '15', '0', 13),
(55, NULL, '2021-10-02 19:35:40', NULL, '2', '0', 16),
(56, NULL, '2021-10-03 18:36:40', NULL, '7', '0', 36),
(57, NULL, '2021-10-03 18:36:40', NULL, '9', '0', 39),
(58, NULL, '2021-09-12 14:24:40', NULL, '20', '0', 20),
(59, NULL, '2021-10-02 19:36:40', NULL, '3', '0', 24),
(60, NULL, '2021-09-12 15:48:40', NULL, '5', '0', 30),
(61, NULL, '2021-09-08 19:27:40', NULL, '2', '0', 17),
(62, NULL, '2021-09-12 14:37:40', NULL, '3', '0', 25),
(63, NULL, '2021-09-12 17:20:40', NULL, '4', '0', 27),
(64, NULL, '2021-09-12 20:20:40', NULL, '66', '0', 33),
(65, NULL, '2021-09-12 16:47:40', NULL, '7', '0', 37),
(66, '2021-09-08 19:44:57', NULL, NULL, '1', '1', 4),
(67, NULL, '2021-09-08 19:45:57', NULL, '1', '1', 4),
(68, '2021-09-12 14:22:47', NULL, NULL, '20', '3', 21),
(69, NULL, '2021-09-12 14:23:47', NULL, '20', '3', 21),
(70, '2021-09-12 15:46:47', NULL, NULL, '5', '2', 31),
(71, NULL, '2021-09-12 15:47:47', NULL, '5', '2', 31);

-- --------------------------------------------------------

--
-- Table structure for table `heatmap_data`
--

DROP TABLE IF EXISTS `heatmap_data`;
CREATE TABLE `heatmap_data` (
  `id` int(11) NOT NULL,
  `height` varchar(50) NOT NULL,
  `width` varchar(50) NOT NULL,
  `time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `heatmap_data`
--

INSERT INTO `heatmap_data` (`id`, `height`, `width`, `time`) VALUES
(1, '0', '0', '2021-08-19 17:55:36'),
(3, '120', '100', '2021-08-20 16:57:50'),
(4, '140', '50', '2021-08-20 16:57:50'),
(5, '120', '100', '2021-08-20 16:57:50'),
(6, '140', '50', '2021-08-20 16:57:50'),
(7, '40', '50', '2021-08-20 16:58:45'),
(8, '40', '50', '2021-08-20 16:58:45'),
(9, '40', '70', '2021-08-20 16:57:45'),
(10, '50', '60', '2021-08-20 16:56:45'),
(11, '60', '50', '2021-08-20 16:55:45'),
(12, '70', '40', '2021-08-20 16:54:45'),
(13, '80', '30', '2021-08-20 16:53:45'),
(14, '90', '20', '2021-08-20 16:52:45'),
(15, '90', '90', '2021-08-20 16:51:45'),
(16, '80', '80', '2021-08-20 16:50:45'),
(17, '70', '70', '2021-08-20 16:48:45'),
(18, '60', '60', '2021-08-20 16:38:45'),
(19, '50', '50', '2021-08-20 16:28:45'),
(20, '40', '40', '2021-08-20 16:18:45'),
(21, '30', '30', '2021-08-20 16:08:45'),
(22, '20', '20', '2021-08-20 15:58:45');

-- --------------------------------------------------------

--
-- Table structure for table `mock_data`
--

DROP TABLE IF EXISTS `mock_data`;
CREATE TABLE `mock_data` (
  `id` int(20) NOT NULL,
  `time` datetime DEFAULT NULL,
  `rssi` int(10) DEFAULT NULL,
  `visitor_id` varchar(100) NOT NULL,
  `sensor_id` varchar(100) NOT NULL,
  `counter` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mock_data`
--

INSERT INTO `mock_data` (`id`, `time`, `rssi`, `visitor_id`, `sensor_id`, `counter`) VALUES
(1, '2022-04-02 18:08:47', -65, '1', '1', NULL),
(2, '2022-04-02 18:08:49', -65, '1', '2', NULL),
(3, '2022-04-02 18:08:52', -70, '1', '1', NULL),
(4, '2022-04-02 18:08:54', -85, '1', '2', NULL),
(5, '2022-04-02 18:08:57', -74, '1', '1', NULL),
(6, '2022-04-02 18:08:59', -75, '1', '2', NULL),
(7, '2022-04-02 18:09:02', -84, '1', '1', NULL),
(8, '2022-04-02 18:09:04', -74, '1', '2', NULL),
(9, '2022-04-02 18:09:07', -90, '1', '1', NULL),
(10, '2022-04-02 18:09:09', -65, '1', '2', NULL),
(11, '2022-04-02 18:09:12', -79, '1', '1', NULL),
(12, '2022-04-02 18:09:14', -74, '1', '2', NULL),
(13, '2022-04-02 18:09:17', -75, '1', '1', NULL),
(14, '2022-04-02 18:09:19', -85, '1', '2', NULL),
(15, '2022-04-02 18:08:46', -65, '1', '3', NULL),
(16, '2022-04-02 18:08:51', -110, '1', '3', NULL),
(17, '2022-04-02 18:08:56', -50, '1', '3', NULL),
(18, '2022-04-02 18:09:01', -95, '1', '3', NULL),
(19, '2022-04-02 18:09:06', -90, '1', '3', NULL),
(21, '2022-04-02 18:09:16', -60, '1', '3', NULL),
(22, '2022-04-02 18:09:11', -70, '1', '3', NULL),
(23, '2022-04-02 18:09:23', -82, '1', '4', NULL),
(24, '2022-04-06 20:37:37', -65, '2', '1', NULL),
(25, '2022-04-06 20:37:39', -70, '2', '2', NULL),
(26, '2022-04-06 20:37:42', -90, '2', '1', NULL),
(27, '2022-04-06 20:37:44', -75, '2', '2', NULL),
(28, '2022-04-06 20:37:47', -95, '2', '1', NULL),
(29, '2022-04-06 20:37:49', -85, '2', '2', NULL),
(30, '2022-04-06 20:37:52', -65, '3', '1', NULL),
(31, '2022-04-06 20:37:54', -69, '3', '2', NULL),
(32, '2022-04-06 20:37:51', -78, '3', '3', NULL),
(33, '2022-04-06 20:37:57', -75, '3', '1', NULL),
(34, '2022-04-06 20:37:59', -85, '3', '2', NULL),
(35, '2022-04-06 20:37:56', -68, '3', '3', NULL),
(36, '2022-04-02 18:08:46', -70, '2', '3', NULL),
(37, '2022-04-02 18:08:47', -60, '2', '1', NULL),
(38, '2022-04-02 18:08:49', -65, '2', '2', NULL),
(39, '2022-07-10 18:59:00', -60, '2', '2', NULL),
(40, '2022-07-10 18:59:02', -70, '2', '3', NULL),
(41, '2022-07-10 18:59:03', -80, '2', '1', NULL),
(42, '2022-07-10 18:01:41', -60, '3', '1', NULL),
(43, '2022-07-10 18:01:42', -65, '3', '2', NULL),
(44, '2022-07-10 18:01:43', -70, '3', '3', NULL),
(45, '2022-07-10 18:04:41', -60, '2', '1', NULL),
(46, '2022-07-10 18:04:42', -65, '2', '2', NULL),
(47, '2022-07-10 18:04:43', -70, '2', '3', NULL),
(48, '2022-07-10 19:06:41', -60, '3', '1', NULL),
(49, '2022-07-10 19:06:42', -65, '3', '2', NULL),
(50, '2022-07-10 19:06:43', -70, '3', '3', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `revisitability`
--

DROP TABLE IF EXISTS `revisitability`;
CREATE TABLE `revisitability` (
  `visitor_id` varchar(100) NOT NULL,
  `sensor_id` varchar(100) NOT NULL,
  `revisitability_counter` bigint(22) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `revisitability`
--

INSERT INTO `revisitability` (`visitor_id`, `sensor_id`, `revisitability_counter`) VALUES
('1', '0', 0),
('1', '1', 1),
('1', '2', 0),
('1', '3', 0),
('10', '0', 0),
('10', '3', 0),
('10', '5', 0),
('12', '0', 0),
('12', '1', 0),
('14', '0', 0),
('14', '1', 0),
('15', '0', 0),
('15', '3', 0),
('2', '0', 0),
('2', '0', 0),
('2', '1', 0),
('2', '4', 0),
('20', '0', 0),
('20', '3', 1),
('20', '4', 0),
('3', '0', 0),
('3', '0', 0),
('3', '1', 0),
('3', '2', 0),
('4', '0', 0),
('4', '1', 0),
('5', '0', 0),
('5', '2', 1),
('5', '4', 0),
('66', '0', 0),
('66', '1', 0),
('7', '0', 0),
('7', '0', 0),
('7', '1', 0),
('7', '9', 0),
('9', '0', 0),
('9', '1', 0);

-- --------------------------------------------------------

--
-- Table structure for table `times`
--

DROP TABLE IF EXISTS `times`;
CREATE TABLE `times` (
  `id` int(20) NOT NULL DEFAULT 0,
  `time_in` datetime DEFAULT NULL,
  `time_out` datetime DEFAULT NULL,
  `visitor_id` varchar(100) NOT NULL,
  `sensor_id` varchar(100) NOT NULL,
  `path` varchar(250) DEFAULT NULL,
  `counter` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `times`
--

INSERT INTO `times` (`id`, `time_in`, `time_out`, `visitor_id`, `sensor_id`, `path`, `counter`) VALUES
(50, NULL, '2021-09-08 19:46:53', '1', '0', '', 0),
(66, '2021-09-08 19:44:57', '2021-09-08 19:45:57', '1', '1', '1,3,2,1', 0),
(1, '2021-09-08 19:12:04', '2021-09-08 19:32:04', '1', '1', '1', 0),
(48, '2021-09-08 19:43:53', '2021-09-08 19:44:53', '1', '2', '1,3,2', 0),
(8, '2021-09-08 19:37:04', '2021-09-08 19:42:04', '1', '3', '1,3', 0),
(51, NULL, '2021-09-12 16:47:40', '10', '0', '', 1),
(19, '2021-09-12 16:30:41', '2021-09-12 16:36:41', '10', '3', '3', 1),
(21, '2021-09-12 16:40:41', '2021-09-12 16:46:41', '10', '5', '3,5', 1),
(52, NULL, '2021-10-03 18:36:40', '12', '0', '', 2),
(41, '2021-10-03 18:26:21', '2021-10-03 18:35:21', '12', '1', '1', 2),
(53, NULL, '2021-10-03 18:36:40', '14', '0', '', 3),
(42, '2021-10-03 18:26:21', '2021-10-03 18:35:21', '14', '1', '1', 3),
(54, NULL, '2021-09-12 19:57:40', '15', '0', '', 4),
(29, '2021-09-12 19:40:41', '2021-09-12 19:55:41', '15', '3', '3', 4),
(55, NULL, '2021-10-02 19:35:40', '2', '0', '', 6),
(61, NULL, '2021-09-08 19:27:40', '2', '0', '', 5),
(10, '2021-09-08 19:14:51', '2021-09-08 19:20:51', '2', '1', '1', 5),
(35, '2021-10-02 19:30:05', '2021-10-02 19:32:54', '2', '4', '4', 6),
(58, NULL, '2021-09-12 14:24:40', '20', '0', '', 7),
(68, '2021-09-12 14:22:47', '2021-09-12 14:23:47', '20', '3', '3,4,3', 7),
(25, '2021-09-12 13:49:41', '2021-09-12 13:54:41', '20', '3', '3', 7),
(27, '2021-09-12 14:17:41', '2021-09-12 14:22:41', '20', '4', '3,4', 7),
(59, NULL, '2021-10-02 19:36:40', '3', '0', '', 9),
(62, NULL, '2021-09-12 14:37:40', '3', '0', '', 8),
(36, '2021-10-02 19:31:28', '2021-10-02 19:34:05', '3', '1', '1', 9),
(13, '2021-09-12 14:33:41', '2021-09-12 14:36:41', '3', '2', '2', 8),
(63, NULL, '2021-09-12 17:20:40', '4', '0', '', 10),
(23, '2021-09-12 17:12:41', '2021-09-12 17:18:41', '4', '1', '1', 10),
(60, NULL, '2021-09-12 15:48:40', '5', '0', '', 11),
(70, '2021-09-12 15:46:47', '2021-09-12 15:47:47', '5', '2', '2,4,2', 11),
(15, '2021-09-12 13:33:41', '2021-09-12 13:38:41', '5', '2', '2', 11),
(17, '2021-09-12 15:33:41', '2021-09-12 15:46:41', '5', '4', '2,4', 11),
(64, NULL, '2021-09-12 20:20:40', '66', '0', '', 12),
(33, '2021-09-12 20:12:41', '2021-09-12 20:18:41', '66', '1', '1', 12),
(56, NULL, '2021-10-03 18:36:40', '7', '0', '', 14),
(65, NULL, '2021-09-12 16:47:40', '7', '0', '', 13),
(39, '2021-10-03 18:26:21', '2021-10-03 18:35:21', '7', '1', '1', 14),
(31, '2021-09-12 16:40:41', '2021-09-12 16:46:41', '7', '9', '9', 13),
(57, NULL, '2021-10-03 18:36:40', '9', '0', '', 15),
(40, '2021-10-03 18:26:21', '2021-10-03 18:35:21', '9', '1', '1', 15);

-- --------------------------------------------------------

--
-- Table structure for table `tracksystem`
--

DROP TABLE IF EXISTS `tracksystem`;
CREATE TABLE `tracksystem` (
  `fileid` text NOT NULL,
  `floorplan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `createdAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tracksystem`
--

INSERT INTO `tracksystem` (`fileid`, `floorplan`, `createdAt`) VALUES
('Test', '{ \"class\": \"GraphLinksModel\",\n  \"modelData\": {\"units\":\"centimeters\", \"unitsAbbreviation\":\"cm\", \"unitsConversionFactor\":2, \"gridSize\":10, \"wallThickness\":5, \"preferences\":{\"showWallGuidelines\":true, \"showWallLengths\":true, \"showWallAngles\":true, \"showOnlySmallWallAngles\":true, \"showGrid\":true, \"gridSnap\":true}},\n  \"nodeDataArray\": [ \n{\"key\":\"Alonzo\", \"src\":\"50x40\", \"loc\":{\"class\":\"go.Point\", \"x\":220, \"y\":130}, \"color\":2},\n{\"key\":\"Coricopat\", \"src\":\"55x55\", \"loc\":{\"class\":\"go.Point\", \"x\":420, \"y\":250}, \"color\":4},\n{\"key\":\"Garfield\", \"src\":\"60x90\", \"loc\":{\"class\":\"go.Point\", \"x\":640, \"y\":450}, \"color\":6},\n{\"key\":\"Demeter\", \"src\":\"80x50\", \"loc\":\"-320 50\", \"color\":8},\n{\"key\":\"armChair\", \"color\":\"#ffffff\", \"stroke\":\"#000000\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":251, \"height\":167, \"notes\":\"\", \"loc\":\"-253 -89\"}\n ],\n  \"linkDataArray\": []}', NULL),
('Demo', '{ \"class\": \"GraphLinksModel\",\n  \"modelData\": {\"units\":\"centimeters\", \"unitsAbbreviation\":\"cm\", \"unitsConversionFactor\":2, \"gridSize\":10, \"wallWidth\":5, \"preferences\":{\"showWallGuidelines\":true, \"showWallLengths\":true, \"showWallAngles\":true, \"showOnlySmallWallAngles\":true, \"showGrid\":true, \"gridSnap\":true}, \"wallThickness\":1},\n  \"nodeDataArray\": [ \n{\"key\":\"wall2\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-1100, \"y\":-670}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-30, \"y\":-670}, \"thickness\":1, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall3\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-1100, \"y\":-320}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-30, \"y\":-330}, \"thickness\":1, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall4\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-30, \"y\":-330}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-30, \"y\":-670}, \"thickness\":1, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall5\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-1100, \"y\":-310}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-1100, \"y\":-670}, \"thickness\":1, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall6\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-760, \"y\":-670}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-760, \"y\":-480}, \"thickness\":1, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall7\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-300, \"y\":-330}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-300, \"y\":-500}, \"thickness\":1, \"isGroup\":true, \"notes\":\"\"},\n{\"category\":\"WindowNode\", \"key\":\"window\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":1, \"length\":60, \"notes\":\"\", \"loc\":\"-931.9866375545852 -321.57021834061135\", \"group\":\"wall3\", \"angle\":359.46454101443544},\n{\"category\":\"WindowNode\", \"key\":\"window2\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":1, \"length\":60, \"notes\":\"\", \"loc\":\"-532.0028820960697 -325.308384279476\", \"group\":\"wall3\", \"angle\":359.46454101443544},\n{\"category\":\"WindowNode\", \"key\":\"window3\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"-150 -326\"},\n{\"category\":\"WindowNode\", \"key\":\"window4\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":1, \"length\":60, \"notes\":\"\", \"loc\":\"-941 -670\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window5\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":1, \"length\":60, \"notes\":\"\", \"loc\":\"-551 -670\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window6\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":1, \"length\":60, \"notes\":\"\", \"loc\":\"-145 -670\", \"group\":\"wall2\"},\n{\"key\":\"door\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":1, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"-1100 -578\", \"group\":\"wall5\", \"angle\":270},\n{\"key\":\"door2\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":1, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"-30 -439\", \"group\":\"wall4\", \"angle\":270},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode\", \"caption\":\"Multi Purpose Node\", \"color\":\"#ffffff\", \"stroke\":\"#000000\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"R1\", \"width\":60, \"height\":60, \"notes\":\"\", \"loc\":\"-930 -480\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode2\", \"caption\":\"Multi Purpose Node\", \"color\":\"#ffffff\", \"stroke\":\"#000000\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"R2\", \"width\":60, \"height\":60, \"notes\":\"\", \"loc\":\"-540 -480\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode22\", \"caption\":\"R3\", \"color\":\"#ffffff\", \"stroke\":\"#000000\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"R3\", \"width\":60, \"height\":60, \"notes\":\"\", \"loc\":\"-160 -490\"}\n ],\n  \"linkDataArray\": []}', NULL),
('τζαμί τσισδαράκη', '{ \"class\": \"GraphLinksModel\",\n  \"modelData\": {\"units\":\"centimeters\", \"unitsAbbreviation\":\"cm\", \"unitsConversionFactor\":2, \"gridSize\":10, \"wallWidth\":5, \"preferences\":{\"showWallGuidelines\":true, \"showWallLengths\":true, \"showWallAngles\":true, \"showOnlySmallWallAngles\":true, \"showGrid\":true, \"gridSnap\":true}, \"wallThickness\":5},\n  \"nodeDataArray\": [ \n{\"key\":\"wall\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-200, \"y\":-340}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-200, \"y\":190}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall2\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-198.25, \"y\":190}, \"endpoint\":{\"class\":\"go.Point\", \"x\":318.25, \"y\":190}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall3\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":320, \"y\":-340}, \"endpoint\":{\"class\":\"go.Point\", \"x\":320, \"y\":190}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall22\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-198.25, \"y\":-340}, \"endpoint\":{\"class\":\"go.Point\", \"x\":318.25, \"y\":-340}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"door\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"-200 -107\", \"group\":\"wall\", \"angle\":90},\n{\"key\":\"door2\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"right\", \"notes\":\"\", \"loc\":\"-200 -67\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode\", \"caption\":\"ΤΖ.0.1.Κ1\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ1\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"-70 -310\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode2\", \"caption\":\"ΤΖ.0.1.Κ2\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ2\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"45.5 -310\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode3\", \"caption\":\"ΤΖ.0.1.Κ9\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ9\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"-70 160\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode4\", \"caption\":\"ΤΖ.0.1.Κ4\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ4\", \"width\":85, \"height\":35, \"notes\":\"\", \"loc\":\"40 -180\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode5\", \"caption\":\"ΤΖ.0.1.Κ6\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ6\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"250 160\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode6\", \"caption\":\"ΤΖ.0.1.Κ8\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ8\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"40 160\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode7\", \"caption\":\"ΤΖ.0.1.Κ7\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ7\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"140 160\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode8\", \"caption\":\"ΤΖ.0.1.Κ3\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ3\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"160 -310\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode42\", \"caption\":\"ΤΖ.0.1.Κ5\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ5\", \"width\":85, \"height\":35, \"notes\":\"\", \"loc\":\"40 0\"},\n{\"category\":\"WindowNode\", \"key\":\"window\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-71 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window2\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-149.20000000000005 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window3\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"45.582500000000095 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window4\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"139.83500000000004 190\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window5\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"159.81500000000017 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window6\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"263.6800000000002 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window7\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-69.10250000000008 190\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window8\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"250.57000000000016 190\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window9\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"40.64250000000004 190\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window10\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-200 110.96000000000006\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"WindowNode\", \"key\":\"window11\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-200 17.512500000000045\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"WindowNode\", \"key\":\"window12\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-200 -198.9425\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"WindowNode\", \"key\":\"window13\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-200 -285.19750000000005\", \"group\":\"wall\", \"angle\":90},\n{\"key\":\"door3\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"right\", \"notes\":\"\", \"loc\":\"320 110.23000000000002\", \"angle\":90, \"group\":\"wall3\"}\n ],\n  \"linkDataArray\": []}', '2021-07-11 17:11:27'),
('asfa', '{ \"class\": \"GraphLinksModel\",\n  \"modelData\": {\"units\":\"centimeters\", \"unitsAbbreviation\":\"cm\", \"unitsConversionFactor\":2, \"gridSize\":10, \"wallThickness\":5, \"preferences\":{\"showWallGuidelines\":true, \"showWallLengths\":true, \"showWallAngles\":true, \"showOnlySmallWallAngles\":true, \"showGrid\":true, \"gridSnap\":true}},\n  \"nodeDataArray\": [ \n{\"key\":\"wall\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-430, \"y\":240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-430, \"y\":-240}, \"thickness\":10, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall3\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-430, \"y\":-240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":260, \"y\":-240}, \"thickness\":10, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall4\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":260, \"y\":-240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":260, \"y\":240}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall5\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":260, \"y\":140}, \"endpoint\":{\"class\":\"go.Point\", \"x\":550, \"y\":140}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall6\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":260, \"y\":240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":390, \"y\":240}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall7\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":550, \"y\":140}, \"endpoint\":{\"class\":\"go.Point\", \"x\":550, \"y\":400}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall8\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":390, \"y\":240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":390, \"y\":400}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall9\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":390, \"y\":400}, \"endpoint\":{\"class\":\"go.Point\", \"x\":550, \"y\":400}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"staircase\", \"color\":\"#ffffff\", \"stroke\":\"#000000\", \"caption\":\"Staircase\", \"type\":\"Staircase\", \"geo\":\"F1 M0 0 L 0 100 250 100 250 0 0 0 M25 100 L 25 0 M 50 100 L 50 0 M 75 100 L 75 0 M 100 100 L 100 0 M 125 100 L 125 0 M 150 100 L 150 0 M 175 100 L 175 0 M 200 100 L 200 0 M 225 100 L 225 0\", \"width\":125, \"height\":50, \"notes\":\"\", \"loc\":\"430 330\", \"angle\":270},\n{\"key\":\"staircase2\", \"color\":\"#ffffff\", \"stroke\":\"#000000\", \"caption\":\"Staircase\", \"type\":\"Staircase\", \"geo\":\"F1 M0 0 L 0 100 250 100 250 0 0 0 M25 100 L 25 0 M 50 100 L 50 0 M 75 100 L 75 0 M 100 100 L 100 0 M 125 100 L 125 0 M 150 100 L 150 0 M 175 100 L 175 0 M 200 100 L 200 0 M 225 100 L 225 0\", \"width\":125, \"height\":50, \"notes\":\"\", \"loc\":\"500 330\", \"angle\":270},\n{\"key\":\"wall10\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-230, \"y\":-130}, \"endpoint\":{\"class\":\"go.Point\", \"x\":70, \"y\":-130}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall11\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":70, \"y\":-130}, \"endpoint\":{\"class\":\"go.Point\", \"x\":130, \"y\":-70}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall12\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":130, \"y\":-70}, \"endpoint\":{\"class\":\"go.Point\", \"x\":130, \"y\":40}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall13\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":130, \"y\":40}, \"endpoint\":{\"class\":\"go.Point\", \"x\":70, \"y\":100}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall14\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":70, \"y\":100}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-230, \"y\":100}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall15\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-230, \"y\":-130}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-290, \"y\":-70}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall16\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-290, \"y\":-70}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-290, \"y\":40}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall17\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-290, \"y\":40}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-230, \"y\":100}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"door\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":56, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"260 188.20000076293945\", \"group\":\"wall4\", \"angle\":90},\n{\"key\":\"diningTable\", \"color\":\"#704332\", \"stroke\":\"#8FBCCD\", \"caption\":\"Dining Table\", \"type\":\"Dining Table\", \"geo\":\"F1 M 0 0 L 0 100 200 100 200 0 0 0 M 25 0 L 25 -10 75 -10 75 0 M 125 0 L 125 -10 175 -10 175 0 M 200 25 L 210 25 210 75 200 75 M 125 100 L 125 110 L 175 110 L 175 100 M 25 100 L 25 110 75 110 75 100 M 0 75 -10 75 -10 25 0 25\", \"width\":205, \"height\":70.5, \"notes\":\"\", \"loc\":\"-80 -20\"},\n{\"key\":\"wall18\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":550, \"y\":-240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":550, \"y\":140}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall19\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":260, \"y\":-240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":310, \"y\":-310}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall20\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":310, \"y\":-310}, \"endpoint\":{\"class\":\"go.Point\", \"x\":500, \"y\":-310}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall21\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":500, \"y\":-310}, \"endpoint\":{\"class\":\"go.Point\", \"x\":550, \"y\":-240}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"door2\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"-290 5.200000762939453\", \"group\":\"wall16\", \"angle\":90},\n{\"category\":\"WindowNode\", \"key\":\"window\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":230, \"notes\":\"\", \"loc\":\"-80.80000019073492 -130.00000000000006\", \"group\":\"wall10\"},\n{\"category\":\"WindowNode\", \"key\":\"window2\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":230, \"notes\":\"\", \"loc\":\"-80.80000019073492 100.00000000000003\", \"group\":\"wall14\", \"angle\":180},\n{\"category\":\"WindowNode\", \"key\":\"window3\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"-400 -240\", \"group\":\"wall3\"},\n{\"category\":\"WindowNode\", \"key\":\"window32\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"-234.80000019073486 -240\", \"group\":\"wall3\"},\n{\"category\":\"WindowNode\", \"key\":\"window4\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"-89.80000019073486 -240\", \"group\":\"wall3\"},\n{\"category\":\"WindowNode\", \"key\":\"window5\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"80.19999980926514 -240\", \"group\":\"wall3\"},\n{\"category\":\"WindowNode\", \"key\":\"window6\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"201.19999980926514 -240\", \"group\":\"wall3\"},\n{\"category\":\"WindowNode\", \"key\":\"window7\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":175, \"notes\":\"\", \"loc\":\"-430 -152.5\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"WindowNode\", \"key\":\"window8\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":233, \"notes\":\"\", \"loc\":\"-430 123.49999999999999\", \"group\":\"wall\", \"angle\":270},\n{\"key\":\"wall32\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-430, \"y\":240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":260, \"y\":240}, \"thickness\":10, \"isGroup\":true, \"notes\":\"\"},\n{\"category\":\"WindowNode\", \"key\":\"window33\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"-400 240\", \"group\":\"wall32\"},\n{\"category\":\"WindowNode\", \"key\":\"window322\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"-234.80000019073486 240\", \"group\":\"wall32\"},\n{\"category\":\"WindowNode\", \"key\":\"window42\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"-89.80000019073486 240\", \"group\":\"wall32\"},\n{\"category\":\"WindowNode\", \"key\":\"window52\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"80.19999980926514 240\", \"group\":\"wall32\"},\n{\"category\":\"WindowNode\", \"key\":\"window62\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":10, \"length\":60, \"notes\":\"\", \"loc\":\"201.19999980926514 240\", \"group\":\"wall32\"},\n{\"key\":\"wall2\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":260, \"y\":0}, \"endpoint\":{\"class\":\"go.Point\", \"x\":380, \"y\":0}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"door5\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"right\", \"notes\":\"\", \"loc\":\"-290 -34.79999923706055\", \"angle\":90, \"group\":\"wall16\"},\n{\"key\":\"door52\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"130 -37.79999923706055\", \"angle\":270, \"group\":\"wall12\"},\n{\"key\":\"door22\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"right\", \"notes\":\"\", \"loc\":\"130 2.200000762939453\", \"group\":\"wall12\", \"angle\":270},\n{\"key\":\"sink\", \"color\":\"#c0c0c0\", \"stroke\":\"#3F3F3F\", \"caption\":\"Sink\", \"type\":\"Sink\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0z M5 7.5 L18.5 7.5 M 21.5 7.5 L35 7.5 35 35 5 35 5 7.5 M 15 21.25 A 5 5 180 1 0 15 21.24 M23 3.75 A 3 3 180 1 1 23 3.74 M21.5 6.25 L 21.5 12.5 18.5 12.5 18.5 6.25 M15 3.75 A 1 1 180 1 1 15 3.74 M 10 4.25 L 10 3.25 13 3.25 M 13 4.25 L 10 4.25 M27 3.75 A 1 1 180 1 1 27 3.74 M 26.85 3.25 L 30 3.25 30 4.25 M 26.85 4.25 L 30 4.25\", \"width\":27, \"height\":27, \"notes\":\"\", \"loc\":\"361.5 110\", \"angle\":180, \"group\":-52},\n{\"key\":\"shower\", \"color\":\"#b9cece\", \"stroke\":\"#463131\", \"caption\":\"Shower/Tub\", \"type\":\"Shower/Tub\", \"geo\":\"F1 M0 0 L40 0 40 60 0 60 0 0 M35 15 L35 55 5 55 5 15 Q5 5 20 5 Q35 5 35 15 M22.5 20 A2.5 2.5 180 1 1 22.5 19.99\", \"width\":57, \"height\":109, \"notes\":\"\", \"loc\":\"296 67\", \"group\":-52},\n{\"key\":\"toilet\", \"color\":\"#f7f9e3\", \"stroke\":\"#08061C\", \"caption\":\"Toilet\", \"type\":\"Toilet\", \"geo\":\"F1 M0 0 L25 0 25 10 0 10 0 0 M20 10 L20 15 5 15 5 10 20 10 M5 15 Q0 15 0 25 Q0 40 12.5 40 Q25 40 25 25 Q25 15 20 15\", \"width\":25, \"height\":35, \"notes\":\"\", \"loc\":\"350 30\", \"group\":-52},\n{\"key\":\"wall22\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":380, \"y\":0}, \"endpoint\":{\"class\":\"go.Point\", \"x\":380, \"y\":140}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"door3\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":36, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"380 65.20000076293945\", \"group\":\"wall22\", \"angle\":270},\n{\"key\":\"wall23\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":430, \"y\":0}, \"endpoint\":{\"class\":\"go.Point\", \"x\":550, \"y\":0}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall24\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":430, \"y\":0}, \"endpoint\":{\"class\":\"go.Point\", \"x\":430, \"y\":140}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"isGroup\":true, \"key\":-52, \"caption\":\"Group\", \"notes\":\"\"},\n{\"isGroup\":true, \"key\":-53, \"caption\":\"Group\", \"notes\":\"\"},\n{\"key\":\"shower2\", \"color\":\"#b9cece\", \"stroke\":\"#463131\", \"caption\":\"Shower/Tub\", \"type\":\"Shower/Tub\", \"geo\":\"F1 M0 0 L40 0 40 60 0 60 0 0 M35 15 L35 55 5 55 5 15 Q5 5 20 5 Q35 5 35 15 M22.5 20 A2.5 2.5 180 1 1 22.5 19.99\", \"width\":57, \"height\":109, \"notes\":\"\", \"loc\":\"510 70\", \"group\":-53},\n{\"key\":\"toilet2\", \"color\":\"#f7f9e3\", \"stroke\":\"#08061C\", \"caption\":\"Toilet\", \"type\":\"Toilet\", \"geo\":\"F1 M0 0 L25 0 25 10 0 10 0 0 M20 10 L20 15 5 15 5 10 20 10 M5 15 Q0 15 0 25 Q0 40 12.5 40 Q25 40 25 25 Q25 15 20 15\", \"width\":25, \"height\":35, \"notes\":\"\", \"loc\":\"460 30\", \"group\":-53},\n{\"key\":\"sink2\", \"color\":\"#c0c0c0\", \"stroke\":\"#3F3F3F\", \"caption\":\"Sink\", \"type\":\"Sink\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0z M5 7.5 L18.5 7.5 M 21.5 7.5 L35 7.5 35 35 5 35 5 7.5 M 15 21.25 A 5 5 180 1 0 15 21.24 M23 3.75 A 3 3 180 1 1 23 3.74 M21.5 6.25 L 21.5 12.5 18.5 12.5 18.5 6.25 M15 3.75 A 1 1 180 1 1 15 3.74 M 10 4.25 L 10 3.25 13 3.25 M 13 4.25 L 10 4.25 M27 3.75 A 1 1 180 1 1 27 3.74 M 26.85 3.25 L 30 3.25 30 4.25 M 26.85 4.25 L 30 4.25\", \"width\":27, \"height\":27, \"notes\":\"\", \"loc\":\"460 112\", \"angle\":180, \"group\":-53},\n{\"key\":\"door32\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":36, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"430 69.20000076293945\", \"group\":\"wall24\", \"angle\":90},\n{\"key\":\"sofaMedium\", \"color\":\"#c6a8c5\", \"stroke\":\"#39573A\", \"caption\":\"Sofa\", \"type\":\"Sofa\", \"geo\":\"F1 M0 0 L80 0 80 40 0 40 0 0 M10 35 L10 10 M0 0 Q8 0 10 10 M0 40 Q40 15 80 40 M70 10 Q72 0 80 0 M70 10 L70 35\", \"height\":45, \"width\":90, \"notes\":\"\", \"loc\":\"320 -40\"},\n{\"key\":\"sofaMedium2\", \"color\":\"#c6a8c5\", \"stroke\":\"#39573A\", \"caption\":\"Sofa\", \"type\":\"Sofa\", \"geo\":\"F1 M0 0 L80 0 80 40 0 40 0 0 M10 35 L10 10 M0 0 Q8 0 10 10 M0 40 Q40 15 80 40 M70 10 Q72 0 80 0 M70 10 L70 35\", \"height\":45, \"width\":90, \"notes\":\"\", \"loc\":\"490 -40\"},\n{\"key\":\"roundTable\", \"color\":\"#dadada\", \"stroke\":\"#252525\", \"caption\":\"Round Table\", \"type\":\"Round Table\", \"shape\":\"Ellipse\", \"width\":61, \"height\":61, \"notes\":\"\", \"loc\":\"410 -170\", \"group\":-74},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode\", \"caption\":\"Multi Purpose Node\", \"color\":\"#ffffff\", \"stroke\":\"#000000\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Fridge\", \"width\":55, \"height\":40, \"notes\":\"\", \"loc\":\"342.5 -287.5\"},\n{\"key\":\"doubleSink\", \"color\":\"#d9d9d9\", \"stroke\":\"#262626\", \"caption\":\"Double Sink\", \"type\":\"Double Sink\", \"geo\":\"F1 M0 0 L75 0 75 40 0 40 0 0 M5 7.5 L35 7.5 35 35 5 35 5 7.5 M44 7.5 L70 7.5 70 35 40 35 40 9 M15 21.25 A5 5 180 1 0 15 21.24 M50 21.25 A 5 5 180 1 0 50 21.24 M40.5 3.75 A3 3 180 1 1 40.5 3.74 M40.5 3.75 L50.5 13.75 47.5 16.5 37.5 6.75 M32.5 3.75 A 1 1 180 1 1 32.5 3.74 M 27.5 4.25 L 27.5 3.25 30.5 3.25 M 30.5 4.25 L 27.5 4.25 M44.5 3.75 A 1 1 180 1 1 44.5 3.74 M 44.35 3.25 L 47.5 3.25 47.5 4.25 M 44.35 4.25 L 47.5 4.25\", \"height\":27, \"width\":52, \"notes\":\"\", \"loc\":\"510 -260\", \"angle\":53.07333893129521},\n{\"category\":\"WindowNode\", \"key\":\"window9\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":60, \"notes\":\"\", \"loc\":\"284.9054049801182 -274.8675669721655\", \"group\":\"wall19\", \"angle\":305.5376777919744},\n{\"category\":\"WindowNode\", \"key\":\"window10\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":60, \"notes\":\"\", \"loc\":\"522.9324327288447 -277.8945941796174\", \"group\":\"wall21\", \"angle\":234.46232220802563},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode3\", \"caption\":\"Multi Purpose Node\", \"color\":\"#f7f9e3\", \"stroke\":\"#08061C\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Fridge\", \"width\":55, \"height\":40, \"notes\":\"\", \"loc\":\"342.5 -287.5\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode32\", \"caption\":\"Multi Purpose Node\", \"color\":\"#f7f9e3\", \"stroke\":\"#08061C\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Counter\", \"width\":55, \"height\":40, \"notes\":\"\", \"loc\":\"395 -287\"},\n{\"category\":\"WindowNode\", \"key\":\"window11\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":60, \"notes\":\"\", \"loc\":\"397.19999980926514 -310\", \"group\":\"wall20\"},\n{\"key\":\"door4\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":56, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"260 -179.79999923706055\", \"group\":\"wall4\", \"angle\":90},\n{\"key\":\"stove\", \"color\":\"#f7f9e3\", \"stroke\":\"#08061C\", \"caption\":\"Stove\", \"type\":\"Stove\", \"geo\":\"F1 M 0 0 L 0 100 100 100 100 0 0 0 M 30 15 A 15 15 180 1 0 30.01 15 M 70 15 A 15 15 180 1 0 70.01 15M 30 55 A 15 15 180 1 0 30.01 55 M 70 55 A 15 15 180 1 0 70.01 55\", \"width\":55, \"height\":40, \"notes\":\"\", \"loc\":\"450.22782650708155 -288\"},\n{\"key\":\"armChair\", \"color\":\"#c0c0c0\", \"stroke\":\"#3F3F3F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":32.865, \"height\":32, \"notes\":\"\", \"loc\":\"410 -120\", \"group\":-74},\n{\"key\":\"armChair2\", \"color\":\"#c0c0c0\", \"stroke\":\"#3F3F3F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":32.865, \"height\":32, \"notes\":\"\", \"loc\":\"460 -170\", \"angle\":270, \"group\":-74},\n{\"key\":\"armChair22\", \"color\":\"#c0c0c0\", \"stroke\":\"#3F3F3F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":32.865, \"height\":32, \"notes\":\"\", \"loc\":\"410 -220\", \"angle\":180, \"group\":-74},\n{\"key\":\"armChair222\", \"color\":\"#c0c0c0\", \"stroke\":\"#3F3F3F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":32.865, \"height\":32, \"notes\":\"\", \"loc\":\"360 -170\", \"angle\":90, \"group\":-74},\n{\"isGroup\":true, \"key\":-74, \"caption\":\"Group\", \"notes\":\"\"},\n{\"key\":\"wall25\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-300, \"y\":-240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-300, \"y\":-180}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall252\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-160, \"y\":-240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-160, \"y\":-180}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall2522\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":0, \"y\":-240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":0, \"y\":-180}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall25222\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":140, \"y\":-240}, \"endpoint\":{\"class\":\"go.Point\", \"x\":140, \"y\":-180}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall253\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-300, \"y\":180}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-300, \"y\":240}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall2523\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-160, \"y\":180}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-160, \"y\":240}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall25223\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":0, \"y\":180}, \"endpoint\":{\"class\":\"go.Point\", \"x\":0, \"y\":240}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall252222\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":140, \"y\":180}, \"endpoint\":{\"class\":\"go.Point\", \"x\":140, \"y\":240}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"armChair3\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":29, \"height\":27, \"notes\":\"\", \"loc\":\"-231.93243243243245 -192.5\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode2\", \"caption\":\"Multi Purpose Node\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":116, \"height\":14, \"notes\":\"\", \"loc\":\"-232 -220\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode25\", \"caption\":\"Multi Purpose Node\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":116, \"height\":14, \"notes\":\"\", \"loc\":\"-230 221\"},\n{\"key\":\"armChair35\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":29, \"height\":27, \"notes\":\"\", \"loc\":\"-230 190\", \"angle\":180},\n{\"key\":\"armChair352\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":29, \"height\":27, \"notes\":\"\", \"loc\":\"-80 190\", \"angle\":180},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode252\", \"caption\":\"Multi Purpose Node\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":116, \"height\":14, \"notes\":\"\", \"loc\":\"-80 220\"},\n{\"key\":\"armChair353\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":29, \"height\":27, \"notes\":\"\", \"loc\":\"70 190\", \"angle\":180},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode253\", \"caption\":\"Multi Purpose Node\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":116, \"height\":14, \"notes\":\"\", \"loc\":\"70 220\"},\n{\"key\":\"armChair3532\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":29, \"height\":27, \"notes\":\"\", \"loc\":\"200 190\", \"angle\":180},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode2532\", \"caption\":\"Multi Purpose Node\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":116, \"height\":14, \"notes\":\"\", \"loc\":\"200 220\"},\n{\"key\":\"armChair32\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":29, \"height\":27, \"notes\":\"\", \"loc\":\"-80 -190\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode22\", \"caption\":\"Multi Purpose Node\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":116, \"height\":14, \"notes\":\"\", \"loc\":\"-80 -220\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode222\", \"caption\":\"Multi Purpose Node\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":116, \"height\":14, \"notes\":\"\", \"loc\":\"70 -220\"},\n{\"key\":\"armChair322\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":29, \"height\":27, \"notes\":\"\", \"loc\":\"70 -190\"},\n{\"key\":\"armChair3222\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":29, \"height\":27, \"notes\":\"\", \"loc\":\"200 -190\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode2222\", \"caption\":\"Multi Purpose Node\", \"color\":\"#e1ddd0\", \"stroke\":\"#1E222F\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":116, \"height\":14, \"notes\":\"\", \"loc\":\"200 -220\"},\n{\"key\":\"sofaMedium3\", \"color\":\"#b9fde0\", \"stroke\":\"#46021F\", \"caption\":\"Sofa\", \"type\":\"Sofa\", \"geo\":\"F1 M0 0 L80 0 80 40 0 40 0 0 M10 35 L10 10 M0 0 Q8 0 10 10 M0 40 Q40 15 80 40 M70 10 Q72 0 80 0 M70 10 L70 35\", \"height\":27, \"width\":90, \"notes\":\"\", \"loc\":\"-410 -30\", \"angle\":90},\n{\"key\":\"sofaMedium32\", \"color\":\"#b9fde0\", \"stroke\":\"#46021F\", \"caption\":\"Sofa\", \"type\":\"Sofa\", \"geo\":\"F1 M0 0 L80 0 80 40 0 40 0 0 M10 35 L10 10 M0 0 Q8 0 10 10 M0 40 Q40 15 80 40 M70 10 Q72 0 80 0 M70 10 L70 35\", \"height\":27, \"width\":90, \"notes\":\"\", \"loc\":\"240 -20\", \"angle\":270},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode4\", \"caption\":\"Multi Purpose Node\", \"color\":\"#d6b196\", \"stroke\":\"#294E69\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":60, \"height\":23, \"notes\":\"\", \"loc\":\"-381.1676743184333 -190.94449856461264\", \"angle\":137.27258112448646},\n{\"key\":\"wall26\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-300, \"y\":-180}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-380, \"y\":-100}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall27\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-380, \"y\":-100}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-430, \"y\":-100}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall28\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-300, \"y\":180}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-380, \"y\":100}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall29\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-380, \"y\":100}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-430, \"y\":100}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"armChair4\", \"color\":\"#d6b196\", \"stroke\":\"#294E69\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":21, \"height\":21, \"notes\":\"\", \"loc\":\"-400 -210\", \"angle\":135},\n{\"key\":\"roundTable2\", \"color\":\"#d6dfc8\", \"stroke\":\"#292037\", \"caption\":\"Plant\", \"type\":\"Round Table\", \"shape\":\"Ellipse\", \"width\":21, \"height\":21, \"notes\":\"\", \"loc\":\"-402.5 -116.5\", \"text\":\"Plant\"},\n{\"key\":\"armChair42\", \"color\":\"#d6b196\", \"stroke\":\"#294E69\", \"caption\":\"Arm Chair\", \"type\":\"Arm Chair\", \"geo\":\"F1 M0 0 L40 0 40 40 0 40 0 0 M10 30 L10 10 M0 0 Q8 0 10 10 M0 40 Q20 15 40 40 M30 10 Q32 0 40 0 M30 10 L30 30\", \"width\":21, \"height\":21, \"notes\":\"\", \"loc\":\"-400 210\", \"angle\":45},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode42\", \"caption\":\"Multi Purpose Node\", \"color\":\"#d6b196\", \"stroke\":\"#294E69\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"Desk\", \"width\":60, \"height\":23, \"notes\":\"\", \"loc\":\"-380 190\", \"angle\":47.002533598871146},\n{\"key\":\"roundTable22\", \"color\":\"#d6dfc8\", \"stroke\":\"#292037\", \"caption\":\"Plant\", \"type\":\"Round Table\", \"shape\":\"Ellipse\", \"width\":21, \"height\":21, \"notes\":\"\", \"loc\":\"-400 120\", \"text\":\"Plant\"},\n{\"key\":\"roundTable222\", \"color\":\"#d6dfc8\", \"stroke\":\"#292037\", \"caption\":\"Plant\", \"type\":\"Round Table\", \"shape\":\"Ellipse\", \"width\":21, \"height\":21, \"notes\":\"\", \"loc\":\"-320 200\", \"text\":\"Plant\"},\n{\"key\":\"door6\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"-334.00000047683716 -145.99999952316284\", \"group\":\"wall26\", \"angle\":315},\n{\"key\":\"door7\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"-343.7999997138977 136.2000002861023\", \"group\":\"wall28\", \"angle\":225}\n ],\n  \"linkDataArray\": []}', '2021-07-12 19:12:44');
INSERT INTO `tracksystem` (`fileid`, `floorplan`, `createdAt`) VALUES
('τζαμί τσισδαράκη 2', '{ \"class\": \"GraphLinksModel\",\n  \"modelData\": {\"units\":\"centimeters\", \"unitsAbbreviation\":\"cm\", \"unitsConversionFactor\":2, \"gridSize\":10, \"wallWidth\":5, \"preferences\":{\"showWallGuidelines\":true, \"showWallLengths\":true, \"showWallAngles\":true, \"showOnlySmallWallAngles\":true, \"showGrid\":true, \"gridSnap\":true}, \"wallThickness\":5},\n  \"nodeDataArray\": [ \n{\"key\":\"wall\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-200, \"y\":-340}, \"endpoint\":{\"class\":\"go.Point\", \"x\":-200, \"y\":190}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall2\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-198.25, \"y\":190}, \"endpoint\":{\"class\":\"go.Point\", \"x\":318.25, \"y\":190}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall3\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":320, \"y\":-340}, \"endpoint\":{\"class\":\"go.Point\", \"x\":320, \"y\":190}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"wall22\", \"category\":\"WallGroup\", \"caption\":\"Wall\", \"type\":\"Wall\", \"startpoint\":{\"class\":\"go.Point\", \"x\":-198.25, \"y\":-340}, \"endpoint\":{\"class\":\"go.Point\", \"x\":318.25, \"y\":-340}, \"thickness\":5, \"isGroup\":true, \"notes\":\"\"},\n{\"key\":\"door\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"left\", \"notes\":\"\", \"loc\":\"-200 -107\", \"group\":\"wall\", \"angle\":90},\n{\"key\":\"door2\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"right\", \"notes\":\"\", \"loc\":\"-200 -67\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode\", \"caption\":\"ΤΖ.0.1.Κ1\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ1\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"-70 -310\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode2\", \"caption\":\"ΤΖ.0.1.Κ2\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ2\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"45.5 -310\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode3\", \"caption\":\"ΤΖ.0.1.Κ9\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ9\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"-70 160\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode4\", \"caption\":\"ΤΖ.0.1.Κ4\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ4\", \"width\":85, \"height\":35, \"notes\":\"\", \"loc\":\"40 -180\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode5\", \"caption\":\"ΤΖ.0.1.Κ6\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ6\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"250 160\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode6\", \"caption\":\"ΤΖ.0.1.Κ8\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ8\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"40 160\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode7\", \"caption\":\"ΤΖ.0.1.Κ7\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ7\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"140 160\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode8\", \"caption\":\"ΤΖ.0.1.Κ3\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ3\", \"width\":50, \"height\":50, \"notes\":\"\", \"loc\":\"160 -310\"},\n{\"category\":\"MultiPurposeNode\", \"key\":\"MultiPurposeNode42\", \"caption\":\"ΤΖ.0.1.Κ5\", \"color\":\"#76a9ac\", \"stroke\":\"#895653\", \"name\":\"Writable Node\", \"type\":\"Writable Node\", \"shape\":\"Rectangle\", \"text\":\"ΤΖ.0.1.Κ5\", \"width\":85, \"height\":35, \"notes\":\"\", \"loc\":\"40 0\"},\n{\"category\":\"WindowNode\", \"key\":\"window\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-71 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window2\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-149.20000000000005 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window3\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"45.582500000000095 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window4\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"139.83500000000004 190\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window5\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"159.81500000000017 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window6\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"263.6800000000002 -340\", \"group\":\"wall22\"},\n{\"category\":\"WindowNode\", \"key\":\"window7\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-69.10250000000008 190\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window8\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"250.57000000000016 190\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window9\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"40.64250000000004 190\", \"group\":\"wall2\"},\n{\"category\":\"WindowNode\", \"key\":\"window10\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-200 110.96000000000006\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"WindowNode\", \"key\":\"window11\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-200 17.512500000000045\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"WindowNode\", \"key\":\"window12\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-200 -198.9425\", \"group\":\"wall\", \"angle\":90},\n{\"category\":\"WindowNode\", \"key\":\"window13\", \"color\":\"white\", \"caption\":\"Window\", \"type\":\"Window\", \"shape\":\"Rectangle\", \"height\":5, \"length\":50, \"notes\":\"\", \"loc\":\"-200 -285.19750000000005\", \"group\":\"wall\", \"angle\":90},\n{\"key\":\"door3\", \"category\":\"DoorNode\", \"color\":\"rgba(0, 0, 0, 0)\", \"caption\":\"Door\", \"type\":\"Door\", \"length\":40, \"doorOpeningHeight\":5, \"swing\":\"right\", \"notes\":\"\", \"loc\":\"320 110.23000000000002\", \"angle\":90, \"group\":\"wall3\"},\n{\"key\":\"roundTable\", \"color\":\"#ffffff\", \"stroke\":\"#000000\", \"caption\":\"Round Table\", \"type\":\"Round Table\", \"shape\":\"Ellipse\", \"width\":61, \"height\":61, \"notes\":\"\", \"loc\":\"40 -90\"}\n ],\n  \"linkDataArray\": []}', '2021-07-12 19:38:59');

-- --------------------------------------------------------

--
-- Table structure for table `vipvisitorscounter`
--

DROP TABLE IF EXISTS `vipvisitorscounter`;
CREATE TABLE `vipvisitorscounter` (
  `vipVisitorsCount` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vipvisitorscounter`
--

INSERT INTO `vipvisitorscounter` (`vipVisitorsCount`) VALUES
(0);

--
-- Triggers `vipvisitorscounter`
--
DROP TRIGGER IF EXISTS `Change_Event_scheduler_Status`;
DELIMITER $$
CREATE TRIGGER `Change_Event_scheduler_Status` BEFORE INSERT ON `vipvisitorscounter` FOR EACH ROW BEGIN
	IF new.vipVisitorsCount > 0 THEN
       SET GLOBAL event_scheduler = ON;
     else 
      SET GLOBAL event_scheduler = OFF;
    end IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `vipvisitorsdata`
--

DROP TABLE IF EXISTS `vipvisitorsdata`;
CREATE TABLE `vipvisitorsdata` (
  `id` int(20) NOT NULL DEFAULT 0,
  `time` datetime DEFAULT NULL,
  `rssi` int(10) DEFAULT NULL,
  `visitor_id` varchar(100) NOT NULL,
  `sensor_id` varchar(100) NOT NULL,
  `counter` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vipvisitorsdata`
--

INSERT INTO `vipvisitorsdata` (`id`, `time`, `rssi`, `visitor_id`, `sensor_id`, `counter`) VALUES
(48, '2022-07-10 19:06:41', -60, '3', '1', NULL),
(50, '2022-07-10 19:06:43', -70, '3', '3', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `visitorids`
--

DROP TABLE IF EXISTS `visitorids`;
CREATE TABLE `visitorids` (
  `id` int(20) NOT NULL,
  `isVIP` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `visitorids`
--

INSERT INTO `visitorids` (`id`, `isVIP`) VALUES
(1, b'0'),
(2, b'0'),
(3, b'1'),
(4, b'0'),
(5, b'0'),
(6, b'0'),
(7, b'0'),
(8, b'0'),
(9, b'0'),
(10, b'0'),
(11, b'0'),
(12, b'0'),
(13, b'0'),
(14, b'0'),
(30, b'0'),
(38, b'0'),
(39, b'0'),
(40, b'0'),
(42, b'0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `beacon_data_test`
--
ALTER TABLE `beacon_data_test`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `heatmap_data`
--
ALTER TABLE `heatmap_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mock_data`
--
ALTER TABLE `mock_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `visitorids`
--
ALTER TABLE `visitorids`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `beacon_data_test`
--
ALTER TABLE `beacon_data_test`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `heatmap_data`
--
ALTER TABLE `heatmap_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `mock_data`
--
ALTER TABLE `mock_data`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `visitorids`
--
ALTER TABLE `visitorids`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

DELIMITER $$
--
-- Events
--
DROP EVENT IF EXISTS `call_procedure_every_5_seconds`$$
CREATE DEFINER=`root`@`localhost` EVENT `call_procedure_every_5_seconds` ON SCHEDULE EVERY 5 SECOND STARTS '2022-06-12 20:00:48' ON COMPLETION NOT PRESERVE ENABLE DO CALL GetNewVipVisitorsData()$$

DROP EVENT IF EXISTS `call_procedure_every_10_seconds`$$
CREATE DEFINER=`root`@`localhost` EVENT `call_procedure_every_10_seconds` ON SCHEDULE EVERY 5 SECOND STARTS '2022-07-25 20:04:32' ON COMPLETION PRESERVE DISABLE DO CALL GetNewVipVisitorsData()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
