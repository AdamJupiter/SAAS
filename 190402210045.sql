/*
MySQL Backup
Source Server Version: 5.6.17
Source Database: saas
Date: 2019/4/2 21:00:45
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
--  Table structure for `airplane_in_company`
-- ----------------------------
DROP TABLE IF EXISTS `airplane_in_company`;
CREATE TABLE `airplane_in_company` (
  `company_id` int(4) NOT NULL COMMENT '飞机所属航空公司',
  `airplane_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `register_num` char(8) NOT NULL COMMENT '注册号',
  `call_sign` decimal(10,0) NOT NULL,
  `airplane_type` char(4) NOT NULL COMMENT '机型',
  `total_Passenger` int(11) NOT NULL COMMENT '载客数',
  `MTOW` int(11) NOT NULL COMMENT '最大起飞重量',
  PRIMARY KEY (`airplane_id`,`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `airport`
-- ----------------------------
DROP TABLE IF EXISTS `airport`;
CREATE TABLE `airport` (
  `airport_code` char(4) NOT NULL COMMENT '机场编码',
  `English_name` char(50) DEFAULT NULL COMMENT '英文名字',
  `Chinese_name` varchar(20) DEFAULT NULL,
  `country` varchar(10) DEFAULT '中国' COMMENT '所在国家',
  `city` varchar(10) DEFAULT NULL COMMENT '城市',
  `comment` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`airport_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `airport_fbo`
-- ----------------------------
DROP TABLE IF EXISTS `airport_fbo`;
CREATE TABLE `airport_fbo` (
  `airport_code` char(4) NOT NULL,
  `fbo_id` int(3) NOT NULL,
  `fbo_name` varchar(30) DEFAULT NULL,
  `fbo_address` varchar(50) DEFAULT NULL,
  `fbo_VHF` float DEFAULT NULL COMMENT '甚高频(三位数加三位小数)',
  `fbo_fex` char(12) DEFAULT NULL,
  `fbo_tel` decimal(20,0) DEFAULT NULL,
  KEY `airport_code` (`airport_code`),
  CONSTRAINT `airport_code` FOREIGN KEY (`airport_code`) REFERENCES `airport` (`airport_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `company`
-- ----------------------------
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
  `company_id` int(4) NOT NULL DEFAULT '0',
  `company_name` varchar(20) NOT NULL COMMENT '公司名称',
  `company_address` varchar(100) NOT NULL COMMENT '公司地址',
  `company_email` varchar(40) NOT NULL COMMENT '运行邮箱',
  `company_tel` decimal(20,0) NOT NULL COMMENT '联系方式',
  `company_fax` char(20) NOT NULL COMMENT '传真',
  `company_sita` char(4) NOT NULL,
  `company_aifn` char(4) NOT NULL,
  `company_logo` char(100) NOT NULL COMMENT 'logo地址',
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `company_license`
-- ----------------------------
DROP TABLE IF EXISTS `company_license`;
CREATE TABLE `company_license` (
  `company_id` int(4) NOT NULL,
  `license_id` int(11) NOT NULL,
  `license_name` varchar(20) NOT NULL,
  `license_img` char(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `country`
-- ----------------------------
DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `county_id` int(5) DEFAULT NULL,
  `English_name` varchar(20) DEFAULT NULL COMMENT '国家英文名',
  `Chinese_name` varchar(20) DEFAULT NULL COMMENT '国家中文名',
  KEY `county_id` (`county_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `crew_occupation_meaning`
-- ----------------------------
DROP TABLE IF EXISTS `crew_occupation_meaning`;
CREATE TABLE `crew_occupation_meaning` (
  `occupation` char(10) NOT NULL COMMENT '职位',
  `comment` varchar(10) DEFAULT NULL COMMENT '职位解释',
  PRIMARY KEY (`occupation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_base`
-- ----------------------------
DROP TABLE IF EXISTS `flight_base`;
CREATE TABLE `flight_base` (
  `flight_id` char(10) NOT NULL DEFAULT '',
  `flight_type` varchar(10) NOT NULL,
  `begin_date` date NOT NULL,
  `end_date` date NOT NULL,
  `leg_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `comment` longtext,
  PRIMARY KEY (`flight_id`),
  KEY `leg_match_code` (`leg_match_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_contain_leg`
-- ----------------------------
DROP TABLE IF EXISTS `flight_contain_leg`;
CREATE TABLE `flight_contain_leg` (
  `leg_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `flight_id` char(10) NOT NULL COMMENT '航班号',
  `leg_id` int(3) NOT NULL,
  `origin_code` varchar(4) NOT NULL COMMENT '出发地',
  `depart_time` varchar(5) NOT NULL COMMENT '起飞时间(UTC时)',
  `depart_date` varchar(10) NOT NULL COMMENT '起飞日期',
  `depart_code` varchar(4) NOT NULL COMMENT '目的地编码',
  `arrive_time` varchar(5) NOT NULL COMMENT '落地时间',
  `arrive_date` varchar(10) NOT NULL COMMENT '落地日期',
  PRIMARY KEY (`leg_id`),
  KEY `leg_match_code` (`leg_match_code`),
  CONSTRAINT `leg_match_code` FOREIGN KEY (`leg_match_code`) REFERENCES `flight_base` (`leg_match_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_catering`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_catering`;
CREATE TABLE `flight_leg_catering` (
  `flight_id` char(10) NOT NULL,
  `leg_id` int(3) NOT NULL,
  `airport_code` char(4) NOT NULL,
  `supplier` varchar(30) NOT NULL,
  `status` char(30) NOT NULL,
  `leg_match_code` char(100) NOT NULL COMMENT '单次航班匹配码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_crew_staff`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_crew_staff`;
CREATE TABLE `flight_leg_crew_staff` (
  `leg_match_code` char(100) DEFAULT NULL COMMENT '单次航班匹配码',
  `flight_id` varchar(10) DEFAULT NULL,
  `leg_id` int(3) DEFAULT NULL,
  `staff_id` varchar(20) NOT NULL COMMENT '员工编号',
  `name` varchar(30) NOT NULL,
  `gender` char(1) NOT NULL,
  `occupation` char(10) NOT NULL COMMENT '职位',
  `DOB` date NOT NULL COMMENT '出生日期',
  `PPN` char(12) NOT NULL COMMENT '护照号',
  `POB` varchar(10) NOT NULL COMMENT '常住城市',
  `DOE` date NOT NULL COMMENT '护照有效期',
  `nationality` varchar(50) NOT NULL,
  KEY `nationality` (`nationality`(4)),
  KEY `occupation` (`occupation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_crew_transportation`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_crew_transportation`;
CREATE TABLE `flight_leg_crew_transportation` (
  `leg_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `flight_id` char(10) NOT NULL,
  `leg_id` int(3) NOT NULL,
  `airport` char(4) NOT NULL,
  `vehicle_type` varchar(15) NOT NULL,
  `driver` varchar(20) NOT NULL,
  `tel` int(12) NOT NULL,
  `pick_up_time_utc` datetime NOT NULL,
  `local_time` datetime NOT NULL,
  `pick_up_point` varchar(20) NOT NULL,
  `status` char(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_fuelers`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_fuelers`;
CREATE TABLE `flight_leg_fuelers` (
  `leg_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `flight_id` char(10) NOT NULL,
  `leg_id` int(3) NOT NULL,
  `fuel_release` char(16) NOT NULL,
  `fule_file` char(100) NOT NULL,
  `status` char(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_hotel`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_hotel`;
CREATE TABLE `flight_leg_hotel` (
  `leg_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `flight_id` char(10) NOT NULL,
  `leg_id` int(3) NOT NULL,
  `airport_code` char(4) NOT NULL,
  `hotel_name` varchar(30) NOT NULL,
  `hotel_address` varchar(50) NOT NULL,
  `status` char(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_permit`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_permit`;
CREATE TABLE `flight_leg_permit` (
  `leg_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `flight_id` char(10) DEFAULT NULL,
  `leg_id` int(3) DEFAULT NULL,
  `permission_county` int(5) NOT NULL,
  `permission_type` char(10) NOT NULL COMMENT '许可类型',
  `permission_no` char(20) NOT NULL COMMENT '许可编号',
  `permission_status` char(10) NOT NULL COMMENT '许可状态',
  KEY `LEG_id` (`leg_id`),
  KEY `flight_id` (`flight_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_permission_type`
-- ----------------------------
DROP TABLE IF EXISTS `flight_permission_type`;
CREATE TABLE `flight_permission_type` (
  `permission_type` char(10) NOT NULL,
  `comment` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_type`
-- ----------------------------
DROP TABLE IF EXISTS `flight_type`;
CREATE TABLE `flight_type` (
  `flight_type` varchar(10) NOT NULL,
  `comment` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `passenger`
-- ----------------------------
DROP TABLE IF EXISTS `passenger`;
CREATE TABLE `passenger` (
  `passenger_id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL COMMENT '姓名',
  `gender` char(1) DEFAULT NULL COMMENT '性别F/M2选1',
  `nationality` varchar(10) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `passport_no` char(10) NOT NULL,
  `passport_begin_date` datetime NOT NULL,
  `passport_end_date` datetime NOT NULL,
  `tel` int(20) DEFAULT NULL,
  `flight_id` varchar(10) NOT NULL,
  `leg_id` int(3) NOT NULL,
  PRIMARY KEY (`passenger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `permission_status`
-- ----------------------------
DROP TABLE IF EXISTS `permission_status`;
CREATE TABLE `permission_status` (
  `permission_status` char(30) NOT NULL COMMENT '许可状态',
  `comment` varchar(20) DEFAULT NULL COMMENT '注释'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `staff_in_company`
-- ----------------------------
DROP TABLE IF EXISTS `staff_in_company`;
CREATE TABLE `staff_in_company` (
  `company_id` int(3) NOT NULL COMMENT '公司编号',
  `staff_id` varchar(20) NOT NULL COMMENT '员工编号',
  `name` varchar(30) NOT NULL,
  `gender` char(1) NOT NULL,
  `occupation` char(10) NOT NULL COMMENT '职位',
  `DOB` date NOT NULL COMMENT '出生日期',
  `PPN` char(12) NOT NULL COMMENT '护照号',
  `POB` varchar(10) DEFAULT NULL COMMENT '常住城市',
  `DOE` date NOT NULL COMMENT '护照有效期',
  `nationality` varchar(50) NOT NULL,
  KEY `staff_id` (`staff_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `company_id` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `user_company`
-- ----------------------------
DROP TABLE IF EXISTS `user_company`;
CREATE TABLE `user_company` (
  `company_id` int(4) NOT NULL COMMENT '用户所属航空公司',
  `user_name` varchar(10) NOT NULL COMMENT '用户昵称',
  `password` char(16) NOT NULL,
  `userTel` decimal(20,0) unsigned NOT NULL,
  `email` varchar(30) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `country` varchar(30) DEFAULT NULL,
  `user_status` varchar(3) NOT NULL DEFAULT '1' COMMENT '用户状态',
  PRIMARY KEY (`userTel`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `user_status`
-- ----------------------------
DROP TABLE IF EXISTS `user_status`;
CREATE TABLE `user_status` (
  `rank` int(1) DEFAULT NULL,
  `comment` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records 
-- ----------------------------
INSERT INTO `airplane_in_company` VALUES ('1','1','FNA9993','999999999','JDNS','56','20'), ('1','2','JSB8888','0','DKAH','20','25');
INSERT INTO `company` VALUES ('1','顺丰航空公司','Vancouver British Columbia V6Z 2R9 Canada','OP@FASTWAYJET.CO','100000000','9847593795','JUDD','DISN','20190402/fa0fb716130550d459043cad64d5e091.jpg');
INSERT INTO `company_license` VALUES ('1','1','证件测试登机口几块钱我了肯德基情况未','20190402/d6fc39be11007b0e62aa2188b3c963f7.jpg'), ('1','2','证件测试','20190312/6de5dbd9aa64653838fc57411c533ed1.jpg'), ('1','3','证件测试','20190402/e3844b8877b914cd3c765ac10a9cd65b.jpg');
INSERT INTO `crew_occupation_meaning` VALUES ('CAPT','机长'), ('F/A','乘务员'), ('F/M','机务'), ('F/O','副驾驶'), ('OTHER','其他');
INSERT INTO `flight_base` VALUES ('NZ4908','FERRY','2018-08-09','2019-03-21','NZ4908|2019-03-19 21:15:14','');
INSERT INTO `flight_contain_leg` VALUES ('NZ4908|2019-03-19 21:15:14','NZ4908','1','ZSPD','0530Z','APR 02	','CYVR','1600Z','APR 02'), ('NZ4908|2019-03-19 21:15:14','NZ4908','2','ZSPD','0530Z','APR 02	','CYVR','1600Z','APR 02');
INSERT INTO `flight_leg_crew_staff` VALUES (NULL,NULL,NULL,'1','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国');
INSERT INTO `flight_permission_type` VALUES ('OVF','飞越许可'), ('LDG','落地许可'), ('DEP SLOT','起飞时刻'), ('LDG SLOT','落地时刻'), ('PPR','停场许可'), ('LDG RIGHTS','落地权'), ('OTHER','其他');
INSERT INTO `flight_type` VALUES ('Ferry','调机飞行'), ('Private','私人飞行'), ('Charter','取酬飞行'), ('Test','试飞'), ('Other','其他');
INSERT INTO `permission_status` VALUES ('PENDING','等待同意'), ('APPROVED','同意'), ('REJECTED','拒绝'), ('AMENDED AND PENDING','修改后等待同意');
INSERT INTO `staff_in_company` VALUES ('1','1','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国');
INSERT INTO `user_company` VALUES ('1','luojia','luojia','18666885775','522246447@qq.com','M','Chinese/中国','1');
INSERT INTO `user_status` VALUES ('1','正常'), ('2','封禁'), ('0','黑名单');
