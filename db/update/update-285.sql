--	Comment
--	Previous Version = 2.8.4
--	Working Version = 2.8.5

-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Members
--

-- --------------------------------------------------------

-- 
-- 	Table structure for table `$prefix_forms`
--

ALTER TABLE `$prefix_forms` CHANGE `captcha_gc_freq` `captcha_gc_freq` INT( 11 ) NOT NULL DEFAULT '1';

ALTER TABLE `$prefix_forms` CHANGE `captcha_height` `captcha_height` INT( 11 ) NOT NULL DEFAULT '60';

-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Paymentgateway
--

-- --------------------------------------------------------

-- 
-- 	Table structure for table `$prefix_payment_gateway`
--

insert into `$prefix_payment_gateway` (`id`, `name`, `title`, `logo`, `payment_order`, `active`) values (9,'WebPay','UBA WEBPAY (Bank of Africa )','webpay.jpg','9','0');

-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Settings
--

-- --------------------------------------------------------

-- 
-- 	Table structure for table `global_settings`
--

ALTER TABLE `$prefix_global_settings` ADD `login_ip_checking` ENUM( '0', '1', '2' ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' AFTER `seo_on` ;

ALTER TABLE `$prefix_global_settings` ADD `captcha_enable` ENUM( '1', '0' ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' AFTER `login_ip_checking` ,
									   ADD `image_renaming_enable` ENUM( '0', '1' ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' AFTER `captcha_enable` ;

-- --------------------------------------------------------

-- 
-- 	Table structure for table `global_settings_ip_ban`
--


DROP TABLE IF EXISTS `$prefix_global_settings_ip_ban`;
CREATE TABLE IF NOT EXISTS `$prefix_global_settings_ip_ban` (                                      
																 `id` int(11) NOT NULL AUTO_INCREMENT,                                         
																 `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,                       
																 `status` enum('1','2') COLLATE utf8_unicode_ci NOT NULL DEFAULT '2',          
																 `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,                  
																 PRIMARY KEY (`id`)                                                            
															   ) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Administrator
--

-- --------------------------------------------------------

-- 
-- 	Table structure for table `roles`
--

ALTER TABLE `$prefix_roles` ADD `allow_ip_checking_to_login` ENUM( '1', '0' ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0';

-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Hotels
--

-- --------------------------------------------------------

--
-- Table structure for table `$prefix_hotels_api_list`
--

DROP TABLE IF EXISTS `$prefix_hotels_api_list`;
CREATE TABLE IF NOT EXISTS `$prefix_hotels_api_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` enum('1','0') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_name` (`name`),
  UNIQUE KEY `api_logo` (`logo`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `$prefix_hotels_api_list`
--

INSERT INTO `$prefix_hotels_api_list` (`id`, `logo`, `name`, `title`, `active`) VALUES
(1, 'wego-api.jpg', 'wego', 'WeGo Hotel API', '0'),
(2, 'expedia-api.png', 'expedia', 'Expedia Affiliate Network', '1');

-- --------------------------------------------------------

--
-- Table structure for table `$prefix_hotels_api_settings`
--

DROP TABLE IF EXISTS `$prefix_hotels_api_settings`;
CREATE TABLE IF NOT EXISTS `$prefix_hotels_api_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_id` int(11) NOT NULL,
  `setting` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=12 ;

INSERT INTO `$prefix_hotels_api_settings` (`id`, `api_id`, `setting`, `value`) VALUES
(1, 2, 'api_name', 'Expedia'),
(2, 2, 'supplierType', 'E'),
(3, 2, 'api_title', 'EAN Expedia'),
(4, 2, 'city_name', 'London'),
(5, 2, 'api_key', 'wtd8h5afknjgs7dag7jfgvt4'),
(6, 2, 'cid', '34547689079789'),
(7, 2, 'currencyCode', 'EUR'),
(8, 2, 'minorRev', '16'),
(9, 2, 'locale', 'en_US'),
(10, 2, 'numberOfResults', '50'),
(11, 2, 'sort', 'QUALITY');

-- --------------------------------------------------------

--
-- Table structure for table `$prefix_hotels_room_type`
--

ALTER TABLE `$prefix_hotels_room_type` ADD `price_setting_type` ENUM( '1', '2' ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '2' COMMENT '1-single price, 2-date wise price' AFTER `max_people`;

-- --------------------------------------------------------

--
-- Table structure for table `$prefix_hotels_room`
--


ALTER TABLE `$prefix_hotels_room` ADD `hotel_id` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL AFTER `room_type_id`; 

-- --------------------------------------------------------

--
-- Table structure for table `$prefix_hotels_api_expedia`
--

DROP TABLE IF EXISTS `$prefix_hotels_api_expedia`;
CREATE TABLE IF NOT EXISTS `$prefix_hotels_api_expedia` (
  `id` bigint(25) NOT NULL AUTO_INCREMENT,
  `itineraryId` bigint(20) NOT NULL,
  `arrivalDate` date NOT NULL,
  `departureDate` date NOT NULL,
  `hotelId` bigint(20) NOT NULL,
  `user_id` int(20) NOT NULL,
  `confirmationNumbers` int(20) NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `rateCurrencyCode` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `price` float NOT NULL,
  `resultSetObject` text COLLATE utf8_unicode_ci NOT NULL,
  `cancel` enum('0','1') COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `itineraryId` (`itineraryId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;