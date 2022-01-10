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
INSERT INTO `product` VALUES (4,1,'kysutainangqsb@gmail.com','Diamond Ring STYLE By PNJ DNA XMXMX000004',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (5,1,'kysutainangqsb@gmail.com','10K White Gold Ring PNJ XMXMW001741',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');

-- Watch
INSERT INTO `product` VALUES (6,2,'kysutainangqsb@gmail.com','Citizen C7 NH8395-77E',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (7,2,'thanhhoang4869@gmail.com','MVW MS074-01',500000,100000,2000000,'2021-12-07','2022-01-31',0,0,0,'tristan.hcmus.study@gmail.com');
INSERT INTO `product` VALUES (8,2,'thanhhoang4869@gmail.com','G-SHOCK GBA-900-1ADR',500000,100000,2000000,'2021-12-07','2022-01-31',0,0,0,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (9,2,'kysutainangqsb@gmail.com','Smile Kid SL215L-9',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (10,2,'kysutainangqsb@gmail.com','Fossil ES4836 for Woman',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');

-- Latop
INSERT INTO `product` VALUES (11,3,'thanhhoang4869@gmail.com','Apple Macbook Pro 16 M1 Max 2021',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (12,3,'thanhhoang4869@gmail.com','Apple Macbook Pro 14 M1 Max 2021',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (13,3,'thanhhoang4869@gmail.com','Apple Macbook Air 2020',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (14,3,'thanhhoang4869@gmail.com','Asus Rog Zephyrus Gaming G14',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (15,3,'thanhhoang4869@gmail.com','Asus Zenbook UX371EA i7',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (16,3,'thanhhoang4869@gmail.com','Asus Zenbook Duo UX482EA i7',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (17,3,'thanhhoang4869@gmail.com','HP Omen 15 EK0078TX i7',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (18,3,'thanhhoang4869@gmail.com','HP Wow 8TX i5',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (19,3,'thanhhoang4869@gmail.com','HP White',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'springfieldcaptain@gmail.com');
INSERT INTO `product` VALUES (20,3,'kysutainangqsb@gmail.com','Acer Predator Helios',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (21,3,'kysutainangqsb@gmail.com','Acer Triton',2000000,500000,20000000,'2021-12-07','2022-01-31',1,1,1,'huyanhngo@gmail.com');
INSERT INTO `product` VALUES (22,3,'kysutainangqsb@gmail.com','Dell Gaming',2000000,1000000,20000000,'2021-12-07','2022-01-31',1,1,1,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (23,3,'kysutainangqsb@gmail.com','Dell Blue',2000000,1000000,20000000,'2021-12-07','2022-01-31',1,1,1,'tristanhuyanhngo@gmail.com');
INSERT INTO `product` VALUES (24,3,'tristanhuyanhngo@gmail.com','LG Gram',2000000,1000000,20000000,'2021-12-07','2022-01-31',1,1,1,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (25,3,'tristanhuyanhngo@gmail.com','Lenovo Idea Pad Gaming 3',2000000,1000000,20000000,'2021-12-07','2022-01-31',1,1,1,'thanhhoang4869@gmail.com');

-- Mobile
INSERT INTO `product` VALUES (26,4,'thanhhoang4869@gmail.com','Iphone 13 Pro',2000000,500000,20000000,'2021-12-07','2022-01-31',0,1,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (27,4,'thanhhoang4869@gmail.com','Xiaomi 10T Pro',2000000,500000,20000000,'2021-12-07','2022-01-31',0,1,0,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (28,4,'tristanhuyanhngo@gmail.com','Samsung Galaxy Z Flip 3 5G 256GB',2000000,1000000,20000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (29,4,'tristanhuyanhngo@gmail.com','Itel IT2171',2000000,1000000,20000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (30,4,'kysutainangqsb@gmail.com','Energizer E20',2000000,1000000,20000000,'2021-12-07','2022-01-31',0,0,0,'springfieldcaptain@gmail.com');

-- Smart Watch
INSERT INTO `product` VALUES (31,5,'thanhhoang4869@gmail.com','Mi Band 5',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (32,5,'thanhhoang4869@gmail.com','Samsung Galaxy Watch 4',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'tristanhuyanhngo@gmail.com');
INSERT INTO `product` VALUES (33,5,'tristanhuyanhngo@gmail.com','Garmin Fenix 4',500000,100000,2000000,'2021-12-07','2022-01-31',0,0,0,'thanhhoang4869@gmail.com');
INSERT INTO `product` VALUES (34,5,'kysutainangqsb@gmail.com','Beu KW03',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'tristanhuyanhngo@gmail.com');
INSERT INTO `product` VALUES (35,5,'kysutainangqsb@gmail.com','Garmin Lily Day',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'thanhhoang4869@gmail.com');

-- Clothing
INSERT INTO `product` VALUES (36,6,'kysutainangqsb@gmail.com','T Shirt',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (37,6,'kysutainangqsb@gmail.com','Jeans',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'vminathanhv@gmail.com');

-- Shoes
INSERT INTO `product` VALUES (38,7,'thanhhoang4869@gmail.com','Nike Air Force 1 07 QS',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'tristan.hcmus.study@gmail.com');
INSERT INTO `product` VALUES (39,7,'thanhhoang4869@gmail.com','Nike Blazer Mid 77 Cozi Brown',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'huyanhngo@gmail.com');
INSERT INTO `product` VALUES (40,7,'thanhhoang4869@gmail.com','Nike Spagetti',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'tristanhuyanhngo@gmail.com');
INSERT INTO `product` VALUES (41,7,'thanhhoang4869@gmail.com','Nike Cookies',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (42,7,'thanhhoang4869@gmail.com','Nike Blazer Mid 77 Cozi RB',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'vminathanhv@gmail.com');
INSERT INTO `product` VALUES (43,7,'thanhhoang4869@gmail.com','Nike Try',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'sinsin.4869@gmail.com');
INSERT INTO `product` VALUES (44,7,'tristanhuyanhngo@gmail.com','Nike Rice',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'phucthai0108@gmail.com');
INSERT INTO `product` VALUES (45,7,'kysutainangqsb@gmail.com','Nike Kentucky',500000,100000,2000000,'2021-12-07','2022-01-31',0,1,0,'huyanhngo@gmail.com');

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
INSERT INTO `bidding` VALUES (1, 'vminathanhv@gmail.com','2021-12-07 12:45:00',950000,1050000);
INSERT INTO `bidding` VALUES (1, 'springfieldcaptain@gmail.com','2021-12-07 12:42:00',850000,900000);
INSERT INTO `bidding` VALUES (1, 'springfieldcaptain@gmail.com','2021-12-07 12:40:00',800000,900000);
INSERT INTO `bidding` VALUES (1, 'tristan.hcmus.study@gmail.com','2021-12-07 12:36:00',750000,750000);
INSERT INTO `bidding` VALUES (1, 'springfieldcaptain@gmail.com','2021-12-07 12:35:00',250000,700000);

INSERT INTO `bidding` VALUES (2, 'springfieldcaptain@gmail.com','2021-12-07 12:45:00',1305000,1500000);
INSERT INTO `bidding` VALUES (2, 'vminathanhv@gmail.com','2021-12-07 12:42:00',1100000,1300000);
INSERT INTO `bidding` VALUES (2, 'vminathanhv@gmail.com','2021-12-07 12:40:00',800000,1300000);
INSERT INTO `bidding` VALUES (2, 'tristan.hcmus.study@gmail.com','2021-12-07 12:36:00',750000,750000);
INSERT INTO `bidding` VALUES (2, 'springfieldcaptain@gmail.com','2021-12-07 12:35:00',250000,700000);

INSERT INTO `bidding` VALUES (3, 'vminathanhv@gmail.com','2021-12-07 12:45:00',950000,1050000);
INSERT INTO `bidding` VALUES (3, 'huyanhngo@gmail.com','2021-12-07 12:42:00',850000,900000);
INSERT INTO `bidding` VALUES (3, 'huyanhngo@gmail.com','2021-12-07 12:40:00',800000,900000);
INSERT INTO `bidding` VALUES (3, 'tristan.hcmus.study@gmail.com','2021-12-07 12:36:00',750000,750000);
INSERT INTO `bidding` VALUES (3, 'sinsin.4869@gmail.com','2021-12-07 12:35:00',250000,700000);

INSERT INTO `bidding` VALUES (4,'tristanhuyanhngo@gmail.com','2021-12-11 14:00:00',600000,800000);
INSERT INTO `bidding` VALUES (4,'huyanhngo@gmail.com','2021-12-16 04:00:00',900000,1000000);
INSERT INTO `bidding` VALUES (4,'huyanhngo@gmail.com','2021-12-20 18:00:00',1000000,1000000);
INSERT INTO `bidding` VALUES (4,'tristan.hcmus.study@gmail.com','2021-12-25 08:00:00',1100000,1200000);
INSERT INTO `bidding` VALUES (4,'tristan.hcmus.study@gmail.com','2021-12-29 22:00:00',1200000,1200000);
INSERT INTO `bidding` VALUES (4,'phucthai0108@gmail.com','2022-01-03 12:00:00',1300000,1300000);
INSERT INTO `bidding` VALUES (4,'huyanhngo@gmail.com','2022-01-08 02:00:00',1400000,1400000);
INSERT INTO `bidding` VALUES (4,'vminathanhv@gmail.com','2022-01-12 16:00:00',1500000,1500000);
INSERT INTO `bidding` VALUES (4,'sinsin.4869@gmail.com','2022-01-17 06:00:00',1600000,1700000);
INSERT INTO `bidding` VALUES (4,'tristanhuyanhngo@gmail.com','2022-01-21 20:00:00',1800000,1800000);

INSERT INTO `bidding` VALUES (5,'phucthai0108@gmail.com','2021-12-14 20:34:17',600000,800000);
INSERT INTO `bidding` VALUES (5,'vminathanhv@gmail.com','2021-12-22 17:08:34',900000,1000000);
INSERT INTO `bidding` VALUES (5,'sinsin.4869@gmail.com','2021-12-30 13:42:51',1100000,1500000);
INSERT INTO `bidding` VALUES (5,'sinsin.4869@gmail.com','2022-01-07 10:17:08',1200000,1500000);
INSERT INTO `bidding` VALUES (5,'thanhhoang4869@gmail.com','2022-01-15 06:51:25',1600000,1800000);

INSERT INTO `bidding` VALUES (6,'sinsin.4869@gmail.com','2021-12-12 12:00:00',600000,800000);
INSERT INTO `bidding` VALUES (6,'springfieldcaptain@gmail.com','2021-12-18 00:00:00',900000,900000);
INSERT INTO `bidding` VALUES (6,'phucthai0108@gmail.com','2021-12-23 12:00:00',1000000,1200000);
INSERT INTO `bidding` VALUES (6,'phucthai0108@gmail.com','2021-12-29 00:00:00',1100000,1200000);
INSERT INTO `bidding` VALUES (6,'phucthai0108@gmail.com','2022-01-03 12:00:00',1200000,1200000);
INSERT INTO `bidding` VALUES (6,'sinsin.4869@gmail.com','2022-01-09 00:00:00',1300000,1300000);
INSERT INTO `bidding` VALUES (6,'vminathanhv@gmail.com','2022-01-14 12:00:00',1400000,1700000);
INSERT INTO `bidding` VALUES (6,'vminathanhv@gmail.com','2022-01-20 00:00:00',1500000,1700000);

INSERT INTO `bidding` VALUES (9,'tristanhuyanhngo@gmail.com','2021-12-12 00:00:00',600000,700000);
INSERT INTO `bidding` VALUES (9,'tristan.hcmus.study@gmail.com','2021-12-17 00:00:00',800000,900000);
INSERT INTO `bidding` VALUES (9,'tristanhuyanhngo@gmail.com','2021-12-22 00:00:00',1000000,1100000);
INSERT INTO `bidding` VALUES (9,'tristan.hcmus.study@gmail.com','2021-12-27 00:00:00',1200000,1300000);
INSERT INTO `bidding` VALUES (9,'tristan.hcmus.study@gmail.com','2022-01-01 00:00:00',1300000,1300000);
INSERT INTO `bidding` VALUES (9,'tristanhuyanhngo@gmail.com','2022-01-06 00:00:00',1400000,1400000);
INSERT INTO `bidding` VALUES (9,'phucthai0108@gmail.com','2022-01-11 00:00:00',1500000,1600000);
INSERT INTO `bidding` VALUES (9,'phucthai0108@gmail.com','2022-01-16 00:00:00',1600000,1600000);
INSERT INTO `bidding` VALUES (9,'tristanhuyanhngo@gmail.com','2022-01-21 00:00:00',1700000,1800000);

INSERT INTO `bidding` VALUES (10,'sinsin.4869@gmail.com','2021-12-13 02:40:00',600000,800000);
INSERT INTO `bidding` VALUES (10,'tristan.hcmus.study@gmail.com','2021-12-19 05:20:00',900000,1000000);
INSERT INTO `bidding` VALUES (10,'tristan.hcmus.study@gmail.com','2021-12-25 08:00:00',1000000,1000000);
INSERT INTO `bidding` VALUES (10,'thanhhoang4869@gmail.com','2021-12-31 10:40:00',1100000,1100000);
INSERT INTO `bidding` VALUES (10,'tristanhuyanhngo@gmail.com','2022-01-06 13:20:00',1200000,1500000);
INSERT INTO `bidding` VALUES (10,'tristanhuyanhngo@gmail.com','2022-01-12 16:00:00',1300000,1500000);
INSERT INTO `bidding` VALUES (10,'tristanhuyanhngo@gmail.com','2022-01-18 18:40:00',1400000,1500000);

INSERT INTO `bidding` VALUES (11,'sinsin.4869@gmail.com','2021-12-14 20:34:17',2500000,3500000);
INSERT INTO `bidding` VALUES (11,'vminathanhv@gmail.com','2021-12-22 17:08:34',4000000,12500000);
INSERT INTO `bidding` VALUES (11,'phucthai0108@gmail.com','2021-12-30 13:42:51',13000000,14500000);
INSERT INTO `bidding` VALUES (11,'tristanhuyanhngo@gmail.com','2022-01-07 10:17:08',15000000,18000000);
INSERT INTO `bidding` VALUES (11,'tristanhuyanhngo@gmail.com','2022-01-15 06:51:25',15500000,18000000);

INSERT INTO `bidding` VALUES (12,'huyanhngo@gmail.com','2021-12-11 14:00:00',2500000,7000000);
INSERT INTO `bidding` VALUES (12,'sinsin.4869@gmail.com','2021-12-16 04:00:00',7500000,14500000);
INSERT INTO `bidding` VALUES (12,'sinsin.4869@gmail.com','2021-12-20 18:00:00',8000000,14500000);
INSERT INTO `bidding` VALUES (12,'sinsin.4869@gmail.com','2021-12-25 08:00:00',8500000,14500000);
INSERT INTO `bidding` VALUES (12,'sinsin.4869@gmail.com','2021-12-29 22:00:00',9000000,14500000);
INSERT INTO `bidding` VALUES (12,'tristan.hcmus.study@gmail.com','2022-01-03 12:00:00',15000000,16500000);
INSERT INTO `bidding` VALUES (12,'tristan.hcmus.study@gmail.com','2022-01-08 02:00:00',15500000,16500000);
INSERT INTO `bidding` VALUES (12,'tristan.hcmus.study@gmail.com','2022-01-12 16:00:00',16000000,16500000);
INSERT INTO `bidding` VALUES (12,'vminathanhv@gmail.com','2022-01-17 06:00:00',17000000,17000000);
INSERT INTO `bidding` VALUES (12,'sinsin.4869@gmail.com','2022-01-21 20:00:00',17500000,18500000);

INSERT INTO `bidding` VALUES (13,'tristanhuyanhngo@gmail.com','2021-12-11 14:00:00',2500000,8000000);
INSERT INTO `bidding` VALUES (13,'vminathanhv@gmail.com','2021-12-16 04:00:00',8500000,14000000);
INSERT INTO `bidding` VALUES (13,'vminathanhv@gmail.com','2021-12-20 18:00:00',9000000,14000000);
INSERT INTO `bidding` VALUES (13,'huyanhngo@gmail.com','2021-12-25 08:00:00',14500000,15500000);
INSERT INTO `bidding` VALUES (13,'phucthai0108@gmail.com','2021-12-29 22:00:00',16000000,16500000);
INSERT INTO `bidding` VALUES (13,'phucthai0108@gmail.com','2022-01-03 12:00:00',16500000,16500000);
INSERT INTO `bidding` VALUES (13,'huyanhngo@gmail.com','2022-01-08 02:00:00',17000000,17500000);
INSERT INTO `bidding` VALUES (13,'huyanhngo@gmail.com','2022-01-12 16:00:00',17500000,17500000);
INSERT INTO `bidding` VALUES (13,'vminathanhv@gmail.com','2022-01-17 06:00:00',18000000,18000000);
INSERT INTO `bidding` VALUES (13,'tristan.hcmus.study@gmail.com','2022-01-21 20:00:00',18500000,18500000);

INSERT INTO `bidding` VALUES (14,'sinsin.4869@gmail.com','2021-12-12 00:00:00',2500000,15000000);
INSERT INTO `bidding` VALUES (14,'sinsin.4869@gmail.com','2021-12-17 00:00:00',3000000,15000000);
INSERT INTO `bidding` VALUES (14,'vminathanhv@gmail.com','2021-12-22 00:00:00',15500000,16000000);
INSERT INTO `bidding` VALUES (14,'vminathanhv@gmail.com','2021-12-27 00:00:00',16000000,16000000);
INSERT INTO `bidding` VALUES (14,'phucthai0108@gmail.com','2022-01-01 00:00:00',16500000,17000000);
INSERT INTO `bidding` VALUES (14,'phucthai0108@gmail.com','2022-01-06 00:00:00',17000000,17000000);
INSERT INTO `bidding` VALUES (14,'huyanhngo@gmail.com','2022-01-11 00:00:00',17500000,17500000);
INSERT INTO `bidding` VALUES (14,'vminathanhv@gmail.com','2022-01-16 00:00:00',18000000,18000000);
INSERT INTO `bidding` VALUES (14,'tristan.hcmus.study@gmail.com','2022-01-21 00:00:00',18500000,18500000);

INSERT INTO `bidding` VALUES (15,'huyanhngo@gmail.com','2021-12-13 21:00:00',2500000,11500000);
INSERT INTO `bidding` VALUES (15,'huyanhngo@gmail.com','2021-12-20 18:00:00',3000000,11500000);
INSERT INTO `bidding` VALUES (15,'huyanhngo@gmail.com','2021-12-27 15:00:00',3500000,11500000);
INSERT INTO `bidding` VALUES (15,'huyanhngo@gmail.com','2022-01-03 12:00:00',4000000,11500000);
INSERT INTO `bidding` VALUES (15,'huyanhngo@gmail.com','2022-01-10 09:00:00',4500000,11500000);
INSERT INTO `bidding` VALUES (15,'huyanhngo@gmail.com','2022-01-17 06:00:00',5000000,11500000);

INSERT INTO `bidding` VALUES (16,'sinsin.4869@gmail.com','2021-12-12 12:00:00',2500000,14500000);
INSERT INTO `bidding` VALUES (16,'sinsin.4869@gmail.com','2021-12-18 00:00:00',3000000,14500000);
INSERT INTO `bidding` VALUES (16,'sinsin.4869@gmail.com','2021-12-23 12:00:00',3500000,14500000);
INSERT INTO `bidding` VALUES (16,'sinsin.4869@gmail.com','2021-12-29 00:00:00',4000000,14500000);
INSERT INTO `bidding` VALUES (16,'sinsin.4869@gmail.com','2022-01-03 12:00:00',4500000,14500000);
INSERT INTO `bidding` VALUES (16,'vminathanhv@gmail.com','2022-01-09 00:00:00',15000000,16000000);
INSERT INTO `bidding` VALUES (16,'vminathanhv@gmail.com','2022-01-14 12:00:00',15500000,16000000);
INSERT INTO `bidding` VALUES (16,'sinsin.4869@gmail.com','2022-01-20 00:00:00',16500000,18500000);

INSERT INTO `bidding` VALUES (17,'phucthai0108@gmail.com','2021-12-13 21:00:00',2500000,9000000);
INSERT INTO `bidding` VALUES (17,'phucthai0108@gmail.com','2021-12-20 18:00:00',3000000,9000000);
INSERT INTO `bidding` VALUES (17,'phucthai0108@gmail.com','2021-12-27 15:00:00',3500000,9000000);
INSERT INTO `bidding` VALUES (17,'phucthai0108@gmail.com','2022-01-03 12:00:00',4000000,9000000);
INSERT INTO `bidding` VALUES (17,'phucthai0108@gmail.com','2022-01-10 09:00:00',4500000,9000000);
INSERT INTO `bidding` VALUES (17,'springfieldcaptain@gmail.com','2022-01-17 06:00:00',9500000,11500000);

INSERT INTO `bidding` VALUES (18,'phucthai0108@gmail.com','2021-12-11 14:00:00',2500000,7000000);
INSERT INTO `bidding` VALUES (18,'vminathanhv@gmail.com','2021-12-16 04:00:00',7500000,12500000);
INSERT INTO `bidding` VALUES (18,'vminathanhv@gmail.com','2021-12-20 18:00:00',8000000,12500000);
INSERT INTO `bidding` VALUES (18,'springfieldcaptain@gmail.com','2021-12-25 08:00:00',13000000,15500000);
INSERT INTO `bidding` VALUES (18,'springfieldcaptain@gmail.com','2021-12-29 22:00:00',13500000,15500000);
INSERT INTO `bidding` VALUES (18,'phucthai0108@gmail.com','2022-01-03 12:00:00',16000000,17000000);
INSERT INTO `bidding` VALUES (18,'phucthai0108@gmail.com','2022-01-08 02:00:00',16500000,17000000);
INSERT INTO `bidding` VALUES (18,'vminathanhv@gmail.com','2022-01-12 16:00:00',17500000,18000000);
INSERT INTO `bidding` VALUES (18,'vminathanhv@gmail.com','2022-01-17 06:00:00',18000000,18000000);
INSERT INTO `bidding` VALUES (18,'phucthai0108@gmail.com','2022-01-21 20:00:00',18500000,19000000);

INSERT INTO `bidding` VALUES (19,'tristanhuyanhngo@gmail.com','2021-12-12 12:00:00',2500000,9000000);
INSERT INTO `bidding` VALUES (19,'vminathanhv@gmail.com','2021-12-18 00:00:00',9500000,9500000);
INSERT INTO `bidding` VALUES (19,'phucthai0108@gmail.com','2021-12-23 12:00:00',10000000,13000000);
INSERT INTO `bidding` VALUES (19,'phucthai0108@gmail.com','2021-12-29 00:00:00',10500000,13000000);
INSERT INTO `bidding` VALUES (19,'phucthai0108@gmail.com','2022-01-03 12:00:00',11000000,13000000);
INSERT INTO `bidding` VALUES (19,'vminathanhv@gmail.com','2022-01-09 00:00:00',13500000,15500000);
INSERT INTO `bidding` VALUES (19,'phucthai0108@gmail.com','2022-01-14 12:00:00',16000000,18000000);
INSERT INTO `bidding` VALUES (19,'phucthai0108@gmail.com','2022-01-20 00:00:00',16500000,18000000);

INSERT INTO `bidding` VALUES (20,'phucthai0108@gmail.com','2021-12-13 02:40:00',2500000,2500000);
INSERT INTO `bidding` VALUES (20,'sinsin.4869@gmail.com','2021-12-19 05:20:00',3000000,5500000);
INSERT INTO `bidding` VALUES (20,'springfieldcaptain@gmail.com','2021-12-25 08:00:00',6000000,17000000);
INSERT INTO `bidding` VALUES (20,'springfieldcaptain@gmail.com','2021-12-31 10:40:00',6500000,17000000);
INSERT INTO `bidding` VALUES (20,'springfieldcaptain@gmail.com','2022-01-06 13:20:00',7000000,17000000);
INSERT INTO `bidding` VALUES (20,'phucthai0108@gmail.com','2022-01-12 16:00:00',17500000,18500000);
INSERT INTO `bidding` VALUES (20,'phucthai0108@gmail.com','2022-01-18 18:40:00',18000000,18500000);

INSERT INTO `bidding` VALUES (21,'tristan.hcmus.study@gmail.com','2021-12-14 20:34:17',2500000,9500000);
INSERT INTO `bidding` VALUES (21,'sinsin.4869@gmail.com','2021-12-22 17:08:34',10000000,11500000);
INSERT INTO `bidding` VALUES (21,'tristan.hcmus.study@gmail.com','2021-12-30 13:42:51',12000000,17000000);
INSERT INTO `bidding` VALUES (21,'tristan.hcmus.study@gmail.com','2022-01-07 10:17:08',12500000,17000000);
INSERT INTO `bidding` VALUES (21,'tristan.hcmus.study@gmail.com','2022-01-15 06:51:25',13000000,17000000);

INSERT INTO `bidding` VALUES (22,'thanhhoang4869@gmail.com','2021-12-13 02:40:00',3000000,9000000);
INSERT INTO `bidding` VALUES (22,'thanhhoang4869@gmail.com','2021-12-19 05:20:00',4000000,9000000);
INSERT INTO `bidding` VALUES (22,'tristan.hcmus.study@gmail.com','2021-12-25 08:00:00',10000000,11000000);
INSERT INTO `bidding` VALUES (22,'vminathanhv@gmail.com','2021-12-31 10:40:00',12000000,14000000);
INSERT INTO `bidding` VALUES (22,'tristan.hcmus.study@gmail.com','2022-01-06 13:20:00',15000000,15000000);
INSERT INTO `bidding` VALUES (22,'phucthai0108@gmail.com','2022-01-12 16:00:00',16000000,16000000);
INSERT INTO `bidding` VALUES (22,'thanhhoang4869@gmail.com','2022-01-18 18:40:00',17000000,17000000);

INSERT INTO `bidding` VALUES (23,'springfieldcaptain@gmail.com','2021-12-12 00:00:00',3000000,4000000);
INSERT INTO `bidding` VALUES (23,'thanhhoang4869@gmail.com','2021-12-17 00:00:00',5000000,7000000);
INSERT INTO `bidding` VALUES (23,'huyanhngo@gmail.com','2021-12-22 00:00:00',8000000,9000000);
INSERT INTO `bidding` VALUES (23,'phucthai0108@gmail.com','2021-12-27 00:00:00',10000000,12000000);
INSERT INTO `bidding` VALUES (23,'phucthai0108@gmail.com','2022-01-01 00:00:00',11000000,12000000);
INSERT INTO `bidding` VALUES (23,'phucthai0108@gmail.com','2022-01-06 00:00:00',12000000,12000000);
INSERT INTO `bidding` VALUES (23,'tristan.hcmus.study@gmail.com','2022-01-11 00:00:00',13000000,16000000);
INSERT INTO `bidding` VALUES (23,'tristan.hcmus.study@gmail.com','2022-01-16 00:00:00',14000000,16000000);
INSERT INTO `bidding` VALUES (23,'tristan.hcmus.study@gmail.com','2022-01-21 00:00:00',15000000,16000000);

INSERT INTO `bidding` VALUES (24,'springfieldcaptain@gmail.com','2021-12-11 14:00:00',3000000,5000000);
INSERT INTO `bidding` VALUES (24,'huyanhngo@gmail.com','2021-12-16 04:00:00',6000000,6000000);
INSERT INTO `bidding` VALUES (24,'springfieldcaptain@gmail.com','2021-12-20 18:00:00',7000000,8000000);
INSERT INTO `bidding` VALUES (24,'thanhhoang4869@gmail.com','2021-12-25 08:00:00',9000000,12000000);
INSERT INTO `bidding` VALUES (24,'thanhhoang4869@gmail.com','2021-12-29 22:00:00',10000000,12000000);
INSERT INTO `bidding` VALUES (24,'springfieldcaptain@gmail.com','2022-01-03 12:00:00',13000000,13000000);
INSERT INTO `bidding` VALUES (24,'huyanhngo@gmail.com','2022-01-08 02:00:00',14000000,14000000);
INSERT INTO `bidding` VALUES (24,'sinsin.4869@gmail.com','2022-01-12 16:00:00',15000000,16000000);
INSERT INTO `bidding` VALUES (24,'sinsin.4869@gmail.com','2022-01-17 06:00:00',16000000,16000000);
INSERT INTO `bidding` VALUES (24,'vminathanhv@gmail.com','2022-01-21 20:00:00',17000000,18000000);

INSERT INTO `bidding` VALUES (25,'tristan.hcmus.study@gmail.com','2021-12-12 12:00:00',3000000,3000000);
INSERT INTO `bidding` VALUES (25,'vminathanhv@gmail.com','2021-12-18 00:00:00',4000000,7000000);
INSERT INTO `bidding` VALUES (25,'vminathanhv@gmail.com','2021-12-23 12:00:00',5000000,7000000);
INSERT INTO `bidding` VALUES (25,'phucthai0108@gmail.com','2021-12-29 00:00:00',8000000,13000000);
INSERT INTO `bidding` VALUES (25,'phucthai0108@gmail.com','2022-01-03 12:00:00',9000000,13000000);
INSERT INTO `bidding` VALUES (25,'phucthai0108@gmail.com','2022-01-09 00:00:00',10000000,13000000);
INSERT INTO `bidding` VALUES (25,'sinsin.4869@gmail.com','2022-01-14 12:00:00',14000000,14000000);
INSERT INTO `bidding` VALUES (25,'huyanhngo@gmail.com','2022-01-20 00:00:00',15000000,15000000);

INSERT INTO `bidding` VALUES (26,'huyanhngo@gmail.com','2021-12-12 12:00:00',2500000,13500000);
INSERT INTO `bidding` VALUES (26,'huyanhngo@gmail.com','2021-12-18 00:00:00',3000000,13500000);
INSERT INTO `bidding` VALUES (26,'huyanhngo@gmail.com','2021-12-23 12:00:00',3500000,13500000);
INSERT INTO `bidding` VALUES (26,'huyanhngo@gmail.com','2021-12-29 00:00:00',4000000,13500000);
INSERT INTO `bidding` VALUES (26,'huyanhngo@gmail.com','2022-01-03 12:00:00',4500000,13500000);
INSERT INTO `bidding` VALUES (26,'huyanhngo@gmail.com','2022-01-09 00:00:00',5000000,13500000);
INSERT INTO `bidding` VALUES (26,'huyanhngo@gmail.com','2022-01-14 12:00:00',5500000,13500000);
INSERT INTO `bidding` VALUES (26,'sinsin.4869@gmail.com','2022-01-20 00:00:00',14000000,16000000);

INSERT INTO `bidding` VALUES (27,'huyanhngo@gmail.com','2021-12-13 02:40:00',2500000,14500000);
INSERT INTO `bidding` VALUES (27,'huyanhngo@gmail.com','2021-12-19 05:20:00',3000000,14500000);
INSERT INTO `bidding` VALUES (27,'huyanhngo@gmail.com','2021-12-25 08:00:00',3500000,14500000);
INSERT INTO `bidding` VALUES (27,'huyanhngo@gmail.com','2021-12-31 10:40:00',4000000,14500000);
INSERT INTO `bidding` VALUES (27,'huyanhngo@gmail.com','2022-01-06 13:20:00',4500000,14500000);
INSERT INTO `bidding` VALUES (27,'huyanhngo@gmail.com','2022-01-12 16:00:00',5000000,14500000);
INSERT INTO `bidding` VALUES (27,'huyanhngo@gmail.com','2022-01-18 18:40:00',5500000,14500000);

INSERT INTO `bidding` VALUES (28,'huyanhngo@gmail.com','2021-12-12 00:00:00',3000000,8000000);
INSERT INTO `bidding` VALUES (28,'huyanhngo@gmail.com','2021-12-17 00:00:00',4000000,8000000);
INSERT INTO `bidding` VALUES (28,'sinsin.4869@gmail.com','2021-12-22 00:00:00',9000000,9000000);
INSERT INTO `bidding` VALUES (28,'phucthai0108@gmail.com','2021-12-27 00:00:00',10000000,11000000);
INSERT INTO `bidding` VALUES (28,'springfieldcaptain@gmail.com','2022-01-01 00:00:00',12000000,12000000);
INSERT INTO `bidding` VALUES (28,'tristan.hcmus.study@gmail.com','2022-01-06 00:00:00',13000000,14000000);
INSERT INTO `bidding` VALUES (28,'springfieldcaptain@gmail.com','2022-01-11 00:00:00',15000000,15000000);
INSERT INTO `bidding` VALUES (28,'tristan.hcmus.study@gmail.com','2022-01-16 00:00:00',16000000,16000000);
INSERT INTO `bidding` VALUES (28,'thanhhoang4869@gmail.com','2022-01-21 00:00:00',17000000,17000000);

INSERT INTO `bidding` VALUES (29,'tristan.hcmus.study@gmail.com','2021-12-11 14:00:00',3000000,6000000);
INSERT INTO `bidding` VALUES (29,'thanhhoang4869@gmail.com','2021-12-16 04:00:00',7000000,7000000);
INSERT INTO `bidding` VALUES (29,'tristan.hcmus.study@gmail.com','2021-12-20 18:00:00',8000000,10000000);
INSERT INTO `bidding` VALUES (29,'thanhhoang4869@gmail.com','2021-12-25 08:00:00',11000000,11000000);
INSERT INTO `bidding` VALUES (29,'sinsin.4869@gmail.com','2021-12-29 22:00:00',12000000,12000000);
INSERT INTO `bidding` VALUES (29,'thanhhoang4869@gmail.com','2022-01-03 12:00:00',13000000,14000000);
INSERT INTO `bidding` VALUES (29,'thanhhoang4869@gmail.com','2022-01-08 02:00:00',14000000,14000000);
INSERT INTO `bidding` VALUES (29,'phucthai0108@gmail.com','2022-01-12 16:00:00',15000000,15000000);
INSERT INTO `bidding` VALUES (29,'springfieldcaptain@gmail.com','2022-01-17 06:00:00',16000000,16000000);
INSERT INTO `bidding` VALUES (29,'sinsin.4869@gmail.com','2022-01-21 20:00:00',17000000,18000000);

INSERT INTO `bidding` VALUES (31,'phucthai0108@gmail.com','2021-12-12 00:00:00',600000,900000);
INSERT INTO `bidding` VALUES (31,'huyanhngo@gmail.com','2021-12-17 00:00:00',1000000,1100000);
INSERT INTO `bidding` VALUES (31,'sinsin.4869@gmail.com','2021-12-22 00:00:00',1200000,1200000);
INSERT INTO `bidding` VALUES (31,'tristanhuyanhngo@gmail.com','2021-12-27 00:00:00',1300000,1300000);
INSERT INTO `bidding` VALUES (31,'vminathanhv@gmail.com','2022-01-01 00:00:00',1400000,1400000);
INSERT INTO `bidding` VALUES (31,'tristan.hcmus.study@gmail.com','2022-01-06 00:00:00',1500000,1500000);
INSERT INTO `bidding` VALUES (31,'tristanhuyanhngo@gmail.com','2022-01-11 00:00:00',1600000,1600000);
INSERT INTO `bidding` VALUES (31,'springfieldcaptain@gmail.com','2022-01-16 00:00:00',1700000,1700000);
INSERT INTO `bidding` VALUES (31,'sinsin.4869@gmail.com','2022-01-21 00:00:00',1800000,1800000);

INSERT INTO `bidding` VALUES (32,'vminathanhv@gmail.com','2021-12-14 20:34:17',600000,1400000);
INSERT INTO `bidding` VALUES (32,'vminathanhv@gmail.com','2021-12-22 17:08:34',700000,1400000);
INSERT INTO `bidding` VALUES (32,'vminathanhv@gmail.com','2021-12-30 13:42:51',800000,1400000);
INSERT INTO `bidding` VALUES (32,'springfieldcaptain@gmail.com','2022-01-07 10:17:08',1500000,1700000);
INSERT INTO `bidding` VALUES (32,'springfieldcaptain@gmail.com','2022-01-15 06:51:25',1600000,1700000);

INSERT INTO `bidding` VALUES (34,'springfieldcaptain@gmail.com','2021-12-13 02:40:00',600000,700000);
INSERT INTO `bidding` VALUES (34,'phucthai0108@gmail.com','2021-12-19 05:20:00',800000,900000);
INSERT INTO `bidding` VALUES (34,'sinsin.4869@gmail.com','2021-12-25 08:00:00',1000000,1000000);
INSERT INTO `bidding` VALUES (34,'tristan.hcmus.study@gmail.com','2021-12-31 10:40:00',1100000,1300000);
INSERT INTO `bidding` VALUES (34,'phucthai0108@gmail.com','2022-01-06 13:20:00',1400000,1400000);
INSERT INTO `bidding` VALUES (34,'tristan.hcmus.study@gmail.com','2022-01-12 16:00:00',1500000,1600000);
INSERT INTO `bidding` VALUES (34,'tristan.hcmus.study@gmail.com','2022-01-18 18:40:00',1600000,1600000);

INSERT INTO `bidding` VALUES (35,'phucthai0108@gmail.com','2021-12-14 20:34:17',600000,600000);
INSERT INTO `bidding` VALUES (35,'tristan.hcmus.study@gmail.com','2021-12-22 17:08:34',700000,700000);
INSERT INTO `bidding` VALUES (35,'sinsin.4869@gmail.com','2021-12-30 13:42:51',800000,1200000);
INSERT INTO `bidding` VALUES (35,'sinsin.4869@gmail.com','2022-01-07 10:17:08',900000,1200000);
INSERT INTO `bidding` VALUES (35,'phucthai0108@gmail.com','2022-01-15 06:51:25',1300000,1800000);

INSERT INTO `bidding` VALUES (36,'springfieldcaptain@gmail.com','2021-12-12 00:00:00',600000,1000000);
INSERT INTO `bidding` VALUES (36,'springfieldcaptain@gmail.com','2021-12-17 00:00:00',700000,1000000);
INSERT INTO `bidding` VALUES (36,'springfieldcaptain@gmail.com','2021-12-22 00:00:00',800000,1000000);
INSERT INTO `bidding` VALUES (36,'springfieldcaptain@gmail.com','2021-12-27 00:00:00',900000,1000000);
INSERT INTO `bidding` VALUES (36,'springfieldcaptain@gmail.com','2022-01-01 00:00:00',1000000,1000000);
INSERT INTO `bidding` VALUES (36,'phucthai0108@gmail.com','2022-01-06 00:00:00',1100000,1400000);
INSERT INTO `bidding` VALUES (36,'tristan.hcmus.study@gmail.com','2022-01-11 00:00:00',1500000,1500000);
INSERT INTO `bidding` VALUES (36,'sinsin.4869@gmail.com','2022-01-16 00:00:00',1600000,1700000);
INSERT INTO `bidding` VALUES (36,'tristanhuyanhngo@gmail.com','2022-01-21 00:00:00',1800000,1800000);

INSERT INTO `bidding` VALUES (37,'thanhhoang4869@gmail.com','2021-12-12 00:00:00',600000,900000);
INSERT INTO `bidding` VALUES (37,'thanhhoang4869@gmail.com','2021-12-17 00:00:00',700000,900000);
INSERT INTO `bidding` VALUES (37,'springfieldcaptain@gmail.com','2021-12-22 00:00:00',1000000,1200000);
INSERT INTO `bidding` VALUES (37,'springfieldcaptain@gmail.com','2021-12-27 00:00:00',1100000,1200000);
INSERT INTO `bidding` VALUES (37,'springfieldcaptain@gmail.com','2022-01-01 00:00:00',1200000,1200000);
INSERT INTO `bidding` VALUES (37,'tristan.hcmus.study@gmail.com','2022-01-06 00:00:00',1300000,1400000);
INSERT INTO `bidding` VALUES (37,'phucthai0108@gmail.com','2022-01-11 00:00:00',1500000,1500000);
INSERT INTO `bidding` VALUES (37,'tristan.hcmus.study@gmail.com','2022-01-16 00:00:00',1600000,1700000);
INSERT INTO `bidding` VALUES (37,'tristan.hcmus.study@gmail.com','2022-01-21 00:00:00',1700000,1700000);

INSERT INTO `bidding` VALUES (38,'sinsin.4869@gmail.com','2021-12-13 21:00:00',600000,1200000);
INSERT INTO `bidding` VALUES (38,'sinsin.4869@gmail.com','2021-12-20 18:00:00',700000,1200000);
INSERT INTO `bidding` VALUES (38,'phucthai0108@gmail.com','2021-12-27 15:00:00',1300000,1300000);
INSERT INTO `bidding` VALUES (38,'tristan.hcmus.study@gmail.com','2022-01-03 12:00:00',1400000,1500000);
INSERT INTO `bidding` VALUES (38,'huyanhngo@gmail.com','2022-01-10 09:00:00',1600000,1600000);
INSERT INTO `bidding` VALUES (38,'phucthai0108@gmail.com','2022-01-17 06:00:00',1700000,1700000);

INSERT INTO `bidding` VALUES (39,'phucthai0108@gmail.com','2021-12-12 00:00:00',600000,800000);
INSERT INTO `bidding` VALUES (39,'phucthai0108@gmail.com','2021-12-17 00:00:00',700000,800000);
INSERT INTO `bidding` VALUES (39,'vminathanhv@gmail.com','2021-12-22 00:00:00',900000,1000000);
INSERT INTO `bidding` VALUES (39,'tristan.hcmus.study@gmail.com','2021-12-27 00:00:00',1100000,1100000);
INSERT INTO `bidding` VALUES (39,'sinsin.4869@gmail.com','2022-01-01 00:00:00',1200000,1300000);
INSERT INTO `bidding` VALUES (39,'sinsin.4869@gmail.com','2022-01-06 00:00:00',1300000,1300000);
INSERT INTO `bidding` VALUES (39,'phucthai0108@gmail.com','2022-01-11 00:00:00',1400000,1500000);
INSERT INTO `bidding` VALUES (39,'sinsin.4869@gmail.com','2022-01-16 00:00:00',1600000,1600000);
INSERT INTO `bidding` VALUES (39,'tristanhuyanhngo@gmail.com','2022-01-21 00:00:00',1700000,1700000);

INSERT INTO `bidding` VALUES (40,'tristanhuyanhngo@gmail.com','2021-12-12 12:00:00',600000,800000);
INSERT INTO `bidding` VALUES (40,'huyanhngo@gmail.com','2021-12-18 00:00:00',900000,1100000);
INSERT INTO `bidding` VALUES (40,'huyanhngo@gmail.com','2021-12-23 12:00:00',1000000,1100000);
INSERT INTO `bidding` VALUES (40,'huyanhngo@gmail.com','2021-12-29 00:00:00',1100000,1100000);
INSERT INTO `bidding` VALUES (40,'sinsin.4869@gmail.com','2022-01-03 12:00:00',1200000,1400000);
INSERT INTO `bidding` VALUES (40,'tristanhuyanhngo@gmail.com','2022-01-09 00:00:00',1500000,1600000);
INSERT INTO `bidding` VALUES (40,'tristanhuyanhngo@gmail.com','2022-01-14 12:00:00',1600000,1600000);
INSERT INTO `bidding` VALUES (40,'springfieldcaptain@gmail.com','2022-01-20 00:00:00',1700000,1700000);

INSERT INTO `bidding` VALUES (41,'tristan.hcmus.study@gmail.com','2021-12-13 02:40:00',600000,900000);
INSERT INTO `bidding` VALUES (41,'tristan.hcmus.study@gmail.com','2021-12-19 05:20:00',700000,900000);
INSERT INTO `bidding` VALUES (41,'tristan.hcmus.study@gmail.com','2021-12-25 08:00:00',800000,900000);
INSERT INTO `bidding` VALUES (41,'tristan.hcmus.study@gmail.com','2021-12-31 10:40:00',900000,900000);
INSERT INTO `bidding` VALUES (41,'tristanhuyanhngo@gmail.com','2022-01-06 13:20:00',1000000,1300000);
INSERT INTO `bidding` VALUES (41,'sinsin.4869@gmail.com','2022-01-12 16:00:00',1400000,1400000);
INSERT INTO `bidding` VALUES (41,'tristan.hcmus.study@gmail.com','2022-01-18 18:40:00',1500000,1500000);

INSERT INTO `bidding` VALUES (42,'vminathanhv@gmail.com','2021-12-12 00:00:00',600000,900000);
INSERT INTO `bidding` VALUES (42,'sinsin.4869@gmail.com','2021-12-17 00:00:00',1000000,1100000);
INSERT INTO `bidding` VALUES (42,'huyanhngo@gmail.com','2021-12-22 00:00:00',1200000,1200000);
INSERT INTO `bidding` VALUES (42,'vminathanhv@gmail.com','2021-12-27 00:00:00',1300000,1300000);
INSERT INTO `bidding` VALUES (42,'springfieldcaptain@gmail.com','2022-01-01 00:00:00',1400000,1400000);
INSERT INTO `bidding` VALUES (42,'phucthai0108@gmail.com','2022-01-06 00:00:00',1500000,1500000);
INSERT INTO `bidding` VALUES (42,'springfieldcaptain@gmail.com','2022-01-11 00:00:00',1600000,1600000);
INSERT INTO `bidding` VALUES (42,'sinsin.4869@gmail.com','2022-01-16 00:00:00',1700000,1700000);
INSERT INTO `bidding` VALUES (42,'huyanhngo@gmail.com','2022-01-21 00:00:00',1800000,1800000);

INSERT INTO `bidding` VALUES (43,'sinsin.4869@gmail.com','2021-12-12 12:00:00',600000,700000);
INSERT INTO `bidding` VALUES (43,'huyanhngo@gmail.com','2021-12-18 00:00:00',800000,1100000);
INSERT INTO `bidding` VALUES (43,'huyanhngo@gmail.com','2021-12-23 12:00:00',900000,1100000);
INSERT INTO `bidding` VALUES (43,'huyanhngo@gmail.com','2021-12-29 00:00:00',1000000,1100000);
INSERT INTO `bidding` VALUES (43,'springfieldcaptain@gmail.com','2022-01-03 12:00:00',1200000,1300000);
INSERT INTO `bidding` VALUES (43,'tristanhuyanhngo@gmail.com','2022-01-09 00:00:00',1400000,1400000);
INSERT INTO `bidding` VALUES (43,'vminathanhv@gmail.com','2022-01-14 12:00:00',1500000,1500000);
INSERT INTO `bidding` VALUES (43,'phucthai0108@gmail.com','2022-01-20 00:00:00',1600000,1800000);

INSERT INTO `bidding` VALUES (44,'sinsin.4869@gmail.com','2021-12-13 21:00:00',600000,1000000);
INSERT INTO `bidding` VALUES (44,'thanhhoang4869@gmail.com','2021-12-20 18:00:00',1100000,1400000);
INSERT INTO `bidding` VALUES (44,'thanhhoang4869@gmail.com','2021-12-27 15:00:00',1200000,1400000);
INSERT INTO `bidding` VALUES (44,'vminathanhv@gmail.com','2022-01-03 12:00:00',1500000,1600000);
INSERT INTO `bidding` VALUES (44,'tristan.hcmus.study@gmail.com','2022-01-10 09:00:00',1700000,1700000);
INSERT INTO `bidding` VALUES (44,'phucthai0108@gmail.com','2022-01-17 06:00:00',1800000,1800000);

INSERT INTO `bidding` VALUES (45,'tristan.hcmus.study@gmail.com','2021-12-14 20:34:17',600000,1400000);
INSERT INTO `bidding` VALUES (45,'tristan.hcmus.study@gmail.com','2021-12-22 17:08:34',700000,1400000);
INSERT INTO `bidding` VALUES (45,'tristan.hcmus.study@gmail.com','2021-12-30 13:42:51',800000,1400000);
INSERT INTO `bidding` VALUES (45,'tristan.hcmus.study@gmail.com','2022-01-07 10:17:08',900000,1400000);
INSERT INTO `bidding` VALUES (45,'tristan.hcmus.study@gmail.com','2022-01-15 06:51:25',1000000,1400000);

COMMIT;

-- Full text search

ALTER TABLE `product`
ADD FULLTEXT(ProName);

ALTER TABLE `category`
ADD FULLTEXT(CatName);