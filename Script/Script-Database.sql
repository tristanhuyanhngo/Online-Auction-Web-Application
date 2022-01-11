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
  `SellPrice` int unsigned, 
  `UploadDate` datetime NOT NULL,
  `EndDate` datetime,
  `AutoExtend` bit NOT NULL, 
  `ProState` bit NOT NULL, 
  `AllowAllUsers` bit NOT NULL, 
  `CurrentWinner` char(50) COLLATE utf8_general_ci,
  
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
  `MaxPrice` int unsigned,
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
  `Cancel` bit,
  PRIMARY KEY (`Receiver`,`Sender`,`ProID`),
  FOREIGN KEY (`Receiver`) REFERENCES user(`Email`),
  FOREIGN KEY (`Sender`) REFERENCES user(`Email`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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

-- ----------------------------
-- Table structure for Images of Products
-- ----------------------------
DROP TABLE IF EXISTS `picture`;
CREATE TABLE `picture` (
  `ProID` int unsigned NOT NULL,
  `STT` int unsigned NOT NULL AUTO_INCREMENT,
  `URL` char(200) NOT NULL,
  PRIMARY KEY (`ProID`,`STT`),
  FOREIGN KEY (`ProID`) REFERENCES product(`ProID`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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

-- Seller (1) - Bidder (2) - Admin (3)
-- ----------------------------
-- Records of Seller
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('kysutainangqsb@gmail.com','seller1','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Ngô Huy Anh','154 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-01-01','2021-12-07','1',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('tristanhuyanhngo@gmail.com','seller2','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Tristan Anh Ngô','155 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-02-01','2021-12-07','1',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('thanhhoang4869@gmail.com','seller3','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Hoàng Như Thanh','155 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-03-01','2021-12-07','1',0,NULL,NULL,true,NULL);
COMMIT;

-- ----------------------------
-- Records of Admin
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('huyanhngo@gmail.com','admin1','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Ngô Huy Anh','153 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','2001-01-01','2021-12-07','3',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('sinsin.4869@gmail.com','admin2','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Hoàng Như Thanh','153 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','2001-01-01','2021-12-07','3',0,NULL,NULL,true,NULL);
COMMIT;

-- ----------------------------
-- Records of Bidder
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('phucthai0108@gmail.com','phuc','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Phuc Thai','156 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-01-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('springfieldcaptain@gmail.com','bidder1','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Ngô Minh Triết','156 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-01-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('tristan.hcmus.study@gmail.com','bidder2','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Ngô Ngọc Đăng Khôi','157 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-03-01','2021-12-07','2',0,NULL,NULL,true,NULL);
INSERT INTO `user` VALUES ('vminathanhv@gmail.com','bidder3','$2a$10$Aq.r.RZmDExi19OZkzKqW.7BrhuVHL8nYWVh7vtHCiS/MeM55wIOG','Thanh V','160 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-06-01','2021-12-07','2',0,NULL,NULL,true,NULL);
COMMIT;

-- ----------------------------
-- Records of Product
-- ----------------------------
BEGIN;

-- Ring
INSERT INTO `product` VALUES (1,1,'thanhhoang4869@gmail.com','Silver Ring STYLE By PNJ 0000H000007',250000,50000,2000000,'2021-12-07','2022-01-31',0,1,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (2,1,'thanhhoang4869@gmail.com','Ruby Ring STYLE By PNJ XM00X000009',250000,50000,2000000,'2021-12-07','2022-01-31',0,1,0,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (3,1,'kysutainangqsb@gmail.com','Gold Ring with Ruby STYLE By PNJ XM00C060000',250000,50000,2000000,'2021-12-07','2022-01-31',0,1,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (4,1,'kysutainangqsb@gmail.com','Diamond Ring STYLE By PNJ DNA XMXMX000004',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (5,1,'kysutainangqsb@gmail.com','10K White Gold Ring PNJ XMXMW001741',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'sinsin.4869@gmail.com');

INSERT INTO `product` VALUES (6,2,'kysutainangqsb@gmail.com','Citizen C7 NH8395-77E',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (7,2,'thanhhoang4869@gmail.com','MVW MS074-01',500000,100000,2000000,'2021-12-07','2022-01-31',0,0,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (8,2,'thanhhoang4869@gmail.com','G-SHOCK GBA-900-1ADR',500000,100000,2000000,'2021-12-07','2022-01-31',0,0,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (9,2,'kysutainangqsb@gmail.com','Smile Kid SL215L-9',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (10,2,'kysutainangqsb@gmail.com','Fossil ES4836 for Woman',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'springfieldcaptain@gmail.com');

INSERT INTO `product` VALUES (11,3,'thanhhoang4869@gmail.com','Apple Macbook Pro 16 M1 Max 2021',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'huyanhngo@gmail.com');
INSERT INTO `product` VALUES (12,3,'thanhhoang4869@gmail.com','Apple Macbook Pro 14 M1 Max 2021',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'huyanhngo@gmail.com');
INSERT INTO `product` VALUES (13,3,'thanhhoang4869@gmail.com','Apple Macbook Air 2020',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (14,3,'thanhhoang4869@gmail.com','Asus Rog Zephyrus Gaming G14',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (15,3,'thanhhoang4869@gmail.com','Asus Zenbook UX371EA i7',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (16,3,'thanhhoang4869@gmail.com','Asus Zenbook Duo UX482EA i7',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'tristan.hcmus.study@gmail.com');
INSERT INTO `product` VALUES (17,3,'thanhhoang4869@gmail.com','HP Omen 15 EK0078TX i7',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'huyanhngo@gmail.com');
INSERT INTO `product` VALUES (18,3,'thanhhoang4869@gmail.com','HP Wow 8TX i5',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'huyanhngo@gmail.com');
INSERT INTO `product` VALUES (19,3,'thanhhoang4869@gmail.com','HP White',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (20,3,'kysutainangqsb@gmail.com','Acer Predator Helios',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'tristan.hcmus.study@gmail.com');
INSERT INTO `product` VALUES (21,3,'kysutainangqsb@gmail.com','Acer Triton',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (22,3,'kysutainangqsb@gmail.com','Dell Gaming',2000000,1000000,20000000,'2021-12-07','2022-01-31',1,1,1,'huyanhngo@gmail.com');
INSERT INTO `product` VALUES (23,3,'kysutainangqsb@gmail.com','Dell Blue',2000000,1000000,20000000,'2021-12-07','2022-01-31',1,1,1,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (24,3,'tristanhuyanhngo@gmail.com','LG Gram',2000000,1000000,20000000,'2021-12-07','2022-01-31',1,1,1,'tristan.hcmus.study@gmail.com');
INSERT INTO `product` VALUES (25,3,'tristanhuyanhngo@gmail.com','Lenovo Idea Pad Gaming 3',2000000,1000000,20000000,'2021-12-07','2022-01-31',1,1,1,'thanhhoang4869@gmail.com');

INSERT INTO `product` VALUES (26,4,'thanhhoang4869@gmail.com','Iphone 13 Pro',2000000,500000,20000000,'2021-12-07','2022-01-31',0,1,0,'tristan.hcmus.study@gmail.com');
INSERT INTO `product` VALUES (27,4,'thanhhoang4869@gmail.com','Xiaomi 10T Pro',2000000,500000,20000000,'2021-12-07','2022-01-31',0,1,0,'tristanhuyanhngo@gmail.com');
INSERT INTO `product` VALUES (28,4,'tristanhuyanhngo@gmail.com','Samsung Galaxy Z Flip 3 5G 256GB',2000000,1000000,20000000,'2021-12-07','2022-01-31',0,1,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (29,4,'tristanhuyanhngo@gmail.com','Itel IT2171',2000000,1000000,20000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (30,4,'kysutainangqsb@gmail.com','Energizer E20',2000000,1000000,20000000,'2021-12-07','2022-01-31',0,0,0,'vminathanhv@gmail.com');

INSERT INTO `product` VALUES (31,5,'thanhhoang4869@gmail.com','Mi Band 5',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (32,5,'thanhhoang4869@gmail.com','Samsung Galaxy Watch 4',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (33,5,'tristanhuyanhngo@gmail.com','Garmin Fenix 4',500000,100000,2000000,'2021-12-07','2022-01-31',0,0,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (34,5,'kysutainangqsb@gmail.com','Beu KW03',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (35,5,'kysutainangqsb@gmail.com','Garmin Lily Day',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'phucthai0108@gmail.com');

INSERT INTO `product` VALUES (36,6,'kysutainangqsb@gmail.com','T Shirt',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (37,6,'kysutainangqsb@gmail.com','Jeans',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'tristanhuyanhngo@gmail.com');

INSERT INTO `product` VALUES (38,7,'thanhhoang4869@gmail.com','Nike Air Force 1 07 QS',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (39,7,'thanhhoang4869@gmail.com','Nike Blazer Mid 77 Cozi Brown',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (40,7,'thanhhoang4869@gmail.com','Nike Spagetti',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'huyanhngo@gmail.com');
INSERT INTO `product` VALUES (41,7,'thanhhoang4869@gmail.com','Nike Cookies',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (42,7,'thanhhoang4869@gmail.com','Nike Blazer Mid 77 Cozi RB',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (43,7,'thanhhoang4869@gmail.com','Nike Try',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'tristan.hcmus.study@gmail.com');
INSERT INTO `product` VALUES (44,7,'tristanhuyanhngo@gmail.com','Nike Rice',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (45,7,'kysutainangqsb@gmail.com','Nike Kentucky',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'sinsin.4869@gmail.com');

COMMIT;

-- ----------------------------
-- Records of product's description
-- ----------------------------
BEGIN;
-- RING
INSERT INTO `description` VALUES (1, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (2, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (3, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (4, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (5, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (6, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (7, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (8, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (9, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (10, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (11, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (12, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (13, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (14, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (15, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (16, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (17, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (18, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (19, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (20, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (21, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (22, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (23, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (24, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (25, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (26, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (27, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (28, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (29, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (30, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (31, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (32, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (33, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (34, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (35, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (36, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (37, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (38, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (39, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (40, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (41, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (42, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (43, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (44, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
INSERT INTO `description` VALUES (45, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P><br><UL><LI>Brand: PNJ STYLE</LI><LI>Main stone type: No rhinestones</LI><LI>Sub-stone type (if any): No stones</LI><LI>Gender: Female</LI></UL><br><P>Explore and let its vibrant, colorful designs inspire you to tell your own unique story in an exciting way. Possessing a unique design with sparkling colorful stone accents, the STYLE By PNJ silver ring will enhance the personality and sophistication of the pretty girl.</P>');
COMMIT;

-- ----------------------------
-- Records of Wishlist
-- ----------------------------

BEGIN;
INSERT INTO `wish_list` VALUES (1, 'vminathanhv@gmail.com');
INSERT INTO `wish_list` VALUES (2, 'vminathanhv@gmail.com');
INSERT INTO `wish_list` VALUES (35, 'vminathanhv@gmail.com');
INSERT INTO `wish_list` VALUES (20, 'vminathanhv@gmail.com');
INSERT INTO `wish_list` VALUES (3, 'vminathanhv@gmail.com');
INSERT INTO `wish_list` VALUES (22, 'vminathanhv@gmail.com');
INSERT INTO `wish_list` VALUES (29, 'vminathanhv@gmail.com');
COMMIT;

-- ----------------------------
-- Records of cart
-- ----------------------------

BEGIN;
INSERT INTO `cart` VALUES (3, 'vminathanhv@gmail.com');
INSERT INTO `cart` VALUES (5, 'vminathanhv@gmail.com');
INSERT INTO `cart` VALUES (18, 'vminathanhv@gmail.com');
INSERT INTO `cart` VALUES (10, 'vminathanhv@gmail.com');
COMMIT;

-- ----------------------------
-- Records of won_bid
-- ----------------------------

BEGIN;
INSERT INTO `success_bid` VALUES (7, 'vminathanhv@gmail.comm','2021-12-07');
INSERT INTO `success_bid` VALUES (8, 'vminathanhv@gmail.com','2021-12-07');
INSERT INTO `success_bid` VALUES (30, 'vminathanhv@gmail.com','2021-12-07');
INSERT INTO `success_bid` VALUES (33, 'vminathanhv@gmail.com','2021-12-07');
COMMIT;

-- ----------------------------
-- Records of bidding
-- ----------------------------

BEGIN;
INSERT INTO `bidding` VALUES (4,'thanhhoang4869@gmail.com','2021-12-10 23:35:26',600000,900000);
INSERT INTO `bidding` VALUES (4,'thanhhoang4869@gmail.com','2021-12-14 23:10:52',700000,900000);
INSERT INTO `bidding` VALUES (4,'springfieldcaptain@gmail.com','2021-12-18 22:46:18',1000000,1200000);
INSERT INTO `bidding` VALUES (4,'huyanhngo@gmail.com','2021-12-22 22:21:44',1300000,1400000);
INSERT INTO `bidding` VALUES (4,'sinsin.4869@gmail.com','2021-12-26 21:57:10',1500000,1600000);
INSERT INTO `bidding` VALUES (4,'sinsin.4869@gmail.com','2021-12-30 21:32:36',1600000,1600000);
INSERT INTO `bidding` VALUES (4,'thanhhoang4869@gmail.com','2022-01-03 21:08:02',1700000,1800000);

INSERT INTO `bidding` VALUES (5,'thanhhoang4869@gmail.com','2021-12-10 06:12:37',600000,1000000);
INSERT INTO `bidding` VALUES (5,'thanhhoang4869@gmail.com','2021-12-13 12:25:15',700000,1000000);
INSERT INTO `bidding` VALUES (5,'tristanhuyanhngo@gmail.com','2021-12-16 18:37:53',1100000,1100000);
INSERT INTO `bidding` VALUES (5,'sinsin.4869@gmail.com','2021-12-20 00:50:30',1200000,1300000);
INSERT INTO `bidding` VALUES (5,'sinsin.4869@gmail.com','2021-12-23 07:03:08',1300000,1300000);
INSERT INTO `bidding` VALUES (5,'phucthai0108@gmail.com','2021-12-26 13:15:46',1400000,1500000);
INSERT INTO `bidding` VALUES (5,'phucthai0108@gmail.com','2021-12-29 19:28:24',1500000,1500000);
INSERT INTO `bidding` VALUES (5,'huyanhngo@gmail.com','2022-01-02 01:41:01',1600000,1700000);
INSERT INTO `bidding` VALUES (5,'sinsin.4869@gmail.com','2022-01-05 07:53:39',1800000,1800000);

INSERT INTO `bidding` VALUES (6,'springfieldcaptain@gmail.com','2021-12-12 02:54:07',600000,1100000);
INSERT INTO `bidding` VALUES (6,'springfieldcaptain@gmail.com','2021-12-17 05:48:15',700000,1100000);
INSERT INTO `bidding` VALUES (6,'springfieldcaptain@gmail.com','2021-12-22 08:42:23',800000,1100000);
INSERT INTO `bidding` VALUES (6,'springfieldcaptain@gmail.com','2021-12-27 11:36:31',900000,1100000);
INSERT INTO `bidding` VALUES (6,'thanhhoang4869@gmail.com','2022-01-01 14:30:39',1200000,1500000);

INSERT INTO `bidding` VALUES (9,'sinsin.4869@gmail.com','2021-12-11 11:32:21',600000,800000);
INSERT INTO `bidding` VALUES (9,'phucthai0108@gmail.com','2021-12-15 23:04:43',900000,1400000);
INSERT INTO `bidding` VALUES (9,'thanhhoang4869@gmail.com','2021-12-20 10:37:05',1500000,1500000);
INSERT INTO `bidding` VALUES (9,'springfieldcaptain@gmail.com','2021-12-24 22:09:27',1600000,1600000);
INSERT INTO `bidding` VALUES (9,'huyanhngo@gmail.com','2021-12-29 09:41:49',1700000,1700000);
INSERT INTO `bidding` VALUES (9,'thanhhoang4869@gmail.com','2022-01-02 21:14:11',1800000,1800000);

INSERT INTO `bidding` VALUES (10,'thanhhoang4869@gmail.com','2021-12-09 23:41:34',600000,800000);
INSERT INTO `bidding` VALUES (10,'thanhhoang4869@gmail.com','2021-12-12 23:23:09',700000,800000);
INSERT INTO `bidding` VALUES (10,'tristan.hcmus.study@gmail.com','2021-12-15 23:04:43',900000,1000000);
INSERT INTO `bidding` VALUES (10,'sinsin.4869@gmail.com','2021-12-18 22:46:18',1100000,1200000);
INSERT INTO `bidding` VALUES (10,'sinsin.4869@gmail.com','2021-12-21 22:27:52',1200000,1200000);
INSERT INTO `bidding` VALUES (10,'huyanhngo@gmail.com','2021-12-24 22:09:27',1300000,1300000);
INSERT INTO `bidding` VALUES (10,'tristanhuyanhngo@gmail.com','2021-12-27 21:51:02',1400000,1400000);
INSERT INTO `bidding` VALUES (10,'sinsin.4869@gmail.com','2021-12-30 21:32:36',1500000,1600000);
INSERT INTO `bidding` VALUES (10,'phucthai0108@gmail.com','2022-01-02 21:14:11',1700000,1700000);
INSERT INTO `bidding` VALUES (10,'springfieldcaptain@gmail.com','2022-01-05 20:55:45',1800000,1800000);

INSERT INTO `bidding` VALUES (11,'springfieldcaptain@gmail.com','2021-12-10 06:12:37',2500000,15000000);
INSERT INTO `bidding` VALUES (11,'springfieldcaptain@gmail.com','2021-12-13 12:25:15',3000000,15000000);
INSERT INTO `bidding` VALUES (11,'vminathanhv@gmail.com','2021-12-16 18:37:53',15500000,16000000);
INSERT INTO `bidding` VALUES (11,'sinsin.4869@gmail.com','2021-12-20 00:50:30',16500000,16500000);
INSERT INTO `bidding` VALUES (11,'springfieldcaptain@gmail.com','2021-12-23 07:03:08',17000000,17000000);
INSERT INTO `bidding` VALUES (11,'phucthai0108@gmail.com','2021-12-26 13:15:46',17500000,17500000);
INSERT INTO `bidding` VALUES (11,'tristanhuyanhngo@gmail.com','2021-12-29 19:28:24',18000000,18000000);
INSERT INTO `bidding` VALUES (11,'sinsin.4869@gmail.com','2022-01-02 01:41:01',18500000,18500000);
INSERT INTO `bidding` VALUES (11,'huyanhngo@gmail.com','2022-01-05 07:53:39',19000000,19000000);

INSERT INTO `bidding` VALUES (12,'phucthai0108@gmail.com','2021-12-12 02:54:07',2500000,5500000);
INSERT INTO `bidding` VALUES (12,'tristan.hcmus.study@gmail.com','2021-12-17 05:48:15',6000000,16000000);
INSERT INTO `bidding` VALUES (12,'tristan.hcmus.study@gmail.com','2021-12-22 08:42:23',6500000,16000000);
INSERT INTO `bidding` VALUES (12,'tristan.hcmus.study@gmail.com','2021-12-27 11:36:31',7000000,16000000);
INSERT INTO `bidding` VALUES (12,'huyanhngo@gmail.com','2022-01-01 14:30:39',16500000,18000000);

INSERT INTO `bidding` VALUES (13,'tristanhuyanhngo@gmail.com','2021-12-10 14:01:53',2500000,6500000);
INSERT INTO `bidding` VALUES (13,'vminathanhv@gmail.com','2021-12-14 04:03:47',7000000,8500000);
INSERT INTO `bidding` VALUES (13,'sinsin.4869@gmail.com','2021-12-17 18:05:40',9000000,9500000);
INSERT INTO `bidding` VALUES (13,'springfieldcaptain@gmail.com','2021-12-21 08:07:34',10000000,10000000);
INSERT INTO `bidding` VALUES (13,'sinsin.4869@gmail.com','2021-12-24 22:09:27',10500000,11500000);
INSERT INTO `bidding` VALUES (13,'phucthai0108@gmail.com','2021-12-28 12:11:21',12000000,15500000);
INSERT INTO `bidding` VALUES (13,'springfieldcaptain@gmail.com','2022-01-01 02:13:14',16000000,17000000);
INSERT INTO `bidding` VALUES (13,'springfieldcaptain@gmail.com','2022-01-04 16:15:08',16500000,17000000);

INSERT INTO `bidding` VALUES (14,'vminathanhv@gmail.com','2021-12-10 06:12:37',2500000,14000000);
INSERT INTO `bidding` VALUES (14,'vminathanhv@gmail.com','2021-12-13 12:25:15',3000000,14000000);
INSERT INTO `bidding` VALUES (14,'sinsin.4869@gmail.com','2021-12-16 18:37:53',14500000,15000000);
INSERT INTO `bidding` VALUES (14,'vminathanhv@gmail.com','2021-12-20 00:50:30',15500000,16500000);
INSERT INTO `bidding` VALUES (14,'tristan.hcmus.study@gmail.com','2021-12-23 07:03:08',17000000,17000000);
INSERT INTO `bidding` VALUES (14,'springfieldcaptain@gmail.com','2021-12-26 13:15:46',17500000,17500000);
INSERT INTO `bidding` VALUES (14,'sinsin.4869@gmail.com','2021-12-29 19:28:24',18000000,18000000);
INSERT INTO `bidding` VALUES (14,'vminathanhv@gmail.com','2022-01-02 01:41:01',18500000,18500000);
INSERT INTO `bidding` VALUES (14,'phucthai0108@gmail.com','2022-01-05 07:53:39',19000000,19000000);

INSERT INTO `bidding` VALUES (15,'sinsin.4869@gmail.com','2021-12-10 06:12:37',2500000,6500000);
INSERT INTO `bidding` VALUES (15,'vminathanhv@gmail.com','2021-12-13 12:25:15',7000000,15500000);
INSERT INTO `bidding` VALUES (15,'vminathanhv@gmail.com','2021-12-16 18:37:53',7500000,15500000);
INSERT INTO `bidding` VALUES (15,'vminathanhv@gmail.com','2021-12-20 00:50:30',8000000,15500000);
INSERT INTO `bidding` VALUES (15,'vminathanhv@gmail.com','2021-12-23 07:03:08',8500000,15500000);
INSERT INTO `bidding` VALUES (15,'springfieldcaptain@gmail.com','2021-12-26 13:15:46',16000000,17500000);
INSERT INTO `bidding` VALUES (15,'sinsin.4869@gmail.com','2021-12-29 19:28:24',18000000,18000000);
INSERT INTO `bidding` VALUES (15,'tristanhuyanhngo@gmail.com','2022-01-02 01:41:01',18500000,18500000);
INSERT INTO `bidding` VALUES (15,'sinsin.4869@gmail.com','2022-01-05 07:53:39',19000000,19000000);

INSERT INTO `bidding` VALUES (16,'vminathanhv@gmail.com','2021-12-10 23:35:26',2500000,11000000);
INSERT INTO `bidding` VALUES (16,'tristanhuyanhngo@gmail.com','2021-12-14 23:10:52',11500000,11500000);
INSERT INTO `bidding` VALUES (16,'sinsin.4869@gmail.com','2021-12-18 22:46:18',12000000,12500000);
INSERT INTO `bidding` VALUES (16,'springfieldcaptain@gmail.com','2021-12-22 22:21:44',13000000,13500000);
INSERT INTO `bidding` VALUES (16,'tristan.hcmus.study@gmail.com','2021-12-26 21:57:10',14000000,15000000);
INSERT INTO `bidding` VALUES (16,'springfieldcaptain@gmail.com','2021-12-30 21:32:36',15500000,16500000);
INSERT INTO `bidding` VALUES (16,'tristan.hcmus.study@gmail.com','2022-01-03 21:08:02',17000000,19000000);

INSERT INTO `bidding` VALUES (17,'springfieldcaptain@gmail.com','2021-12-10 23:35:26',2500000,9000000);
INSERT INTO `bidding` VALUES (17,'tristanhuyanhngo@gmail.com','2021-12-14 23:10:52',9500000,12500000);
INSERT INTO `bidding` VALUES (17,'phucthai0108@gmail.com','2021-12-18 22:46:18',13000000,13500000);
INSERT INTO `bidding` VALUES (17,'vminathanhv@gmail.com','2021-12-22 22:21:44',14000000,14000000);
INSERT INTO `bidding` VALUES (17,'springfieldcaptain@gmail.com','2021-12-26 21:57:10',14500000,15500000);
INSERT INTO `bidding` VALUES (17,'springfieldcaptain@gmail.com','2021-12-30 21:32:36',15000000,15500000);
INSERT INTO `bidding` VALUES (17,'huyanhngo@gmail.com','2022-01-03 21:08:02',16000000,19000000);

INSERT INTO `bidding` VALUES (18,'phucthai0108@gmail.com','2021-12-10 06:12:37',2500000,9500000);
INSERT INTO `bidding` VALUES (18,'phucthai0108@gmail.com','2021-12-13 12:25:15',3000000,9500000);
INSERT INTO `bidding` VALUES (18,'phucthai0108@gmail.com','2021-12-16 18:37:53',3500000,9500000);
INSERT INTO `bidding` VALUES (18,'phucthai0108@gmail.com','2021-12-20 00:50:30',4000000,9500000);
INSERT INTO `bidding` VALUES (18,'tristanhuyanhngo@gmail.com','2021-12-23 07:03:08',10000000,10000000);
INSERT INTO `bidding` VALUES (18,'huyanhngo@gmail.com','2021-12-26 13:15:46',10500000,16500000);
INSERT INTO `bidding` VALUES (18,'huyanhngo@gmail.com','2021-12-29 19:28:24',11000000,16500000);
INSERT INTO `bidding` VALUES (18,'huyanhngo@gmail.com','2022-01-02 01:41:01',11500000,16500000);
INSERT INTO `bidding` VALUES (18,'huyanhngo@gmail.com','2022-01-05 07:53:39',12000000,16500000);

INSERT INTO `bidding` VALUES (19,'tristanhuyanhngo@gmail.com','2021-12-12 02:54:07',2500000,4000000);
INSERT INTO `bidding` VALUES (19,'springfieldcaptain@gmail.com','2021-12-17 05:48:15',4500000,9500000);
INSERT INTO `bidding` VALUES (19,'phucthai0108@gmail.com','2021-12-22 08:42:23',10000000,13000000);
INSERT INTO `bidding` VALUES (19,'phucthai0108@gmail.com','2021-12-27 11:36:31',10500000,13000000);
INSERT INTO `bidding` VALUES (19,'phucthai0108@gmail.com','2022-01-01 14:30:39',11000000,13000000);

INSERT INTO `bidding` VALUES (20,'sinsin.4869@gmail.com','2021-12-11 11:32:21',2500000,11000000);
INSERT INTO `bidding` VALUES (20,'thanhhoang4869@gmail.com','2021-12-15 23:04:43',11500000,13500000);
INSERT INTO `bidding` VALUES (20,'thanhhoang4869@gmail.com','2021-12-20 10:37:05',12000000,13500000);
INSERT INTO `bidding` VALUES (20,'springfieldcaptain@gmail.com','2021-12-24 22:09:27',14000000,15000000);
INSERT INTO `bidding` VALUES (20,'tristanhuyanhngo@gmail.com','2021-12-29 09:41:49',15500000,17500000);
INSERT INTO `bidding` VALUES (20,'tristan.hcmus.study@gmail.com','2022-01-02 21:14:11',18000000,18000000);

INSERT INTO `bidding` VALUES (21,'sinsin.4869@gmail.com','2021-12-11 11:32:21',2500000,12000000);
INSERT INTO `bidding` VALUES (21,'sinsin.4869@gmail.com','2021-12-15 23:04:43',3000000,12000000);
INSERT INTO `bidding` VALUES (21,'phucthai0108@gmail.com','2021-12-20 10:37:05',12500000,17000000);
INSERT INTO `bidding` VALUES (21,'phucthai0108@gmail.com','2021-12-24 22:09:27',13000000,17000000);
INSERT INTO `bidding` VALUES (21,'phucthai0108@gmail.com','2021-12-29 09:41:49',13500000,17000000);
INSERT INTO `bidding` VALUES (21,'vminathanhv@gmail.com','2022-01-02 21:14:11',17500000,18500000);

INSERT INTO `bidding` VALUES (22,'thanhhoang4869@gmail.com','2021-12-11 11:32:21',3000000,10000000);
INSERT INTO `bidding` VALUES (22,'thanhhoang4869@gmail.com','2021-12-15 23:04:43',4000000,10000000);
INSERT INTO `bidding` VALUES (22,'springfieldcaptain@gmail.com','2021-12-20 10:37:05',11000000,13000000);
INSERT INTO `bidding` VALUES (22,'springfieldcaptain@gmail.com','2021-12-24 22:09:27',12000000,13000000);
INSERT INTO `bidding` VALUES (22,'thanhhoang4869@gmail.com','2021-12-29 09:41:49',14000000,17000000);
INSERT INTO `bidding` VALUES (22,'huyanhngo@gmail.com','2022-01-02 21:14:11',18000000,18000000);

INSERT INTO `bidding` VALUES (23,'huyanhngo@gmail.com','2021-12-11 11:32:21',3000000,11000000);
INSERT INTO `bidding` VALUES (23,'huyanhngo@gmail.com','2021-12-15 23:04:43',4000000,11000000);
INSERT INTO `bidding` VALUES (23,'vminathanhv@gmail.com','2021-12-20 10:37:05',12000000,12000000);
INSERT INTO `bidding` VALUES (23,'huyanhngo@gmail.com','2021-12-24 22:09:27',13000000,15000000);
INSERT INTO `bidding` VALUES (23,'huyanhngo@gmail.com','2021-12-29 09:41:49',14000000,15000000);
INSERT INTO `bidding` VALUES (23,'vminathanhv@gmail.com','2022-01-02 21:14:11',16000000,16000000);

INSERT INTO `bidding` VALUES (24,'vminathanhv@gmail.com','2021-12-12 02:54:07',3000000,12000000);
INSERT INTO `bidding` VALUES (24,'vminathanhv@gmail.com','2021-12-17 05:48:15',4000000,12000000);
INSERT INTO `bidding` VALUES (24,'springfieldcaptain@gmail.com','2021-12-22 08:42:23',13000000,14000000);
INSERT INTO `bidding` VALUES (24,'vminathanhv@gmail.com','2021-12-27 11:36:31',15000000,16000000);
INSERT INTO `bidding` VALUES (24,'tristan.hcmus.study@gmail.com','2022-01-01 14:30:39',17000000,18000000);

INSERT INTO `bidding` VALUES (25,'huyanhngo@gmail.com','2021-12-11 11:32:21',3000000,9000000);
INSERT INTO `bidding` VALUES (25,'springfieldcaptain@gmail.com','2021-12-15 23:04:43',10000000,13000000);
INSERT INTO `bidding` VALUES (25,'springfieldcaptain@gmail.com','2021-12-20 10:37:05',11000000,13000000);
INSERT INTO `bidding` VALUES (25,'springfieldcaptain@gmail.com','2021-12-24 22:09:27',12000000,13000000);
INSERT INTO `bidding` VALUES (25,'vminathanhv@gmail.com','2021-12-29 09:41:49',14000000,14000000);
INSERT INTO `bidding` VALUES (25,'thanhhoang4869@gmail.com','2022-01-02 21:14:11',15000000,15000000);

INSERT INTO `bidding` VALUES (26,'phucthai0108@gmail.com','2021-12-09 23:41:34',2500000,3500000);
INSERT INTO `bidding` VALUES (26,'tristan.hcmus.study@gmail.com','2021-12-12 23:23:09',4000000,11500000);
INSERT INTO `bidding` VALUES (26,'sinsin.4869@gmail.com','2021-12-15 23:04:43',12000000,13000000);
INSERT INTO `bidding` VALUES (26,'sinsin.4869@gmail.com','2021-12-18 22:46:18',12500000,13000000);
INSERT INTO `bidding` VALUES (26,'tristan.hcmus.study@gmail.com','2021-12-21 22:27:53',13500000,16500000);
INSERT INTO `bidding` VALUES (26,'tristan.hcmus.study@gmail.com','2021-12-24 22:09:27',14000000,16500000);
INSERT INTO `bidding` VALUES (26,'sinsin.4869@gmail.com','2021-12-27 21:51:02',17000000,17000000);
INSERT INTO `bidding` VALUES (26,'huyanhngo@gmail.com','2021-12-30 21:32:36',17500000,17500000);
INSERT INTO `bidding` VALUES (26,'sinsin.4869@gmail.com','2022-01-02 21:14:11',18000000,18000000);
INSERT INTO `bidding` VALUES (26,'tristan.hcmus.study@gmail.com','2022-01-05 20:55:46',18500000,18500000);

INSERT INTO `bidding` VALUES (27,'springfieldcaptain@gmail.com','2021-12-12 02:54:07',2500000,8500000);
INSERT INTO `bidding` VALUES (27,'sinsin.4869@gmail.com','2021-12-17 05:48:15',9000000,9000000);
INSERT INTO `bidding` VALUES (27,'tristanhuyanhngo@gmail.com','2021-12-22 08:42:23',9500000,18000000);
INSERT INTO `bidding` VALUES (27,'tristanhuyanhngo@gmail.com','2021-12-27 11:36:31',10000000,18000000);
INSERT INTO `bidding` VALUES (27,'tristanhuyanhngo@gmail.com','2022-01-01 14:30:39',10500000,18000000);

INSERT INTO `bidding` VALUES (28,'phucthai0108@gmail.com','2021-12-12 02:54:07',3000000,4000000);
INSERT INTO `bidding` VALUES (28,'vminathanhv@gmail.com','2021-12-17 05:48:15',5000000,13000000);
INSERT INTO `bidding` VALUES (28,'vminathanhv@gmail.com','2021-12-22 08:42:23',6000000,13000000);
INSERT INTO `bidding` VALUES (28,'vminathanhv@gmail.com','2021-12-27 11:36:31',7000000,13000000);
INSERT INTO `bidding` VALUES (28,'vminathanhv@gmail.com','2022-01-01 14:30:39',8000000,13000000);

INSERT INTO `bidding` VALUES (29,'springfieldcaptain@gmail.com','2021-12-10 14:01:53',3000000,7000000);
INSERT INTO `bidding` VALUES (29,'vminathanhv@gmail.com','2021-12-14 04:03:47',8000000,9000000);
INSERT INTO `bidding` VALUES (29,'springfieldcaptain@gmail.com','2021-12-17 18:05:40',10000000,12000000);
INSERT INTO `bidding` VALUES (29,'phucthai0108@gmail.com','2021-12-21 08:07:34',13000000,13000000);
INSERT INTO `bidding` VALUES (29,'sinsin.4869@gmail.com','2021-12-24 22:09:27',14000000,15000000);
INSERT INTO `bidding` VALUES (29,'thanhhoang4869@gmail.com','2021-12-28 12:11:21',16000000,16000000);
INSERT INTO `bidding` VALUES (29,'phucthai0108@gmail.com','2022-01-01 02:13:14',17000000,17000000);
INSERT INTO `bidding` VALUES (29,'thanhhoang4869@gmail.com','2022-01-04 16:15:08',18000000,18000000);

INSERT INTO `bidding` VALUES (31,'tristan.hcmus.study@gmail.com','2021-12-12 02:54:07',600000,1300000);
INSERT INTO `bidding` VALUES (31,'tristan.hcmus.study@gmail.com','2021-12-17 05:48:15',700000,1300000);
INSERT INTO `bidding` VALUES (31,'tristan.hcmus.study@gmail.com','2021-12-22 08:42:23',800000,1300000);
INSERT INTO `bidding` VALUES (31,'tristan.hcmus.study@gmail.com','2021-12-27 11:36:31',900000,1300000);
INSERT INTO `bidding` VALUES (31,'springfieldcaptain@gmail.com','2022-01-01 14:30:39',1400000,1700000);

INSERT INTO `bidding` VALUES (32,'vminathanhv@gmail.com','2021-12-10 06:12:37',600000,1000000);
INSERT INTO `bidding` VALUES (32,'vminathanhv@gmail.com','2021-12-13 12:25:15',700000,1000000);
INSERT INTO `bidding` VALUES (32,'tristan.hcmus.study@gmail.com','2021-12-16 18:37:53',1100000,1200000);
INSERT INTO `bidding` VALUES (32,'tristan.hcmus.study@gmail.com','2021-12-20 00:50:31',1200000,1200000);
INSERT INTO `bidding` VALUES (32,'vminathanhv@gmail.com','2021-12-23 07:03:08',1300000,1300000);
INSERT INTO `bidding` VALUES (32,'tristanhuyanhngo@gmail.com','2021-12-26 13:15:46',1400000,1400000);
INSERT INTO `bidding` VALUES (32,'tristan.hcmus.study@gmail.com','2021-12-29 19:28:24',1500000,1600000);
INSERT INTO `bidding` VALUES (32,'tristan.hcmus.study@gmail.com','2022-01-02 01:41:02',1600000,1600000);
INSERT INTO `bidding` VALUES (32,'sinsin.4869@gmail.com','2022-01-05 07:53:39',1700000,1700000);

INSERT INTO `bidding` VALUES (34,'vminathanhv@gmail.com','2021-12-11 11:32:21',600000,600000);
INSERT INTO `bidding` VALUES (34,'phucthai0108@gmail.com','2021-12-15 23:04:43',700000,1400000);
INSERT INTO `bidding` VALUES (34,'phucthai0108@gmail.com','2021-12-20 10:37:05',800000,1400000);
INSERT INTO `bidding` VALUES (34,'phucthai0108@gmail.com','2021-12-24 22:09:27',900000,1400000);
INSERT INTO `bidding` VALUES (34,'phucthai0108@gmail.com','2021-12-29 09:41:49',1000000,1400000);
INSERT INTO `bidding` VALUES (34,'phucthai0108@gmail.com','2022-01-02 21:14:11',1100000,1400000);

INSERT INTO `bidding` VALUES (35,'sinsin.4869@gmail.com','2021-12-10 06:12:37',600000,1000000);
INSERT INTO `bidding` VALUES (35,'sinsin.4869@gmail.com','2021-12-13 12:25:15',700000,1000000);
INSERT INTO `bidding` VALUES (35,'phucthai0108@gmail.com','2021-12-16 18:37:53',1100000,1200000);
INSERT INTO `bidding` VALUES (35,'springfieldcaptain@gmail.com','2021-12-20 00:50:31',1300000,1300000);
INSERT INTO `bidding` VALUES (35,'thanhhoang4869@gmail.com','2021-12-23 07:03:08',1400000,1400000);
INSERT INTO `bidding` VALUES (35,'springfieldcaptain@gmail.com','2021-12-26 13:15:46',1500000,1500000);
INSERT INTO `bidding` VALUES (35,'tristanhuyanhngo@gmail.com','2021-12-29 19:28:24',1600000,1600000);
INSERT INTO `bidding` VALUES (35,'thanhhoang4869@gmail.com','2022-01-02 01:41:02',1700000,1700000);
INSERT INTO `bidding` VALUES (35,'phucthai0108@gmail.com','2022-01-05 07:53:39',1800000,1800000);

INSERT INTO `bidding` VALUES (36,'tristan.hcmus.study@gmail.com','2021-12-12 02:54:07',600000,600000);
INSERT INTO `bidding` VALUES (36,'tristanhuyanhngo@gmail.com','2021-12-17 05:48:15',700000,1300000);
INSERT INTO `bidding` VALUES (36,'tristanhuyanhngo@gmail.com','2021-12-22 08:42:23',800000,1300000);
INSERT INTO `bidding` VALUES (36,'tristan.hcmus.study@gmail.com','2021-12-27 11:36:31',1400000,1700000);
INSERT INTO `bidding` VALUES (36,'sinsin.4869@gmail.com','2022-01-01 14:30:39',1800000,1800000);

INSERT INTO `bidding` VALUES (37,'sinsin.4869@gmail.com','2021-12-09 23:41:34',600000,700000);
INSERT INTO `bidding` VALUES (37,'tristan.hcmus.study@gmail.com','2021-12-12 23:23:09',800000,1000000);
INSERT INTO `bidding` VALUES (37,'tristan.hcmus.study@gmail.com','2021-12-15 23:04:43',900000,1000000);
INSERT INTO `bidding` VALUES (37,'tristan.hcmus.study@gmail.com','2021-12-18 22:46:18',1000000,1000000);
INSERT INTO `bidding` VALUES (37,'springfieldcaptain@gmail.com','2021-12-21 22:27:53',1100000,1200000);
INSERT INTO `bidding` VALUES (37,'springfieldcaptain@gmail.com','2021-12-24 22:09:27',1200000,1200000);
INSERT INTO `bidding` VALUES (37,'phucthai0108@gmail.com','2021-12-27 21:51:02',1300000,1400000);
INSERT INTO `bidding` VALUES (37,'springfieldcaptain@gmail.com','2021-12-30 21:32:36',1500000,1500000);
INSERT INTO `bidding` VALUES (37,'tristanhuyanhngo@gmail.com','2022-01-02 21:14:11',1600000,1700000);
INSERT INTO `bidding` VALUES (37,'tristanhuyanhngo@gmail.com','2022-01-05 20:55:46',1700000,1700000);

INSERT INTO `bidding` VALUES (38,'tristanhuyanhngo@gmail.com','2021-12-09 23:41:34',600000,600000);
INSERT INTO `bidding` VALUES (38,'phucthai0108@gmail.com','2021-12-12 23:23:09',700000,700000);
INSERT INTO `bidding` VALUES (38,'tristan.hcmus.study@gmail.com','2021-12-15 23:04:43',800000,1000000);
INSERT INTO `bidding` VALUES (38,'phucthai0108@gmail.com','2021-12-18 22:46:18',1100000,1200000);
INSERT INTO `bidding` VALUES (38,'phucthai0108@gmail.com','2021-12-21 22:27:53',1200000,1200000);
INSERT INTO `bidding` VALUES (38,'vminathanhv@gmail.com','2021-12-24 22:09:27',1300000,1300000);
INSERT INTO `bidding` VALUES (38,'huyanhngo@gmail.com','2021-12-27 21:51:02',1400000,1500000);
INSERT INTO `bidding` VALUES (38,'huyanhngo@gmail.com','2021-12-30 21:32:37',1500000,1500000);
INSERT INTO `bidding` VALUES (38,'phucthai0108@gmail.com','2022-01-02 21:14:11',1600000,1700000);
INSERT INTO `bidding` VALUES (38,'phucthai0108@gmail.com','2022-01-05 20:55:46',1700000,1700000);

INSERT INTO `bidding` VALUES (39,'springfieldcaptain@gmail.com','2021-12-09 23:41:34',600000,700000);
INSERT INTO `bidding` VALUES (39,'sinsin.4869@gmail.com','2021-12-12 23:23:09',800000,1000000);
INSERT INTO `bidding` VALUES (39,'sinsin.4869@gmail.com','2021-12-15 23:04:43',900000,1000000);
INSERT INTO `bidding` VALUES (39,'vminathanhv@gmail.com','2021-12-18 22:46:18',1100000,1100000);
INSERT INTO `bidding` VALUES (39,'phucthai0108@gmail.com','2021-12-21 22:27:53',1200000,1200000);
INSERT INTO `bidding` VALUES (39,'huyanhngo@gmail.com','2021-12-24 22:09:27',1300000,1300000);
INSERT INTO `bidding` VALUES (39,'vminathanhv@gmail.com','2021-12-27 21:51:02',1400000,1500000);
INSERT INTO `bidding` VALUES (39,'tristan.hcmus.study@gmail.com','2021-12-30 21:32:37',1600000,1600000);
INSERT INTO `bidding` VALUES (39,'huyanhngo@gmail.com','2022-01-02 21:14:11',1700000,1700000);
INSERT INTO `bidding` VALUES (39,'springfieldcaptain@gmail.com','2022-01-05 20:55:46',1800000,1800000);

INSERT INTO `bidding` VALUES (40,'vminathanhv@gmail.com','2021-12-11 11:32:21',600000,800000);
INSERT INTO `bidding` VALUES (40,'tristan.hcmus.study@gmail.com','2021-12-15 23:04:43',900000,1000000);
INSERT INTO `bidding` VALUES (40,'tristan.hcmus.study@gmail.com','2021-12-20 10:37:05',1000000,1000000);
INSERT INTO `bidding` VALUES (40,'sinsin.4869@gmail.com','2021-12-24 22:09:27',1100000,1400000);
INSERT INTO `bidding` VALUES (40,'sinsin.4869@gmail.com','2021-12-29 09:41:49',1200000,1400000);
INSERT INTO `bidding` VALUES (40,'huyanhngo@gmail.com','2022-01-02 21:14:11',1500000,1500000);

INSERT INTO `bidding` VALUES (41,'phucthai0108@gmail.com','2021-12-12 02:54:07',600000,800000);
INSERT INTO `bidding` VALUES (41,'huyanhngo@gmail.com','2021-12-17 05:48:15',900000,1100000);
INSERT INTO `bidding` VALUES (41,'tristanhuyanhngo@gmail.com','2021-12-22 08:42:23',1200000,1200000);
INSERT INTO `bidding` VALUES (41,'sinsin.4869@gmail.com','2021-12-27 11:36:31',1300000,1500000);
INSERT INTO `bidding` VALUES (41,'sinsin.4869@gmail.com','2022-01-01 14:30:39',1400000,1500000);

INSERT INTO `bidding` VALUES (42,'sinsin.4869@gmail.com','2021-12-10 06:12:37',600000,600000);
INSERT INTO `bidding` VALUES (42,'springfieldcaptain@gmail.com','2021-12-13 12:25:15',700000,700000);
INSERT INTO `bidding` VALUES (42,'sinsin.4869@gmail.com','2021-12-16 18:37:53',800000,1200000);
INSERT INTO `bidding` VALUES (42,'sinsin.4869@gmail.com','2021-12-20 00:50:31',900000,1200000);
INSERT INTO `bidding` VALUES (42,'vminathanhv@gmail.com','2021-12-23 07:03:08',1300000,1400000);
INSERT INTO `bidding` VALUES (42,'tristanhuyanhngo@gmail.com','2021-12-26 13:15:46',1500000,1500000);
INSERT INTO `bidding` VALUES (42,'phucthai0108@gmail.com','2021-12-29 19:28:24',1600000,1600000);
INSERT INTO `bidding` VALUES (42,'springfieldcaptain@gmail.com','2022-01-02 01:41:02',1700000,1700000);
INSERT INTO `bidding` VALUES (42,'vminathanhv@gmail.com','2022-01-05 07:53:40',1800000,1800000);

INSERT INTO `bidding` VALUES (43,'huyanhngo@gmail.com','2021-12-12 02:54:07',600000,700000);
INSERT INTO `bidding` VALUES (43,'tristanhuyanhngo@gmail.com','2021-12-17 05:48:15',800000,1200000);
INSERT INTO `bidding` VALUES (43,'huyanhngo@gmail.com','2021-12-22 08:42:23',1300000,1600000);
INSERT INTO `bidding` VALUES (43,'huyanhngo@gmail.com','2021-12-27 11:36:31',1400000,1600000);
INSERT INTO `bidding` VALUES (43,'tristan.hcmus.study@gmail.com','2022-01-01 14:30:39',1700000,1700000);

INSERT INTO `bidding` VALUES (44,'thanhhoang4869@gmail.com','2021-12-10 23:35:26',600000,1100000);
INSERT INTO `bidding` VALUES (44,'thanhhoang4869@gmail.com','2021-12-14 23:10:52',700000,1100000);
INSERT INTO `bidding` VALUES (44,'thanhhoang4869@gmail.com','2021-12-18 22:46:18',800000,1100000);
INSERT INTO `bidding` VALUES (44,'phucthai0108@gmail.com','2021-12-22 22:21:44',1200000,1200000);
INSERT INTO `bidding` VALUES (44,'vminathanhv@gmail.com','2021-12-26 21:57:10',1300000,1600000);
INSERT INTO `bidding` VALUES (44,'tristan.hcmus.study@gmail.com','2021-12-30 21:32:37',1700000,1700000);
INSERT INTO `bidding` VALUES (44,'springfieldcaptain@gmail.com','2022-01-03 21:08:03',1800000,1800000);

INSERT INTO `bidding` VALUES (45,'sinsin.4869@gmail.com','2021-12-12 02:54:07',600000,1400000);
INSERT INTO `bidding` VALUES (45,'thanhhoang4869@gmail.com','2021-12-17 05:48:15',1500000,1500000);
INSERT INTO `bidding` VALUES (45,'tristanhuyanhngo@gmail.com','2021-12-22 08:42:23',1600000,1600000);
INSERT INTO `bidding` VALUES (45,'tristan.hcmus.study@gmail.com','2021-12-27 11:36:31',1700000,1700000);
INSERT INTO `bidding` VALUES (45,'sinsin.4869@gmail.com','2022-01-01 14:30:39',1800000,1800000);

COMMIT;

-- ----------------------------
-- Records of images
-- ----------------------------
INSERT INTO `picture`(ProID, URL) VALUES (1,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873404/horizon/products/1/1_loz7bu.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (1,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873404/horizon/products/1/2_uuixge.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (1,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873404/horizon/products/1/3_zyr80c.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (1,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873404/horizon/products/1/4_kzhbfs.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (2,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873449/horizon/products/2/1_pjz3la.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (2,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873449/horizon/products/2/2_fcbs8f.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (2,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873449/horizon/products/2/3_ej51l3.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (2,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873451/horizon/products/2/4_xvipsi.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (3,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873464/horizon/products/3/1_acbhzb.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (3,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873464/horizon/products/3/2_gjqzpp.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (3,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873464/horizon/products/3/3_eqhakr.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (3,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873466/horizon/products/3/4_mps669.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (4,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873501/horizon/products/4/1_c20o1a.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (4,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873501/horizon/products/4/2_cdyh5o.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (4,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873501/horizon/products/4/3_sufsb8.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (4,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873503/horizon/products/4/4_wdqicq.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (5,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873515/horizon/products/5/1_yn3lfg.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (5,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873515/horizon/products/5/2_i1po4r.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (5,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873515/horizon/products/5/3_c0irqt.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (5,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873516/horizon/products/5/4_x9iwh4.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (6,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873536/horizon/products/6/1_rxoodv.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (6,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873536/horizon/products/6/2_mdvzmv.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (6,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873536/horizon/products/6/3_u5rqsr.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (6,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873536/horizon/products/6/4_ngdfca.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (6,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873541/horizon/products/6/5_l6p5nv.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (7,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873557/horizon/products/7/1_qzjphh.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (7,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873556/horizon/products/7/2_j6s3kc.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (7,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873561/horizon/products/7/3_vj5s6j.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (7,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873560/horizon/products/7/4_t7cuui.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (7,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873557/horizon/products/7/5_vu7ert.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (8,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873620/horizon/products/8/1_f6mfaz.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (8,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873620/horizon/products/8/2_u8fi25.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (8,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873620/horizon/products/8/3_auvvtj.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (8,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873621/horizon/products/8/4_bu1na4.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (9,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873669/horizon/products/9/1_rxh5u7.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (9,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873669/horizon/products/9/2_bilfc1.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (9,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873671/horizon/products/9/3_q15cdl.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (9,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873673/horizon/products/9/4_ugw0mj.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (9,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641873671/horizon/products/9/5_xzsluf.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (10,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874016/horizon/products/10/1_wrxjw3.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (10,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874016/horizon/products/10/2_wqznsl.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (10,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874016/horizon/products/10/3_hdsbzv.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (10,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874016/horizon/products/10/4_x6f615.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (10,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874016/horizon/products/10/5_s1cnzl.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (11,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874078/horizon/products/11/1_rojfta.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (11,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874078/horizon/products/11/2_bv1lge.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (11,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874078/horizon/products/11/3_omwlrh.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (11,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874078/horizon/products/11/4_oiuoay.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (11,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874078/horizon/products/11/5_swgquo.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (12,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874235/horizon/products/12/1_jy2cnq.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (12,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874236/horizon/products/12/2_sxm93d.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (12,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874234/horizon/products/12/3_xxihce.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (12,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874235/horizon/products/12/4_dxpjqh.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (12,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874236/horizon/products/12/5_ha9pdl.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (13,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874244/horizon/products/13/1_dwb2wo.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (13,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874244/horizon/products/13/2_o6jzhw.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (13,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874243/horizon/products/13/3_lolvko.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (13,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874243/horizon/products/13/4_kz8ipq.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (13,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874244/horizon/products/13/5_gnlosb.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (14,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874262/horizon/products/14/1_tuhjup.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (14,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874260/horizon/products/14/2_efb7fm.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (14,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874259/horizon/products/14/3_bszh2u.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (14,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874259/horizon/products/14/4_cnzlrn.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (14,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874260/horizon/products/14/5_dsrrzb.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (15,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874270/horizon/products/15/1_dyy3yv.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (15,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874269/horizon/products/15/2_xokoom.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (15,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874267/horizon/products/15/3_m4bzqc.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (15,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874266/horizon/products/15/4_qytgyg.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (15,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874267/horizon/products/15/5_jkant3.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (16,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874278/horizon/products/16/1_xaxthg.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (16,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874276/horizon/products/16/2_mdhvbb.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (16,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874275/horizon/products/16/3_k6feee.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (16,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874278/horizon/products/16/4_glhrry.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (16,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874279/horizon/products/16/5_ncw3bo.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (17,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874284/horizon/products/17/1_fhavjt.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (17,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874284/horizon/products/17/2_rtzkgm.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (17,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874283/horizon/products/17/3_zzfk9g.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (17,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874284/horizon/products/17/4_vloc2v.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (17,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874284/horizon/products/17/5_a4cvx3.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (18,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874299/horizon/products/18/1_hrvemf.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (18,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874295/horizon/products/18/2_oip3wk.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (18,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874296/horizon/products/18/3_kv9ouk.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (18,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874294/horizon/products/18/4_s8xwfn.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (18,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874294/horizon/products/18/5_ysbage.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (19,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874302/horizon/products/19/1_io2f3c.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (19,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874303/horizon/products/19/2_kesqvh.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (19,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874302/horizon/products/19/3_vlkdbn.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (19,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874302/horizon/products/19/4_edylsb.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (19,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874303/horizon/products/19/5_hdbc2q.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (20,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874315/horizon/products/20/1_v2nuw7.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (20,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874314/horizon/products/20/2_m58fxs.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (20,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874314/horizon/products/20/3_nuoaur.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (20,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874314/horizon/products/20/4_rnierx.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (20,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874315/horizon/products/20/5_ipnilb.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (21,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874323/horizon/products/21/1_xefkqd.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (21,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874324/horizon/products/21/2_klz0j6.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (21,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874323/horizon/products/21/3_k51sgw.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (21,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874323/horizon/products/21/4_obpfcc.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (21,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874323/horizon/products/21/5_syyojl.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (22,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874331/horizon/products/22/1_rwiwoo.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (22,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874336/horizon/products/22/2_repgbm.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (22,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874334/horizon/products/22/3_rtzim7.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (22,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874331/horizon/products/22/4_qkknii.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (22,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874329/horizon/products/22/5_fq1ddw.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (23,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874338/horizon/products/23/1_uv3qky.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (23,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874340/horizon/products/23/2_ktjo2d.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (23,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874338/horizon/products/23/3_r6tyap.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (23,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874339/horizon/products/23/4_oacpom.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (23,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874338/horizon/products/23/5_gxn199.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (24,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874345/horizon/products/24/1_xceqq2.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (24,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874346/horizon/products/24/2_izifco.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (24,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874347/horizon/products/24/3_cp7lj1.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (24,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874345/horizon/products/24/4_xdihui.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (24,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874346/horizon/products/24/5_jko0ut.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (25,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874355/horizon/products/25/1_aowzg8.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (25,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874361/horizon/products/25/2_jvankm.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (25,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874353/horizon/products/25/3_czz1ds.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (25,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874353/horizon/products/25/4_ezayjo.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (25,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874355/horizon/products/25/5_mzrmtv.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (26,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874381/horizon/products/26/1_yptwei.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (26,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874381/horizon/products/26/2_bu1pxt.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (26,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874382/horizon/products/26/3_ztpybj.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (26,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874382/horizon/products/26/4_vhi2uo.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (26,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874386/horizon/products/26/5_cfiqpr.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (27,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874394/horizon/products/27/1_unpxam.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (27,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874389/horizon/products/27/2_c7elfa.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (27,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874389/horizon/products/27/3_hickzk.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (27,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874397/horizon/products/27/4_fzt2ye.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (27,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874391/horizon/products/27/5_kdc13x.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (28,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874398/horizon/products/28/1_y4zw2c.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (28,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874397/horizon/products/28/2_eabp0k.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (28,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874398/horizon/products/28/3_ggahsk.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (28,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874398/horizon/products/28/4_llh7db.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (28,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874398/horizon/products/28/5_ozy4wy.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (29,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874405/horizon/products/29/1_yfteyu.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (29,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874404/horizon/products/29/2_uswaf6.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (29,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874405/horizon/products/29/3_ei5r29.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (29,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874407/horizon/products/29/4_phsgcv.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (29,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874406/horizon/products/29/5_uiko6l.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (30,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874414/horizon/products/30/1_rx88us.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (30,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874412/horizon/products/30/2_dygf80.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (30,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874413/horizon/products/30/3_qmribk.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (30,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874412/horizon/products/30/4_irkyax.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (30,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874413/horizon/products/30/5_u9ulis.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (31,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874431/horizon/products/31/1_jz0ovy.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (31,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874430/horizon/products/31/2_m0430a.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (31,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874432/horizon/products/31/3_kfh0wp.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (31,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874431/horizon/products/31/4_zhuhkd.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (31,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874431/horizon/products/31/5_z40ihp.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (31,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874431/horizon/products/31/6_c3jwxf.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (31,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874432/horizon/products/31/7_ld1tt0.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (31,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874433/horizon/products/31/8_keqlg3.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (32,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874439/horizon/products/32/1_ujoaig.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (32,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874439/horizon/products/32/2_jva28g.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (32,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874439/horizon/products/32/3_iy4shl.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (32,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874440/horizon/products/32/4_zbm4uc.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (32,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874440/horizon/products/32/5_rtoph6.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (33,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874453/horizon/products/33/1_x69nc7.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (33,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874453/horizon/products/33/2_bwul1q.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (33,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874452/horizon/products/33/3_cfz6ya.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (33,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874456/horizon/products/33/4_agxkg8.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (33,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874459/horizon/products/33/5_uh9ven.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (33,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874457/horizon/products/33/6_ik35ta.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (33,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874455/horizon/products/33/7_vog7mb.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (34,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874463/horizon/products/34/1_ljbgrj.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (34,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874462/horizon/products/34/2_isclh0.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (34,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874463/horizon/products/34/3_wlznsq.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (35,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874471/horizon/products/35/1_aucmcc.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (35,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874469/horizon/products/35/2_yz9uxa.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (35,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874469/horizon/products/35/3_gm4ef3.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (35,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874468/horizon/products/35/4_asdtbx.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (35,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874469/horizon/products/35/5_krkubu.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (35,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874469/horizon/products/35/6_iltai9.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (35,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874469/horizon/products/35/7_xvqvt3.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (36,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874482/horizon/products/36/1_mudevp.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (36,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874482/horizon/products/36/2_v4ann4.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (36,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874483/horizon/products/36/3_pwm5bs.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (36,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874483/horizon/products/36/4_ilfvia.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (36,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874483/horizon/products/36/5_ezkplu.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (37,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874490/horizon/products/37/1_ieqdtv.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (37,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874491/horizon/products/37/2_dzs9cl.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (37,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874491/horizon/products/37/3_d87kn1.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (37,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874491/horizon/products/37/4_ddizct.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (37,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874491/horizon/products/37/5_gykczj.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (37,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874492/horizon/products/37/6_yjdso4.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (38,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874501/horizon/products/38/1_txzq5e.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (38,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874501/horizon/products/38/2_dilfdk.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (38,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874501/horizon/products/38/3_a3z56i.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (38,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874501/horizon/products/38/4_nbbclg.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (38,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874502/horizon/products/38/5_xteqq4.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (38,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874501/horizon/products/38/6_oydeey.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (39,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874507/horizon/products/39/1_rkq3ml.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (39,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874507/horizon/products/39/2_w3nix9.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (39,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874507/horizon/products/39/3_t6b79y.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (39,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874508/horizon/products/39/4_edv0ol.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (39,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874508/horizon/products/39/5_pp69ek.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (39,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874508/horizon/products/39/6_m9fbow.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (40,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874516/horizon/products/40/1_wgpfnx.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (40,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874516/horizon/products/40/2_jpufwe.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (40,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874517/horizon/products/40/3_cmhlm2.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (40,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874517/horizon/products/40/4_vogtl7.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (40,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874517/horizon/products/40/5_lghbag.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (40,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874516/horizon/products/40/6_wpcrbm.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (41,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874522/horizon/products/41/1_cpztgj.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (41,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874523/horizon/products/41/2_w71u37.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (41,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874522/horizon/products/41/3_avgzff.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (41,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874524/horizon/products/41/4_z8utwp.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (41,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874523/horizon/products/41/5_q6iklj.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (41,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874522/horizon/products/41/6_cblu6b.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (42,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874530/horizon/products/42/1_lvqjcg.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (42,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874530/horizon/products/42/2_qlwsfz.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (42,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874529/horizon/products/42/3_wsj5vh.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (42,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874530/horizon/products/42/4_m6mpva.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (42,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874532/horizon/products/42/5_e5ljaw.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (42,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874530/horizon/products/42/6_fc67nd.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (43,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874540/horizon/products/43/1_mdcxzm.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (43,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874541/horizon/products/43/2_fzzaws.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (43,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874541/horizon/products/43/3_q2go7r.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (43,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874542/horizon/products/43/4_sps31k.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (43,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874542/horizon/products/43/5_rszbng.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (43,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874543/horizon/products/43/6_g72xax.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (44,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874548/horizon/products/44/1_doqqdh.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (44,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874547/horizon/products/44/2_qde9jm.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (44,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874548/horizon/products/44/3_ip4ifj.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (44,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874548/horizon/products/44/4_bqbjto.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (44,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874549/horizon/products/44/5_qe7aoc.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (44,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874549/horizon/products/44/6_das0kv.jpg');

INSERT INTO `picture`(ProID, URL) VALUES (45,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874555/horizon/products/45/1_j6atto.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (45,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874556/horizon/products/45/2_eag3bd.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (45,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874556/horizon/products/45/3_b1pxrk.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (45,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874556/horizon/products/45/4_uruxzm.jpg');
INSERT INTO `picture`(ProID, URL) VALUES (45,'https://res.cloudinary.com/horizon-web-online-auction/image/upload/v1641874557/horizon/products/45/5_aeoqlm.jpg');

COMMIT;

-- Full text search

ALTER TABLE `product`
ADD FULLTEXT(ProName);

ALTER TABLE `category`
ADD FULLTEXT(CatName);