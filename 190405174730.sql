/*
MySQL Backup
Source Server Version: 5.6.17
Source Database: saas
Date: 2019/4/5 17:47:30
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
  `begin_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `flight_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `comment` longtext,
  KEY `leg_match_code` (`flight_match_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_contain_leg`
-- ----------------------------
DROP TABLE IF EXISTS `flight_contain_leg`;
CREATE TABLE `flight_contain_leg` (
  `flight_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `leg_id` int(3) NOT NULL,
  `origin_code` varchar(4) NOT NULL COMMENT '出发地',
  `depart_time` datetime(5) NOT NULL COMMENT '起飞时间(UTC时)',
  `depart_code` varchar(4) NOT NULL COMMENT '目的地编码',
  `arrive_time` datetime(5) NOT NULL COMMENT '落地时间',
  `flight_type` char(10) NOT NULL,
  PRIMARY KEY (`flight_match_code`,`leg_id`),
  CONSTRAINT `leg_match_code` FOREIGN KEY (`flight_match_code`) REFERENCES `flight_base` (`flight_match_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_airport_fbo`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_airport_fbo`;
CREATE TABLE `flight_leg_airport_fbo` (
  `flight_match_code` char(100) NOT NULL,
  `leg_id` int(3) NOT NULL COMMENT '航段编号',
  `fbo_name` varchar(30) DEFAULT NULL,
  `fbo_address` varchar(50) DEFAULT NULL COMMENT 'FBO地址',
  `fbo_VHF` float DEFAULT NULL COMMENT '甚高频(三位数加三位小数)',
  `fbo_fex` char(12) DEFAULT NULL COMMENT '传真',
  `fbo_tel` decimal(20,0) DEFAULT NULL COMMENT '联系方式',
  `status` char(10) DEFAULT 'PENDING' COMMENT '状态',
  PRIMARY KEY (`leg_id`,`flight_match_code`)
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
  `flight_match_code` char(100) NOT NULL COMMENT '单次航班匹配码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_crew_staff`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_crew_staff`;
CREATE TABLE `flight_leg_crew_staff` (
  `flight_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `leg_id` int(3) NOT NULL,
  `staff_id` int(11) NOT NULL COMMENT '员工编号',
  `name` varchar(30) NOT NULL,
  `gender` char(1) NOT NULL,
  `occupation` char(10) NOT NULL COMMENT '职位',
  `DOB` date NOT NULL COMMENT '出生日期',
  `PPN` char(12) NOT NULL COMMENT '护照号',
  `POB` varchar(10) NOT NULL COMMENT '常住城市',
  `DOE` date NOT NULL COMMENT '护照有效期',
  `nationality` varchar(50) NOT NULL,
  PRIMARY KEY (`flight_match_code`,`leg_id`,`staff_id`),
  KEY `nationality` (`nationality`(4)),
  KEY `occupation` (`occupation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_crew_transportation`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_crew_transportation`;
CREATE TABLE `flight_leg_crew_transportation` (
  `flight_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `leg_id` int(3) NOT NULL,
  `airport` char(4) NOT NULL COMMENT '机场4字码',
  `vehicle` varchar(15) NOT NULL COMMENT '交通工具',
  `driver` varchar(20) NOT NULL COMMENT '司机姓名',
  `tel` int(12) NOT NULL COMMENT '司机联系方式',
  `pick_up_time_utc` datetime NOT NULL COMMENT 'utc时间',
  `local_time` datetime NOT NULL COMMENT '当地时间',
  `pick_up_point` varchar(20) NOT NULL,
  `status` char(30) NOT NULL DEFAULT 'PENDING' COMMENT '状态',
  PRIMARY KEY (`flight_match_code`,`leg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_fuelers`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_fuelers`;
CREATE TABLE `flight_leg_fuelers` (
  `flight_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
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
  `flight_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `leg_id` int(3) NOT NULL,
  `airport_code` char(4) NOT NULL,
  `hotel_name` varchar(30) NOT NULL,
  `hotel_address` varchar(50) NOT NULL,
  `status` char(30) NOT NULL DEFAULT 'PENDING' COMMENT '状态',
  PRIMARY KEY (`flight_match_code`,`leg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_passenger`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_passenger`;
CREATE TABLE `flight_leg_passenger` (
  `flight_match_code` char(100) NOT NULL,
  `leg_id` int(3) NOT NULL,
  `passenger_id` int(20) unsigned NOT NULL,
  `name` varchar(10) NOT NULL COMMENT '姓名',
  `DOE` date DEFAULT NULL COMMENT '出生日期',
  `gender` char(1) DEFAULT NULL COMMENT '性别F/M2选1',
  `PPN` char(10) NOT NULL COMMENT '护照号',
  `DOB` date NOT NULL COMMENT '护照有效期至',
  `nationality` varchar(10) NOT NULL COMMENT '国籍',
  PRIMARY KEY (`leg_id`,`flight_match_code`,`passenger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_permit`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_permit`;
CREATE TABLE `flight_leg_permit` (
  `flight_match_code` char(100) NOT NULL COMMENT '单次航班匹配码',
  `leg_id` int(3) NOT NULL,
  `nation` varchar(30) NOT NULL COMMENT '许可国',
  `permit_type` char(10) NOT NULL COMMENT '许可类型',
  `permit_no` char(20) NOT NULL COMMENT '许可编号',
  `status` char(10) NOT NULL DEFAULT 'PENDING' COMMENT '状态',
  PRIMARY KEY (`flight_match_code`,`leg_id`),
  KEY `LEG_id` (`leg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `flight_leg_remarks`
-- ----------------------------
DROP TABLE IF EXISTS `flight_leg_remarks`;
CREATE TABLE `flight_leg_remarks` (
  `flight_match_code` char(100) NOT NULL,
  `leg_id` int(3) NOT NULL COMMENT '航段编号',
  `remarks` longtext COMMENT '备注信息',
  PRIMARY KEY (`flight_match_code`,`leg_id`)
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
  `user_status` varchar(3) NOT NULL DEFAULT '正常' COMMENT '用户状态',
  PRIMARY KEY (`userTel`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `user_servers`
-- ----------------------------
DROP TABLE IF EXISTS `user_servers`;
CREATE TABLE `user_servers` (
  `servers_staff_id` int(4) NOT NULL COMMENT '地面代理公司员工id',
  `user_name` varchar(10) NOT NULL COMMENT '用户昵称',
  `password` char(16) NOT NULL,
  `userTel` decimal(20,0) unsigned NOT NULL,
  `email` varchar(30) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `country` varchar(30) DEFAULT NULL,
  `user_status` varchar(3) NOT NULL DEFAULT '普通' COMMENT '用户状态',
  `user_rank` varchar(5) NOT NULL DEFAULT '普通用户' COMMENT '用户权限',
  PRIMARY KEY (`userTel`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records 
-- ----------------------------
INSERT INTO `airplane_in_company` VALUES ('1','1','FNA9993','999999999','JDNS','56','20'), ('1','2','JSB8888','0','DKAH','20','25');
INSERT INTO `company` VALUES ('1','淘宝航空公司','Vancouver British Columbia V6Z 2R9 Canada','OP@FASTWAYJET.CO','100000000','9847593795','JUDD','DISN','20190403/9046d5e6cadd63e45ce1fe53fd63bf93.jpg');
INSERT INTO `company_license` VALUES ('1','1','证件测试登机口几块钱我了肯德基情况未','20190402/d6fc39be11007b0e62aa2188b3c963f7.jpg'), ('1','2','证件测试','20190312/6de5dbd9aa64653838fc57411c533ed1.jpg'), ('1','3','证件测试','20190402/e3844b8877b914cd3c765ac10a9cd65b.jpg');
INSERT INTO `country` VALUES ('1','China','中国'), ('2','America','美国');
INSERT INTO `crew_occupation_meaning` VALUES ('CAPT','机长'), ('F/A','乘务员'), ('F/M','机务'), ('F/O','副驾驶'), ('OTHER','其他');
INSERT INTO `flight_base` VALUES ('N676','2019-04-04 08:09:00','2019-04-04 07:08:00','6fcede7bb95e3e2410cd5af224f091a0',NULL), ('N689','2019-04-18 05:06:00','2019-04-12 05:06:00','cfa3deb109cde781ccac409f53956693',NULL), ('N689','2019-04-13 06:07:00','2019-04-13 06:07:00','9d20510591b84cb27525b055cc622e94',NULL), ('N689','2019-04-13 06:07:00','2019-04-13 06:07:00','3ecdb9fe2adb63ad1857f2ee97d565a7',NULL), ('N689','2019-04-13 06:07:00','2019-04-13 06:07:00','d0ec06cead427da97c6f19fee1c6288c',NULL), ('N689','2019-04-13 06:07:00','2019-04-13 06:07:00','41204d4bdd19a838d3485df334ac976e',NULL), ('N689','2019-04-13 06:07:00','2019-04-13 06:07:00','63a1ada5227901a529b9b4534b8f7052',NULL), ('N676','2019-04-05 04:05:00','2019-04-05 03:03:00','1a086a1e1c6ed590ab8ae786a6b57c23',NULL), ('N689','2019-04-06 05:06:00','2019-04-05 06:05:00','37be7b85e7d276134ad481085ea32cab',NULL);
INSERT INTO `flight_contain_leg` VALUES ('3ecdb9fe2adb63ad1857f2ee97d565a7','1','ABCD','2019-04-05 14:27:29.00000','CDEF','2019-04-05 14:27:38.00000','FERRY'), ('3ecdb9fe2adb63ad1857f2ee97d565a7','2','ABCD','2019-04-05 14:27:29.00000','CDEF','2019-04-05 14:27:38.00000','FERRY'), ('3ecdb9fe2adb63ad1857f2ee97d565a7','3','ABCD','2019-04-05 14:27:29.00000','CDEF','2019-04-05 14:27:38.00000','FERRY'), ('9d20510591b84cb27525b055cc622e94','1','ABCD','2019-04-05 14:27:29.00000','CDEF','2019-04-05 14:27:38.00000','FERRY');
INSERT INTO `flight_leg_airport_fbo` VALUES ('6fcede7bb95e3e2410cd5af224f091a0','1','经典款卡航段号','的几哈客户端咔汇顶科技看','345.678','312312','312231','PENDING');
INSERT INTO `flight_leg_crew_staff` VALUES ('6fcede7bb95e3e2410cd5af224f091a0','1','1','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','2','罗佳','M','F/O','2019-04-10','432423','天津','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','3','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','4','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','5','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','6','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','7','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','8','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','9','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','10','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','11','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','12','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','13','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','14','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','15','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','16','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','17','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','18','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','19','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','20','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','21','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国');
INSERT INTO `flight_leg_crew_transportation` VALUES ('6fcede7bb95e3e2410cd5af224f091a0','1','dasd','大卡车','葵司','783867812','2019-04-05 16:53:07','2019-04-05 16:53:11','建华大街','PENDING');
INSERT INTO `flight_leg_hotel` VALUES ('6fcede7bb95e3e2410cd5af224f091a0','1','ADBC','7天酒店','就看到巨好看','PENDING');
INSERT INTO `flight_leg_passenger` VALUES ('6fcede7bb95e3e2410cd5af224f091a0','1','1','罗佳','2019-04-05','M','7482278','2019-04-05','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','2','罗佳','2019-04-05','M','7482278','2019-04-05','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','3','罗佳','2019-04-05','M','7482278','2019-04-05','中国'), ('6fcede7bb95e3e2410cd5af224f091a0','1','4','罗佳','2019-04-05','M','7482278','2019-04-05','中国');
INSERT INTO `flight_leg_permit` VALUES ('6fcede7bb95e3e2410cd5af224f091a0','1','中国','OVF','17383812318','PENDING');
INSERT INTO `flight_leg_remarks` VALUES ('6fcede7bb95e3e2410cd5af224f091a0','1','旷达科技贺卡和贷款户打卡机');
INSERT INTO `flight_permission_type` VALUES ('OVF','飞越许可'), ('LDG','落地许可'), ('DEP SLOT','起飞时刻'), ('LDG SLOT','落地时刻'), ('PPR','停场许可'), ('LDG RIGHTS','落地权'), ('OTHER','其他');
INSERT INTO `flight_type` VALUES ('FERRY','调机飞行'), ('PRIVATE','私人飞行'), ('CHARTER','取酬飞行'), ('TEST','试飞'), ('OTHER','其他');
INSERT INTO `permission_status` VALUES ('PENDING','等待同意'), ('APPROVED','同意'), ('REJECTED','拒绝'), ('AMENDED AND PENDING','修改后等待同意');
INSERT INTO `staff_in_company` VALUES ('1','1','罗佳','M','F/O','2019-04-10','432423','432','2019-04-10','中国'), ('1','2','刘安琪1','M','F/O','2019-04-10','432423','432','2019-04-10','英语');
INSERT INTO `user_company` VALUES ('1','luojia','luojia','18666885775','522246447@qq.com','M','Chinese/中国','1');
INSERT INTO `user_servers` VALUES ('1','luojia','luojia','18666885775','522246447@qq.com','M','Chinese/中国','1','普通用户');
