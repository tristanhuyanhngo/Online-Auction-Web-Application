SET NAMES utf8mb4;

-- SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for Cap Danh Muc
-- ----------------------------
DROP TABLE IF EXISTS `big_category`;
CREATE TABLE `big_category` (
  `BigCatID` int unsigned NOT NULL AUTO_INCREMENT,
  `BigCatName` nvarchar(50) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`BigCatID`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for Danh Muc
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `CatID` int unsigned NOT NULL AUTO_INCREMENT,
  `CatName` nvarchar(50) COLLATE utf8_general_ci NOT NULL,
  `BigCat` int unsigned NOT NULL, 
  PRIMARY KEY (`CatID`),
  FOREIGN KEY (`BigCat`) REFERENCES big_category(`BigCatID`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `Email` char(50) COLLATE utf8_general_ci NOT NULL unique,
  `Username` varchar(50) COLLATE utf8_general_ci NOT NULL,
  `Password` varchar(255) COLLATE utf8_general_ci NOT NULL,
  `Name` nvarchar(50) COLLATE utf8_general_ci NOT NULL,
  `Address` nvarchar(80) COLLATE utf8_general_ci,
  `DOB` date,
  `RegisterDate` date NOT NULL,
  `Type` char(1) NOT NULL,
  `Rate` int unsigned,
  `RequestTime` datetime,
  `AcceptTime` datetime,
  `Valid` bit NOT NULL,
  `OTP` char(6),
  PRIMARY KEY (`Username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `ProID` int unsigned NOT NULL AUTO_INCREMENT,
  `CatID` int unsigned NOT NULL,
  `Seller` char(50) COLLATE utf8_general_ci NOT NULL , 
  `ProName` nvarchar(50) COLLATE utf8_general_ci NOT NULL,
  `StartPrice` int unsigned NOT NULL,
  `StepPrice` int unsigned NOT NULL,
  `SellPrice` int unsigned NOT NULL, 
  `UploadDate` datetime NOT NULL,
  `EndDate` datetime,
  `AutoExtend` bit NOT NULL, 
  `ProState` bit NOT NULL, 
  `CurrentWinner` char(50) COLLATE utf8_general_ci,
  `MaxPrice` int unsigned,
  
  PRIMARY KEY (`ProID`),
  FOREIGN KEY (`CatID`) REFERENCES category(`CatID`),
  FOREIGN KEY (`Seller`) REFERENCES user(`Email`),
  FOREIGN KEY (`CurrentWinner`) REFERENCES bidding(`Bidder`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for Images of Products
-- ----------------------------
DROP TABLE IF EXISTS `picture`;
CREATE TABLE `picture` (
  `ProID` int unsigned NOT NULL,
  `STT` int unsigned NOT NULL,
  `URL` char(50) NOT NULL,
  PRIMARY KEY (`ProID`,`STT`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for Description of Products
-- ----------------------------
DROP TABLE IF EXISTS `description`;
CREATE TABLE `description` (
  `ProID` int unsigned NOT NULL,
  `DesDate` datetime NOT NULL, 
  `Content` text COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`ProID`,`DesDate`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Danh sach yeu thich
-- ----------------------------
DROP TABLE IF EXISTS `wish_list`;
CREATE TABLE `wish_list` (
  `ProID` int unsigned NOT NULL,
  `Bidder` char(50) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`ProID`,`Bidder`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`),
  FOREIGN KEY (`Bidder`) REFERENCES user(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Gio hang
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `ProID` int unsigned NOT NULL,
  `Bidder` char(50) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`ProID`,`Bidder`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`),
  FOREIGN KEY (`Bidder`) REFERENCES user(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- San pham dang tham gia dau gia
-- ----------------------------
DROP TABLE IF EXISTS `bidding`;
CREATE TABLE `bidding` (
  `ProID` int unsigned NOT NULL,
  `Bidder` char(50) COLLATE utf8_general_ci NOT NULL,
  `Time` datetime NOT NULL,
  `Price` int unsigned NOT NULL,
  PRIMARY KEY (`ProID`,`Bidder`,`Time`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`),
  FOREIGN KEY (`Bidder`) REFERENCES user(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- San pham da tham gia dau gia thanh cong
-- ----------------------------
DROP TABLE IF EXISTS `success_bid`;
CREATE TABLE `success_bid` (
  `ProID` int unsigned NOT NULL,
  `Bidder` char(50) COLLATE utf8_general_ci NOT NULL,
  `OrderDate` datetime NOT NULL,
  PRIMARY KEY (`ProID`,`Bidder`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`),
  FOREIGN KEY (`Bidder`) REFERENCES user(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Danh sach Bidder khong duoc tham gia dau gia
-- ----------------------------
DROP TABLE IF EXISTS `restrict`;
CREATE TABLE `restrict` (
  `ProID` int unsigned NOT NULL,
  `Bidder` char(50) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`ProID`,`Bidder`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`),
  FOREIGN KEY (`Bidder`) REFERENCES user(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Danh Gia Bidder
-- ----------------------------
DROP TABLE IF EXISTS `rating`;
CREATE TABLE `rating` (
  `Receiver` char(50) COLLATE utf8_general_ci NOT NULL,
  `Sender` char(50) COLLATE utf8_general_ci NOT NULL,
  `ProID` int unsigned NOT NULL,
  `Comment` text COLLATE utf8_general_ci NOT NULL, 
  `Time` datetime NOT NULL,
  `Rate` bit NOT NULL, 
  PRIMARY KEY (`Receiver`,`Sender`,`ProID`),
  FOREIGN KEY (`Receiver`) REFERENCES user(`Email`),
  FOREIGN KEY (`Sender`) REFERENCES user(`Email`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- -- ----------------------------
-- -- Danh Gia Seller
-- -- ----------------------------
DROP TABLE IF EXISTS `seller_rate`;
-- CREATE TABLE `seller_rate` (
--   `Seller` char(50) COLLATE utf8_general_ci NOT NULL,
--   `Bidder` char(50) COLLATE utf8_general_ci NOT NULL,
--   `Comment` text COLLATE utf8_general_ci,
--   `Rate` tinyint NOT NULL,
--   PRIMARY KEY (`Seller`,`Bidder`),
--   FOREIGN KEY (`Bidder`) REFERENCES user(`Email`),
--   FOREIGN KEY (`Seller`) REFERENCES user(`Email`)
-- ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for userRefreshTokenExt
-- ----------------------------
DROP TABLE IF EXISTS `userRefreshTokenExt`;
CREATE TABLE `userRefreshTokenExt` (
  `ID` int(11) unsigned  NOT NULL,
  `refreshToken` varchar(255) COLLATE utf8_general_ci NOT NULL,
  `rdt` datetime(6) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Constraints

-- Insert Data

-- ----------------------------
-- Records of Danh Muc
-- ----------------------------
BEGIN;
INSERT INTO `big_category` VALUES (1, 'Accessories');
INSERT INTO `big_category` VALUES (2, 'Electronics');
INSERT INTO `big_category` VALUES (3, 'Fashion');
COMMIT;

-- ----------------------------
-- Records of Danh Muc
-- ----------------------------
BEGIN;
INSERT INTO `category` VALUES (1, 'Ring',1);
INSERT INTO `category` VALUES (2, 'Watch',1);
INSERT INTO `category` VALUES (3, 'Laptop',2);
INSERT INTO `category` VALUES (4, 'Mobile',2);
INSERT INTO `category` VALUES (5, 'Smart Watch',2);
INSERT INTO `category` VALUES (6, 'Clothing',3);
INSERT INTO `category` VALUES (7, 'Shoes',3);
COMMIT;

-- Admin (0) - Seller (1) - Bidder (2) 
-- ----------------------------
-- Records of Nguoi Ban
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('kysutainangqsb@gmail.com','seller1','seller1$2a$10$xetnvdbPChlxPad9GhQ3Y.LQVoxD5UF1FJ.4gtlPU7z3nr1UaXDdK','Ngô Minh Quân','154 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-01-01','2021-12-07','1',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('abc@gmail.com','seller2','$2a$12$9SHTJ2A2i/6S7CYi.Ylt0u4pa5duhBCnka.JhKgJ3dmHj1QLADvfC','Ngô Ngọc Đăng Khoa','155 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-02-01','2021-12-07','1',0,NULL,NULL,true,NULL);
COMMIT;

-- ----------------------------
-- Records of Admin
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('huyanhngo@gmail.com','Horizon_Administrator_1','$2a$10$xetnvdbPChlxPad9GhQ3Y.LQVoxD5UF1FJ.4gtlPU7z3nr1UaXDdK','Ngô Huy Anh','153 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','2001-01-01','2021-12-07','3',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('ngohuyanh@gmail.com','Horizon_Administrator_2','$2a$10$xetnvdbPChlxPad9GhQ3Y.LQVoxD5UF1FJ.4gtlPU7z3nr1UaXDdK','Ngô Huy Anh','153 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','2001-01-01','2021-12-07','3',0,NULL,NULL,true,NULL);
COMMIT;

-- ----------------------------
-- Records of Nguoi Mua
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('springfieldcaptain@gmail.com','bidder1','$2a$10$xetnvdbPChlxPad9GhQ3Y.LQVoxD5UF1FJ.4gtlPU7z3nr1UaXDdK','Ngô Minh Triết','156 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-01-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('xyz@gmail.com','bidder2','$2a$10$xetnvdbPChlxPad9GhQ3Y.LQVoxD5UF1FJ.4gtlPU7z3nr1UaXDdK','Ngô Ngọc Đăng Khôi','157 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-03-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('a@gmail.com','bidder3','$2a$12$ByiS6Z1yxCa6RT5TmQFueOtPath3trUECegh8JQGdoFP8YwtrbDTC','Ngô Ngọc Đăng Minh','158 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-04-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('b@gmail.com','bidder4','$2a$12$nz8f4u/XW3p4yDjwus6wIeTQv0pS1CXXgwQ2Yxx4GI/t1PHlDjsXG','Ngô Ngọc Đăng Khánh','159 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-05-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('c@gmail.com','bidder5','$2a$10$xetnvdbPChlxPad9GhQ3Y.LQVoxD5UF1FJ.4gtlPU7z3nr1UaXDdK','Ngô Ngọc Đăng Huy','160 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-06-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('vminathanhv@gmail.com','bidder6','$2a$12$ByiS6Z1yxCa6RT5TmQFueOtPath3trUECegh8JQGdoFP8YwtrbDTC','Thanh V','160 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-06-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('sinsin.4869@gmail.com','bidder7','$2a$12$ByiS6Z1yxCa6RT5TmQFueOtPath3trUECegh8JQGdoFP8YwtrbDTC','Thanh S','160 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-06-01','2021-12-07','2',0,NULL,NULL,true,NULL);
COMMIT;

-- ----------------------------
-- Records of San Pham
-- ----------------------------
BEGIN;

-- Ring
INSERT INTO `product` VALUES (1, 1, 'kysutainangqsb@gmail.com','Ring 1', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,'vminathanhv@gmail.com',950000);
INSERT INTO `product` VALUES (2, 1, 'kysutainangqsb@gmail.com','Ring 2', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,'b@gmail.com',600000);
INSERT INTO `product` VALUES (3, 1, 'kysutainangqsb@gmail.com','Ring 3', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (4, 1, 'kysutainangqsb@gmail.com','Ring 4', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (5, 1, 'kysutainangqsb@gmail.com','Ring 5', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);

-- Watch
INSERT INTO `product` VALUES (6, 2, 'kysutainangqsb@gmail.com','Watch 1', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (7, 2, 'kysutainangqsb@gmail.com','Watch 2', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (8, 2, 'kysutainangqsb@gmail.com','Watch 3', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (9, 2, 'kysutainangqsb@gmail.com','Watch 4', 200000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (10, 2, 'kysutainangqsb@gmail.com','Watch 5', 100000, 50000, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);

-- Latop
INSERT INTO `product` VALUES (11, 3, 'kysutainangqsb@gmail.com','Apple Macbook Pro 16 M1 Max 2021', 2000000, 100000, 20000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (12, 3, 'kysutainangqsb@gmail.com','Apple Macbook Pro 14 M1 Max 2021', 2000000, 100000, 20000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (13, 3, 'kysutainangqsb@gmail.com','Apple Macbook Air 2020', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (14, 3, 'kysutainangqsb@gmail.com','Asus Rog Zephyrus Gaming G14', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (15, 3, 'kysutainangqsb@gmail.com','Asus Zenbook UX371EA i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (16, 3, 'kysutainangqsb@gmail.com','Asus Zenbook Duo UX482EA i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (17, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (18, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (19, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (20, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (21, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (22, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (23, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (24, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (25, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);

-- Mobile
INSERT INTO `product` VALUES (26, 4, 'kysutainangqsb@gmail.com','Iphone 13 Pro', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (27, 4, 'kysutainangqsb@gmail.com','Xiaomi 10T Pro', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (28, 4, 'kysutainangqsb@gmail.com','Samsung Galaxy Z Flip 3 5G 256GB', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (29, 4, 'kysutainangqsb@gmail.com','Itel IT2171', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (30, 4, 'kysutainangqsb@gmail.com','Energizer E20', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);

-- Smart Watch
INSERT INTO `product` VALUES (31, 5, 'kysutainangqsb@gmail.com','Energizer E20', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (32, 5, 'kysutainangqsb@gmail.com','Energizer E20', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (33, 5, 'kysutainangqsb@gmail.com','Energizer E20', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (34, 5, 'kysutainangqsb@gmail.com','Energizer E20', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (35, 5, 'kysutainangqsb@gmail.com','Energizer E20', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);

-- Clothing
INSERT INTO `product` VALUES (36, 6, 'kysutainangqsb@gmail.com','T Shirt', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (37, 6, 'kysutainangqsb@gmail.com','Jeans', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);

-- Shoes
INSERT INTO `product` VALUES (38, 7, 'kysutainangqsb@gmail.com','Nike Air Force 1 07 QS', 100000, 2, 2000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (39, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Brown', 200000, 2, 1000000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (40, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Black', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (41, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Gray', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (42, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi RB', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (43, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Red', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (44, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Normal', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (45, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (46, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (47, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (48, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (49, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (50, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (51, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (52, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (53, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (54, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (55, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (56, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (57, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (58, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (59, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
INSERT INTO `product` VALUES (60, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2022-01-31', 1,1,NULL,NULL);
COMMIT;

-- ----------------------------
-- Records of Mo ta San Pham
-- ----------------------------
BEGIN;
INSERT INTO `description` VALUES (1, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (2, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (3, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (4, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (5, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (6, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (7, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (8, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (9, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (10, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (11, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (12, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (13, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (14, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (15, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (16, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (17, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (18, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (19, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (20, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (21, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (22, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (23, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (24, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (25, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (26, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (27, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (28, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (29, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (30, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (31, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (32, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (33, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (34, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (35, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (36, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (37, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (38, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (39, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (40, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (41, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (42, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (43, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (44, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (45, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (46, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (47, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (48, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (49, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (50, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (51, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (52, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (53, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (54, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (55, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (56, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (57, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (58, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (59, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `description` VALUES (60, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
COMMIT;

-- ----------------------------
-- Records of Wishlist
-- ----------------------------

BEGIN;
INSERT INTO `wish_list` VALUES (1, 'abc@gmail.com');
INSERT INTO `wish_list` VALUES (2, 'abc@gmail.com');
INSERT INTO `wish_list` VALUES (35, 'abc@gmail.com');
INSERT INTO `wish_list` VALUES (20, 'abc@gmail.com');
INSERT INTO `wish_list` VALUES (3, 'abc@gmail.com');
INSERT INTO `wish_list` VALUES (22, 'abc@gmail.com');
INSERT INTO `wish_list` VALUES (29, 'abc@gmail.com');
COMMIT;

-- ----------------------------
-- Records of cart
-- ----------------------------

BEGIN;
INSERT INTO `cart` VALUES (3, 'abc@gmail.com');
INSERT INTO `cart` VALUES (5, 'abc@gmail.com');
INSERT INTO `cart` VALUES (18, 'abc@gmail.com');
INSERT INTO `cart` VALUES (10, 'abc@gmail.com');
COMMIT;

-- ----------------------------
-- Records of won_bid
-- ----------------------------

BEGIN;
INSERT INTO `success_bid` VALUES (7, 'abc@gmail.com','2021-12-07');
INSERT INTO `success_bid` VALUES (8, 'abc@gmail.com','2021-12-07');
INSERT INTO `success_bid` VALUES (30, 'abc@gmail.com','2021-12-07');
INSERT INTO `success_bid` VALUES (33, 'abc@gmail.com','2021-12-07');
COMMIT;

-- ----------------------------
-- Records of bidding
-- ----------------------------

BEGIN;
INSERT INTO `bidding` VALUES (1, 'vminathanhv@gmail.com','2021-12-07 12:45:00',850000);
INSERT INTO `bidding` VALUES (1, 'b@gmail.com','2021-12-07 12:42:00',750000);
INSERT INTO `bidding` VALUES (1, 'c@gmail.com','2021-12-07 12:40:00',700000);
INSERT INTO `bidding` VALUES (1, 'abc@gmail.com','2021-12-07 12:36:00',650000);
INSERT INTO `bidding` VALUES (1, 'a@gmail.com','2021-12-07 12:35:00',600000);
INSERT INTO `bidding` VALUES (2, 'b@gmail.com','2021-12-07 12:35:00',600000);
INSERT INTO `bidding` VALUES (2, 'c@gmail.com','2021-12-07 12:32:00',550000);
INSERT INTO `bidding` VALUES (2, 'a@gmail.com','2021-12-07 12:20:00',500000);
COMMIT;