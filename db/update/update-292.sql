--	Comment
--	Previous Version = 2.9.1
--	Working Version = 2.9.2


-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Members
--

-- --------------------------------------------------------

--
-- Dumping data for table `$prefix_user_profile`
--

ALTER TABLE `$prefix_user_profile` CHANGE `register_date` `register_date` DATETIME NULL DEFAULT NULL ;


-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Menu
--

-- --------------------------------------------------------

--
-- Dumping data for table `$prefix_menu_group`
--

ALTER TABLE `$prefix_menu_group` ADD `entry_by` INT NOT NULL DEFAULT '1' AFTER `active` ;

ALTER TABLE `$prefix_menu_group` ADD  `product_id` INT NOT NULL DEFAULT  '0' AFTER  `entry_by` ;


-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Invoice
--

-- --------------------------------------------------------

--
-- Dumping data for table `$prefix_invoice_table`
--

ALTER TABLE  `$prefix_invoice_table` 	CHANGE  `sub_total`  `sub_total` DOUBLE NOT NULL DEFAULT  '0',
										CHANGE  `tax`  `tax` DOUBLE NOT NULL DEFAULT  '0',
										CHANGE  `total`  `total` DOUBLE NOT NULL DEFAULT  '0';

-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Administrator
--

-- --------------------------------------------------------

--
-- Dumping data for table `$prefix_roles`
--

ALTER TABLE  `$prefix_roles` ADD  `allow_change_order_listing` ENUM(  '0',  '1' ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT  '1' COMMENT 'NB : Enabling means, this role will be able to increase or decrease his listing orders by clicking the arrow beside the order number and save button.' AFTER `allow_ip_checking_to_login` ;



-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: countries
--

-- --------------------------------------------------------

--
-- Dumping data for table `$prefix_countries`
--

DROP TABLE IF EXISTS `$prefix_countries`;

CREATE TABLE IF NOT EXISTS `$prefix_countries` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `value` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`),
  UNIQUE KEY `value_2` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=242 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Data for the table `$prefix_countries` */

insert into `$prefix_countries` values 

(1,'Afghanistan','AF'),

(2,'&Aring;land Islands','AX'),

(3,'Albania','AL'),

(4,'Algeria','DZ'),

(5,'American Samoa','AS'),

(6,'Andorra','AD'),

(7,'Angola','AO'),

(8,'Anguilla','AI'),

(9,'Antarctica','AQ'),

(10,'Antigua and Barbuda','AG'),

(11,'Argentina','AR'),

(12,'Armenia','AM'),

(13,'Aruba','AW'),

(14,'Australia','AU'),

(15,'Austria','AT'),

(16,'Azerbaijan','AZ'),

(17,'Bahamas','BS'),

(18,'Bahrain','BH'),

(19,'Bangladesh','BD'),

(20,'Barbados','BB'),

(21,'Belarus','BY'),

(22,'Belgium','BE'),

(23,'Belize','BZ'),

(24,'Benin','BJ'),

(25,'Bermuda','BM'),

(26,'Bhutan','BT'),

(27,'Bolivia','BO'),

(28,'Bosnia and Herzegovina','BA'),

(29,'Botswana','BW'),

(30,'Bouvet Island','BV'),

(31,'Brazil','BR'),

(32,'British Indian Ocean territory','IO'),

(33,'Brunei Darussalam','BN'),

(34,'Bulgaria','BG'),

(35,'Burkina Faso','BF'),

(36,'Burundi','BI'),

(37,'Cambodia','KH'),

(38,'Cameroon','CM'),

(39,'Canada','CA'),

(40,'Cape Verde','CV'),

(41,'Cayman Islands','KY'),

(42,'Central African Republic','CF'),

(43,'Chad','TD'),

(44,'Chile','CL'),

(45,'China','CN'),

(46,'Christmas Island','CX'),

(47,'Cocos (Keeling) Islands','CC'),

(48,'Colombia','CO'),

(49,'Comoros','KM'),

(50,'Congo','CG'),

(51,'South Sudan','SS'),

(52,'Democratic Republic','CD'),

(53,'Cook Islands','CK'),

(54,'Costa Rica','CR'),

(55,'Ivoire (Ivory Coast)','CI'),

(56,'Croatia (Hrvatska)','HR'),

(57,'Cuba','CU'),

(58,'Cyprus','CY'),

(59,'Czech Republic','CZ'),

(60,'Denmark','DK'),

(61,'Djibouti','DJ'),

(62,'Dominica','DM'),

(63,'Dominican Republic','DO'),

(64,'East Timor','TP'),

(65,'Ecuador','EC'),

(66,'Egypt','EG'),

(67,'El Salvador','SV'),

(68,'Equatorial Guinea','GQ'),

(69,'Eritrea','ER'),

(70,'Estonia','EE'),

(71,'Ethiopia','ET'),

(72,'Falkland Islands','FK'),

(73,'Faroe Islands','FO'),

(74,'Fiji','FJ'),

(75,'Finland','FI'),

(76,'France','FR'),

(77,'French Guiana','GF'),

(78,'French Polynesia','PF'),

(79,'French Southern Territories','TF'),

(80,'Gabon','GA'),

(81,'Gambia','GM'),

(82,'Georgia','GE'),

(83,'Germany','DE'),

(84,'Ghana','GH'),

(85,'Gibraltar','GI'),

(86,'Greece','GR'),

(87,'Greenland','GL'),

(88,'Grenada','GD'),

(89,'Guadeloupe','GP'),

(90,'Guam','GU'),

(91,'Guatemala','GT'),

(92,'Guinea','GN'),

(93,'Guinea-Bissau','GW'),

(94,'Guyana','GY'),

(95,'Haiti','HT'),

(96,'Heard and McDonald Islands','HM'),

(97,'Honduras','HN'),

(98,'Hong Kong','HK'),

(99,'Hungary','HU'),

(100,'Iceland','IS'),

(101,'India','IN'),

(102,'Indonesia','ID'),

(103,'Iran','IR'),

(104,'Iraq','IQ'),

(105,'Ireland','IE'),

(106,'Israel','IL'),

(107,'Italy','IT'),

(108,'Jamaica','JM'),

(109,'Japan','JP'),

(110,'Jordan','JO'),

(111,'Kazakhstan','KZ'),

(112,'Kenya','KE'),

(113,'Kiribati','KI'),

(114,'Korea (north)','KP'),

(115,'Korea (south)','KR'),

(116,'Kuwait','KW'),

(117,'Kyrgyzstan','KG'),

(118,'Lao People\'s Democratic Republic','LA'),

(119,'Latvia','LV'),

(120,'Lebanon','LB'),

(121,'Lesotho','LS'),

(122,'Liberia','LR'),

(123,'Libyan Arab Jamahiriya','LY'),

(124,'Liechtenstein','LI'),

(125,'Lithuania','LT'),

(126,'Luxembourg','LU'),

(127,'Macao','MO'),

(128,'Macedonia','MK'),

(129,'Madagascar','MG'),

(130,'Malawi','MW'),

(131,'Malaysia','MY'),

(132,'Maldives','MV'),

(133,'Mali','ML'),

(134,'Malta','MT'),

(135,'Marshall Islands','MH'),

(136,'Martinique','MQ'),

(137,'Mauritania','MR'),

(138,'Mauritius','MU'),

(139,'Mayotte','YT'),

(140,'Mexico','MX'),

(141,'Micronesia','FM'),

(142,'Moldova','MD'),

(143,'Monaco','MC'),

(144,'Mongolia','MN'),

(145,'Montserrat','MS'),

(146,'Morocco','MA'),

(147,'Mozambique','MZ'),

(148,'Myanmar','MM'),

(149,'Namibia','NA'),

(150,'Nauru','NR'),

(151,'Nepal','NP'),

(152,'Netherlands','NL'),

(153,'Netherlands Antilles','AN'),

(154,'New Caledonia','NC'),

(155,'New Zealand','NZ'),

(156,'Nicaragua','NI'),

(157,'Niger','NE'),

(158,'Nigeria','NG'),

(159,'Niue','NU'),

(160,'Norfolk Island','NF'),

(161,'Northern Mariana Islands','MP'),

(162,'Norway','NO'),

(163,'Oman','OM'),

(164,'Pakistan','PK'),

(165,'Palau','PW'),

(166,'Palestinian Territories','PS'),

(167,'Panama','PA'),

(168,'Papua New Guinea','PG'),

(169,'Paraguay','PY'),

(170,'Peru','PE'),

(171,'Philippines','PH'),

(172,'Pitcairn','PN'),

(173,'Poland','PL'),

(174,'Portugal','PT'),

(175,'Puerto Rico','PR'),

(176,'Qatar','QA'),

(177,'Reacute union','RE'),

(178,'Romania','RO'),

(179,'Russian Federation','RU'),

(180,'Rwanda','RW'),

(181,'Saint Helena','SH'),

(182,'Saint Kitts and Nevis','KN'),

(183,'Saint Lucia','LC'),

(184,'Saint Pierre and Miquelon','PM'),

(185,'Saint Vincent and the Grenadines','VC'),

(186,'Samoa','WS'),

(187,'San Marino','SM'),

(188,'Sao Tome and Principe','ST'),

(189,'Saudi Arabia','SA'),

(190,'Senegal','SN'),

(191,'Serbia and Montenegro','RS'),

(192,'Seychelles','SC'),

(193,'Sierra Leone','SL'),

(194,'Singapore','SG'),

(195,'Slovakia','SK'),

(196,'Slovenia','SI'),

(197,'Solomon Islands','SB'),

(198,'Somalia','SO'),

(199,'South Africa','ZA'),

(200,'South Georgia and the South Sandwich Islands','GS'),

(201,'Spain','ES'),

(202,'Sri Lanka','LK'),

(203,'Sudan','SD'),

(204,'Suriname','SR'),

(205,'Svalbard and Jan Mayen Islands','SJ'),

(206,'Swaziland','SZ'),

(207,'Sweden','SE'),

(208,'Switzerland','CH'),

(209,'Syria','SY'),

(210,'Taiwan','TW'),

(211,'Tajikistan','TJ'),

(212,'Tanzania','TZ'),

(213,'Thailand','TH'),

(214,'Togo','TG'),

(215,'Tokelau','TK'),

(216,'Tonga','TO'),

(217,'Trinidad and Tobago','TT'),

(218,'Tunisia','TN'),

(219,'Turkey','TR'),

(220,'Turkmenistan','TM'),

(221,'Turks and Caicos Islands','TC'),

(222,'Tuvalu','TV'),

(223,'Uganda','UG'),

(224,'Ukraine','UA'),

(225,'United Arab Emirates','AE'),

(226,'United Kingdom','GB'),

(227,'United States of America','US'),

(228,'Uruguay','UY'),

(229,'Uzbekistan','UZ'),

(230,'Vanuatu','VU'),

(231,'Vatican City(Holy See)','VA'),

(232,'Venezuela','VE'),

(233,'Vietnam','VN'),

(234,'Virgin Islands (British)','VG'),

(235,'Virgin Islands (US)','VI'),

(236,'Wallis and Futuna Islands','WF'),

(237,'Western Sahara','EH'),

(238,'Yemen','YE'),

(239,'Zaire','ZR'),

(240,'Zambia','ZM'),

(241,'Zimbabwe','ZW');

ALTER TABLE  `$prefix_countries` ADD UNIQUE ( `code` ) ;


-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Hotels
--

-- --------------------------------------------------------

--
-- Dumping data for table `$prefix_hotels_page`
--

-- --------------------------------------------------------

ALTER TABLE `$prefix_hotels_page`  	ADD `billing_user_places_order_email_enable` ENUM('yes','no') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'yes' AFTER `payment_desc`,  
									ADD `billing_user_places_order_email_address` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL AFTER `billing_user_places_order_email_enable`,  
									ADD `billing_user_pay_invoice_email_enable` ENUM('yes','no') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'yes' AFTER `billing_user_places_order_email_address`,  
									ADD `billing_user_pay_invoice_email_address` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL AFTER `billing_user_pay_invoice_email_enable`,  
									ADD `billing_user_cancel_order_email_enable` ENUM('yes','no') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'yes' AFTER `billing_user_pay_invoice_email_address`,  
									ADD `billing_user_cancel_order_email_address` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL AFTER `billing_user_cancel_order_email_enable`,  
									ADD `billing_order_payment_email_enable` ENUM('yes','no') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'yes' AFTER `billing_user_cancel_order_email_address`,  
									ADD `billing_item_desc` TEXT NULL DEFAULT NULL AFTER `billing_order_payment_email_enable`;
									
-- --------------------------------------------------------

--
-- Dumping data for table `$prefix_hotels_business_type`
--

-- --------------------------------------------------------

ALTER TABLE  `$prefix_hotels_business_type` ADD  `entry_by` INT NOT NULL DEFAULT  '1' AFTER  `business_type` ,
											ADD  `entry_date` DATETIME NULL DEFAULT NULL AFTER  `entry_by`;