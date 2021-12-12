SET NAMES utf8mb4;

-- SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for Cap Danh Muc
-- ----------------------------
DROP TABLE IF EXISTS `CapDanhMuc`;
CREATE TABLE `CapDanhMuc` (
  `MaCapDanhMuc` int unsigned NOT NULL AUTO_INCREMENT,
  `TenCapDanhMuc` nvarchar(50) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`MaCapDanhMuc`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for Danh Muc
-- ----------------------------
DROP TABLE IF EXISTS `DanhMuc`;
CREATE TABLE `DanhMuc` (
  `MaDanhMuc` int unsigned NOT NULL AUTO_INCREMENT,
  `TenDanhMuc` nvarchar(50) COLLATE utf8_general_ci NOT NULL,
  `CapDanhMuc` int unsigned NOT NULL, 
  PRIMARY KEY (`MaDanhMuc`),
  FOREIGN KEY (`CapDanhMuc`) REFERENCES CapDanhMuc(`MaCapDanhMuc`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `Users`;
CREATE TABLE `Users` (
  `Email` char(50) COLLATE utf8_general_ci NOT NULL,
  `username` varchar(50) COLLATE utf8_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_general_ci NOT NULL,
  `HoTen` nvarchar(50) COLLATE utf8_general_ci NOT NULL,
  `DiaChi` nvarchar(80) COLLATE utf8_general_ci,
  `NgaySinh` date,
  `NgayDangKyThanhVien` date NOT NULL,
  `LoaiNguoiDung` char(1) NOT NULL,
  `DiemDanhGia` int unsigned,
  PRIMARY KEY (`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `SanPham`;
CREATE TABLE `SanPham` (
  `MaSanPham` int unsigned NOT NULL AUTO_INCREMENT,
  `MaDanhMuc` int unsigned NOT NULL,
  `EmailNguoiBan` char(50) COLLATE utf8_general_ci NOT NULL , 
  `TenSanPham` nvarchar(50) COLLATE utf8_general_ci NOT NULL,
  `GiaKhoiDiem` int unsigned NOT NULL,
  `BuocGia` int unsigned NOT NULL,
  `GiaMuaNgay` int unsigned NOT NULL,
  `NgayDangSanPham` datetime NOT NULL,
  `NgayKetThuc` datetime,
  `TuDongGiaHan` bit NOT NULL,
  `EmailNguoiMuaThanhCong` char(50) COLLATE utf8_general_ci,
  PRIMARY KEY (`MaSanPham`),
  FOREIGN KEY (`MaDanhMuc`) REFERENCES DanhMuc(`MaDanhMuc`),
  FOREIGN KEY (`EmailNguoiBan`) REFERENCES Users(`Email`),
  FOREIGN KEY (`EmailNguoiMuaThanhCong`) REFERENCES Users(`Email`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for Images of Products
-- ----------------------------
DROP TABLE IF EXISTS `AnhSanPham`;
CREATE TABLE `AnhSanPham` (
  `MaSanPham` int unsigned NOT NULL,
  `STT` int unsigned NOT NULL,
  `URL` char(50) NOT NULL,
  PRIMARY KEY (`MaSanPham`,`STT`),
  FOREIGN KEY (`MaSanPham`) REFERENCES SanPham(`MaSanPham`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Table structure for Description of Products
-- ----------------------------
DROP TABLE IF EXISTS `MoTaSanPham`;
CREATE TABLE `MoTaSanPham` (
  `MaSanPham` int unsigned NOT NULL,
  `NgayMoTa` datetime NOT NULL,
  `NoiDungMoTa` text COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`MaSanPham`,`NgayMoTa`),
  FOREIGN KEY (`MaSanPham`) REFERENCES SanPham(`MaSanPham`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Gia Tu Dong
-- ----------------------------
DROP TABLE IF EXISTS `GiaTuDong`;
CREATE TABLE `GiaTuDong` (
  `MaSanPham` int unsigned NOT NULL,
  `EmailUser` char(50) COLLATE utf8_general_ci NOT NULL,
  `GiaMax` int unsigned NOT NULL,
  PRIMARY KEY (`MaSanPham`,`EmailUser`),
  FOREIGN KEY (`MaSanPham`) REFERENCES SanPham(`MaSanPham`),
  FOREIGN KEY (`EmailUser`) REFERENCES Users(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Danh sach yeu thich
-- ----------------------------
DROP TABLE IF EXISTS `DanhSachYeuThich`;
CREATE TABLE `DanhSachYeuThich` (
  `MaSanPham` int unsigned NOT NULL,
  `EmailUser` char(50) COLLATE utf8_general_ci NOT NULL,
  `TinhTrangSanPham` bit NOT NULL,
  PRIMARY KEY (`MaSanPham`,`EmailUser`),
  FOREIGN KEY (`MaSanPham`) REFERENCES SanPham(`MaSanPham`),
  FOREIGN KEY (`EmailUser`) REFERENCES Users(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- San pham dang tham gia dau gia
-- ----------------------------
DROP TABLE IF EXISTS `DanhSachDangThamGia`;
CREATE TABLE `DanhSachDangThamGia` (
  `MaSanPham` int unsigned NOT NULL,
  `EmailUser` char(50) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`MaSanPham`,`EmailUser`),
  FOREIGN KEY (`MaSanPham`) REFERENCES SanPham(`MaSanPham`),
  FOREIGN KEY (`EmailUser`) REFERENCES Users(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- San pham da tham gia dau gia thanh cong
-- ----------------------------
DROP TABLE IF EXISTS `DanhSachDauGiaThanhCong`;
CREATE TABLE `DanhSachDauGiaThanhCong` (
  `MaSanPham` int unsigned NOT NULL,
  `EmailUser` char(50) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`MaSanPham`),
  FOREIGN KEY (`MaSanPham`) REFERENCES SanPham(`MaSanPham`),
  FOREIGN KEY (`EmailUser`) REFERENCES Users(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Danh sach Bidder khong duoc tham gia dau gia
-- ----------------------------
DROP TABLE IF EXISTS `DanhSachBidderKhongDuocThamGia`;
CREATE TABLE `DanhSachBidderKhongDuocThamGia` (
  `MaSanPham` int unsigned NOT NULL,
  `EmailUser` char(50) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`MaSanPham`,`EmailUser`),
  FOREIGN KEY (`MaSanPham`) REFERENCES SanPham(`MaSanPham`),
  FOREIGN KEY (`EmailUser`) REFERENCES Users(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Danh Gia Bidder
-- ----------------------------
DROP TABLE IF EXISTS `DanhGiaBidder`;
CREATE TABLE `DanhGiaBidder` (
  `EmailBidder` char(50) COLLATE utf8_general_ci NOT NULL,
  `EmailSeller` char(50) COLLATE utf8_general_ci NOT NULL,
  `LoiDanhGia` text COLLATE utf8_general_ci,
  `DiemDanhGia` tinyint NOT NULL,
  PRIMARY KEY (`EmailBidder`,`EmailSeller`),
  FOREIGN KEY (`EmailBidder`) REFERENCES Users(`Email`),
  FOREIGN KEY (`EmailSeller`) REFERENCES Users(`Email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Danh Gia Seller
-- ----------------------------
DROP TABLE IF EXISTS `DanhGiaBidder`;
CREATE TABLE `DanhGiaBidder` (
  `EmailSeller` char(50) COLLATE utf8_general_ci NOT NULL,
  `EmailBidder` char(50) COLLATE utf8_general_ci NOT NULL,
  `LoiDanhGia` text COLLATE utf8_general_ci,
  `DiemDanhGia` tinyint NOT NULL,
  PRIMARY KEY (`EmailSeller`,`EmailBidder`),
  FOREIGN KEY (`EmailBidder`) REFERENCES Users(`Email`),
  FOREIGN KEY (`EmailSeller`) REFERENCES Users(`Email`)
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
INSERT INTO `CapDanhMuc` VALUES (1, 'Accessories');
INSERT INTO `CapDanhMuc` VALUES (2, 'Electronics');
INSERT INTO `CapDanhMuc` VALUES (3, 'Fashion');
COMMIT;

-- ----------------------------
-- Records of Danh Muc
-- ----------------------------
BEGIN;
INSERT INTO `DanhMuc` VALUES (1, 'Ring',1);
INSERT INTO `DanhMuc` VALUES (2, 'Watch',1);
INSERT INTO `DanhMuc` VALUES (3, 'Laptop',2);
INSERT INTO `DanhMuc` VALUES (4, 'Mobile',2);
INSERT INTO `DanhMuc` VALUES (5, 'Smart Watch',2);
INSERT INTO `DanhMuc` VALUES (6, 'Clothing',3);
INSERT INTO `DanhMuc` VALUES (7, 'Shoes',3);
COMMIT;

-- Admin (0) - Seller (1) - Bidder (2) 
-- ----------------------------
-- Records of Nguoi Ban
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES ('kysutainangqsb@gmail.com','seller1','seller1','Ngô Minh Quân','154 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-01-01','2021-12-07','1',0);
INSERT INTO `users` VALUES ('abc@gmail.com','seller2','seller2','Ngô Ngọc Đăng Khoa','155 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-02-01','2021-12-07','1',0);
COMMIT;

-- ----------------------------
-- Records of Admin
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES ('huyanhngo@gmail.com','admin1','admin1','Ngô Huy Anh','153 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','2001-01-01','2021-12-07','0',0);
COMMIT;

-- ----------------------------
-- Records of Nguoi Mua
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES ('springfieldcaptain@gmail.com','bidder1','bidder1','Ngô Minh Triết','156 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-01-01','2021-12-07','2',0);
INSERT INTO `users` VALUES ('xyz@gmail.com','bidder2','bidder2','Ngô Ngọc Đăng Khôi','157 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-03-01','2021-12-07','2',0);
INSERT INTO `users` VALUES ('a@gmail.com','bidder3','bidder3','Ngô Ngọc Đăng Minh','158 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-04-01','2021-12-07','2',0);
INSERT INTO `users` VALUES ('b@gmail.com','bidder4','bidder4','Ngô Ngọc Đăng Khánh','159 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-05-01','2021-12-07','2',0);
INSERT INTO `users` VALUES ('c@gmail.com','bidder5','bidder5','Ngô Ngọc Đăng Huy','160 Nguyễn Chí Thanh, Phường 9, Quận 5, TP.HCM','1990-06-01','2021-12-07','2',0);
COMMIT;

-- ----------------------------
-- Records of San Pham
-- ----------------------------
BEGIN;
INSERT INTO `sanpham` VALUES (11, 3, 'kysutainangqsb@gmail.com','Apple Macbook Pro 16 M1 Max 2021', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (12, 3, 'kysutainangqsb@gmail.com','Apple Macbook Pro 14 M1 Max 2021', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (13, 3, 'kysutainangqsb@gmail.com','Apple Macbook Air 2020', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (14, 3, 'kysutainangqsb@gmail.com','Asus Rog Zephyrus Gaming G14', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (15, 3, 'kysutainangqsb@gmail.com','Asus Zenbook UX371EA i7', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (16, 3, 'kysutainangqsb@gmail.com','Asus Zenbook Duo UX482EA i7', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (17, 3, 'kysutainangqsb@gmail.com','HP Omen 15 EK0078TX i7', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);

INSERT INTO `sanpham` VALUES (26, 4, 'kysutainangqsb@gmail.com','Iphone 13 Pro', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (27, 4, 'kysutainangqsb@gmail.com','Xiaomi 10T Pro', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (28, 4, 'kysutainangqsb@gmail.com','Samsung Galaxy Z Flip 3 5G 256GB', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (29, 4, 'kysutainangqsb@gmail.com','Itel IT2171', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (30, 4, 'kysutainangqsb@gmail.com','Energizer E20', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);

INSERT INTO `sanpham` VALUES (38, 7, 'kysutainangqsb@gmail.com','Nike Air Force 1 07 QS', 100000, 2, 2000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (39, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Brown', 200000, 2, 1000000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (40, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Black', 150000, 2, 2500000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (41, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Gray', 150000, 2, 2500000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (42, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi RB', 150000, 2, 2500000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (43, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Red', 150000, 2, 2500000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (44, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Normal', 150000, 2, 2500000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (45, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (46, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2021-12-31', 1, NULL);
INSERT INTO `sanpham` VALUES (47, 7, 'kysutainangqsb@gmail.com','Nike Blazer Mid 77 Cozi Sky', 150000, 2, 2500000, '2021-12-07', '2021-12-31', 1, NULL);
COMMIT;

-- ----------------------------
-- Records of Mo ta San Pham
-- ----------------------------
BEGIN;
INSERT INTO `motasanpham` VALUES (11, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (12, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (13, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (14, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (15, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (16, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (17, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');

INSERT INTO `motasanpham` VALUES (26, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (27, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (28, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (29, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (30, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');

INSERT INTO `motasanpham` VALUES (38, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (39, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (40, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (41, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (42, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (43, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (44, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (45, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (46, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
INSERT INTO `motasanpham` VALUES (47, '2021-12-07', '<P><STRONG>Jewelry Information</STRONG></P>\r\n<UL>\r\n    <LI>Loại hàng: Hàng trong nước</LI>\r\n</UL>\r\n');
COMMIT;