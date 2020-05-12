CREATE TABLE `job72_handler` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) COLLATE utf8_persian_ci DEFAULT NULL,
  `slot` smallint(6) DEFAULT '0',
  `limit_time` tinyint(1) NOT NULL DEFAULT '1',
  `expire_time` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;
