--	Comment
--	Previous Version = 2.4.5
--	Working Version = 2.7.0

-- --------------------------------------------------------
-- --------------------------------------------------------

--
--	Module Name: Hotels
--

-- --------------------------------------------------------

-- 
-- 	Table structure for table `hotels_api`
--

DROP TABLE IF EXISTS `hotels_api`;

CREATE TABLE `hotels_api` (                         
                 `id` int(11) NOT NULL AUTO_INCREMENT,                
                 `api_name` varchar(255) DEFAULT NULL,                
                 `api_username` varchar(255) DEFAULT NULL,            
                 `api_password` varchar(255) DEFAULT NULL,            
                 `api_key` varchar(255) DEFAULT NULL,                 
                 `api_base_uri` varchar(255) DEFAULT NULL,            
                 `api_ts_code` varchar(255) DEFAULT NULL,             
                 PRIMARY KEY (`id`)                                   
               ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `hotels_api` (
				`id` ,
				`api_name` ,
				`api_username` ,
				`api_password` ,
				`api_key` ,
				`api_base_uri` ,
				`api_ts_code`
				)
				VALUES (
				'1', NULL , NULL , NULL , NULL , NULL , NULL
				);