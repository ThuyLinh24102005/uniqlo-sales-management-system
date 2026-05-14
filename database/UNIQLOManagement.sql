USE QLBH_UNIQLO;
GO

-- Tạo người dùng nttlinh trong SQL Server và cấp quyền quản trị cơ sở dữ liệu
-- Tạo user trong database (nếu chưa tồn tại)
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'nttlinh')
BEGIN
    CREATE LOGIN nttlinh with PASSWORD='123';
END
GO
-- Thêm user vào role db_owner (nếu chưa có)
ALTER ROLE db_owner ADD MEMBER nttlinh;
GO

DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql = @sql + '
ALTER TABLE [' + OBJECT_SCHEMA_NAME(parent_object_id) + '].[' + OBJECT_NAME(parent_object_id) + ']
DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys
WHERE parent_object_id IN (SELECT object_id FROM sys.tables);
-- Thực thi câu lệnh động
EXEC sp_executesql @sql;
DROP TABLE IF EXISTS CT_PHIEUDOITRA;
DROP TABLE IF EXISTS PHIEUDOITRA;
DROP TABLE IF EXISTS CT_HOADONBAN;
DROP TABLE IF EXISTS HOADONBAN;
DROP TABLE IF EXISTS CT_PHIEUNHAP;
DROP TABLE IF EXISTS PHIEUNHAP;
DROP TABLE IF EXISTS CT_KHUYENMAI;
DROP TABLE IF EXISTS KHUYENMAI;
DROP TABLE IF EXISTS NHATKYTOKHO;
DROP TABLE IF EXISTS TAIKHOAN;
DROP TABLE IF EXISTS SANPHAM;
DROP TABLE IF EXISTS LOAISANPHAM;
DROP TABLE IF EXISTS NHACUNGCAP;
DROP TABLE IF EXISTS KHACHHANG;
DROP TABLE IF EXISTS NHANVIEN;

-- Bảng chính
-- 1. Bảng LOAISANPHAM
CREATE TABLE LOAISANPHAM (
    MaLoai CHAR(10) PRIMARY KEY,
    TenLoai NVARCHAR(50),
    MoTa NVARCHAR(100)
);
go
-- 2. Bảng NHACUNGCAP
CREATE TABLE NHACUNGCAP (
    MaNCC CHAR(10) PRIMARY KEY,
    TenNCC NVARCHAR(50),
    DiaChi NVARCHAR(100),
    SDT CHAR(10),
    Email NVARCHAR(50)
);
go
-- 3. Bảng SANPHAM
CREATE TABLE SANPHAM (
    MaSP CHAR(10) PRIMARY KEY,
    MaLoai CHAR(10) NOT NULL,
    MaNCC CHAR(10) NOT NULL,
    TenSP NVARCHAR(50),
    Size NVARCHAR(10),
    Mau NVARCHAR(50),
    GiaBan DECIMAL(18,2),
    FOREIGN KEY (MaLoai) REFERENCES LOAISANPHAM(MaLoai),
    FOREIGN KEY (MaNCC) REFERENCES NHACUNGCAP(MaNCC)
);
go
-- 4. Bảng NHANVIEN
CREATE TABLE NHANVIEN (
    MaNV CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(50),
    ChucVu NVARCHAR(50),
    SDT CHAR(10),
    Email NVARCHAR(100)
);
go
-- 5.Bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MaKH CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(50),
    SDT CHAR(10),
    Email NVARCHAR(50),
    TongChiTieu DECIMAL(18,2),
    HangThanhVien NVARCHAR(50)
);
go
-- 6.Bảng KHUYENMAI
CREATE TABLE KHUYENMAI (
    MaKM CHAR(10) PRIMARY KEY,
    TenCTKM NVARCHAR(50),
    NgayBD DATE,
    NgayKT DATE,
    HinhThuc NVARCHAR(50),
    GiaTriGiam DECIMAL(18,2)
);
go
-- 7. Bảng PHIEUNHAP
CREATE TABLE PHIEUNHAP (
    MaPN CHAR(10) PRIMARY KEY,
    MaNV CHAR(10),
    NgayNhap DATE,
    TongTien DECIMAL(18,2),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);
go
-- 8.Bảng CT_PHIEUNHAP
CREATE TABLE CT_PHIEUNHAP (
    MaPN CHAR(10),
    MaSP CHAR(10),
    SoLuong INT,
    DonGia DECIMAL(18,2),
    ThanhTien DECIMAL(18,2),
    PRIMARY KEY (MaPN, MaSP),
    FOREIGN KEY (MaPN) REFERENCES PHIEUNHAP(MaPN),
    FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)
);
go
-- 9. Bảng HOADONBAN
CREATE TABLE HOADONBAN (
    MaHD CHAR(10) PRIMARY KEY,
    MaNV CHAR(10),
    MaKH CHAR(10),
    MaKM CHAR(10),
    NgayBan DATE,
    TongTien DECIMAL(18,2),
    HinhThucTT NVARCHAR(50),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    FOREIGN KEY (MaKM) REFERENCES KHUYENMAI(MaKM)
);
go
--10.Bảng CT_HOADONBAN
CREATE TABLE CT_HOADONBAN (
    MaHD CHAR(10),
    MaSP CHAR(10),
    SoLuong INT,
    DonGia DECIMAL(18,2),
    ThanhTien DECIMAL(18,2),
    PRIMARY KEY (MaHD, MaSP),
    FOREIGN KEY (MaHD) REFERENCES HOADONBAN(MaHD),
    FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)
);
go
-- 11. Bảng PHIEUDOITRA
CREATE TABLE PHIEUDOITRA (
    MaPhieu CHAR(10) PRIMARY KEY,
    MaHD CHAR(10),
    NgayDT DATE,
    LoaiXuLy NVARCHAR(50),
    LyDo NVARCHAR(200),
    MaNV CHAR(10),
    FOREIGN KEY (MaHD) REFERENCES HOADONBAN(MaHD),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);
go
-- 12. Bảng CT_PHIEUDOITRA
CREATE TABLE CT_PHIEUDOITRA (
    MaPhieu CHAR(10),
    MaSP CHAR(10),
    SoLuong INT,
    GhiChu NVARCHAR(200),
    PRIMARY KEY (MaPhieu, MaSP),
    FOREIGN KEY (MaPhieu) REFERENCES PHIEUDOITRA(MaPhieu),
    FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)
);
go
-- 13. Bảng TAIKHOAN
CREATE TABLE TAIKHOAN (
    MaTK CHAR(10) PRIMARY KEY,
    MaNV CHAR(10),
    TenDangNhap VARCHAR(50),
    MatKhau VARCHAR(50),
    QuyenHan NVARCHAR(30),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);
go
-- 14. Bảng NHATKYTONKHO
CREATE TABLE NHATKYTOKHO (
    MaNK CHAR(10) PRIMARY KEY,
    NgayGhi DATE,
    LoaiPhatSinh NVARCHAR(50),
    SoLuongThayDoi INT,
    TonSau INT,
    GhiChu NVARCHAR(50),
    MaSP CHAR(10),
    FOREIGN KEY (MaSP) REFERENCES SANPHAM

-- 1. Dữ Liệu Bảng LOAISANPHAM
INSERT INTO LOAISANPHAM VALUES
('L001', N'Áo thun', N'Áo thun nam, nữ, trẻ em'),
('L002', N'Áo sơ mi', N'Áo sơ mi nam, nữ'),
('L003', N'Quần jean', N'Quần jean nam, nữ'),
('L004', N'Quần tây', N'Quần tây công sở'),
('L005', N'Váy', N'Váy nữ, váy công sở, váy dạo phố'),
('L006', N'Đầm', N'Đầm dự tiệc, đầm công sở'),
('L007', N'Áo khoác', N'Áo khoác gió, áo khoác dạ, áo khoác jeans'),
('L008', N'Áo len', N'Áo len nam, áo len nữ'),
('L009', N'Giày dép', N'Giày thể thao, giày sandals, giày búp bê'),
('L010', N'Túi xách', N'Túi xách nam, túi xách nữ, balo'),
('L011', N'Phụ kiện', N'Nón, khăn quàng, thắt lưng'),
('L012', N'Smart casual', N'Áo vest, blazer, áo polo'),
('L013', N'Thể thao', N'Quần áo thể thao nam nữ'),
('L014', N'Đồ trẻ em', N'Quần áo, váy, áo thun trẻ em'),
('L015', N'Đồ lót', N'Áo lót, quần lót nam nữ');

-- 2. Dữ liệu bảng NHACUNGCAP
INSERT INTO NHACUNGCAP VALUES
('N001', N'UniSupplier VN', N'TP.HCM, Quận 1', '090100001', 'supplier1@uniqlo.vn'),
('N002', N'FashionPro', N'TP.HCM, Quận 3', '090100002', 'fashionpro@gmail.com'),
('N003', N'Textile Co.', N'Bắc Ninh, Việt Nam', '090100003', 'textileco@gmail.com'),
('N004', N'Global Fashion', N'Đà Nẵng', '090100004', 'globalfashion@gmail.com'),
('N005', N'StyleFactory', N'Hà Nội, Quận Hoàn Kiếm', '090100005', 'stylefactory@gmail.com'),
('N006', N'ColorTrend', N'TP.HCM, Quận 7', '090100006', 'colortrend@gmail.com'),
('N007', N'EcoTextiles', N'Hải Phòng', '090100007', 'ecotextiles@gmail.com'),
('N008', N'UrbanWear', N'TP.HCM, Quận 5', '090100008', 'urbanwear@gmail.com'),
('N009', N'SportLine', N'Hà Nội, Quận Cầu Giấy', '090100009', 'sportline@gmail.com'),
('N010', N'KidsFashion', N'TP.HCM, Quận 10', '090100010', 'kidsfashion@gmail.com'),
('N011', N'Luxe Apparel', N'Đà Nẵng', '090100011', 'luxeapparel@gmail.com'),
('N012', N'CasualStyle', N'Hà Nội, Quận Hai Bà Trưng', '090100012', 'casualstyle@gmail.com'),
('N013', N'PremiumWear', N'TP.HCM, Quận Bình Thạnh', '090100013', 'premiumwear@gmail.com'),
('N014', N'TrendyShop', N'Hải Phòng', '090100014', 'trendyshop@gmail.com'),
('N015', N'ShopUnik', N'Hà Nội, Quận Thanh Xuân', '090100015', 'shopunik@gmail.com');

-- 3. Dữ liệu bảng SANPHAM
INSERT INTO SANPHAM VALUES
('SP001', 'L001', 'N001', N'Áo thun nam cổ tròn', 'M', N'Đen', 250000),
('SP002', 'L001', 'N002', N'Áo thun nữ form rộng', 'L', N'Trắng', 270000),
('SP003', 'L002', 'N003', N'Áo sơ mi nam công sở', 'XL', N'Xanh dương', 350000),
('SP004', 'L002', 'N004', N'Áo sơ mi nữ caro', 'M', N'Đỏ', 360000),
('SP005', 'L003', 'N005', N'Quần jean nam skinny', '32', N'Xanh đậm', 450000),
('SP006', 'L003', 'N006', N'Quần jean nữ ống suông', '28', N'Đen', 420000),
('SP007', 'L004', 'N007', N'Quần tây nam công sở', '34', N'Xám', 500000),
('SP008', 'L004', 'N008', N'Quần tây nữ công sở', 'S', N'Đen', 480000),
('SP009', 'L005', 'N009', N'Váy nữ xòe', 'M', N'Hồng', 400000),
('SP010', 'L006', 'N010', N'Đầm dự tiệc nữ', 'L', N'Đỏ', 550000),
('SP011', 'L007', 'N011', N'Áo khoác gió nam', 'M', N'Xám', 600000),
('SP012', 'L008', 'N012', N'Áo len nữ', 'L',N'Be', 350000),
('SP013', 'L009', 'N013', N'Giày thể thao nam', '42',N'Trắng', 700000),
('SP014', 'L010', 'N014', N'Túi xách nữ', 'OneSize',N'Đen', 650000),
('SP015', 'L011', 'N015', N'Nón lưỡi trai', 'OneSize',N'Xanh', 150000);

-- 4. Dữ liệu bảng NHANVIEN
INSERT INTO NHANVIEN (MaNV, HoTen, ChucVu, SDT, Email) VALUES
('NV001', N'Nguyễn Văn Hưng', N'Quản lý cửa hàng', '091100001', 'hung.nguyen@uniqlo.vn'),
('NV002', N'Trần Thị Lan', N'Nhân viên bán hàng', '091100002', 'lan.tran@uniqlo.vn'),
('NV003', N'Phạm Văn Tuấn', N'Nhân viên kho', '091100003', 'tuan.pham@uniqlo.vn'),
('NV004', N'Ngô Thị Mai', N'Quản lý cửa hàng', '091100004', 'mai.ngo@uniqlo.vn'),
('NV005', N'Lê Văn Long', N'Quản lý cửa hàng', '091100005', 'long.le@uniqlo.vn'),
('NV006', N'Hoàng Thị Phương', N'Nhân viên kho', '091100006', 'phuong.hoang@uniqlo.vn'),
('NV007', N'Vũ Văn Quang', N'Nhân viên thu ngân', '091100007', 'quang.vu@uniqlo.vn'),
('NV008', N'Đặng Thị Hạnh', N'Nhân viên bán hàng', '091100008', 'hanh.dang@uniqlo.vn'),
('NV009', N'Phan Văn Bình', N'Nhân viên bán hàng', '091100009', 'binh.phan@uniqlo.vn'),
('NV010', N'Bùi Thị Thu', N'Nhân viên kho', '091100010', 'thu.bui@uniqlo.vn'),
('NV011', N'Nguyễn Minh Hoài', N'Nhân viên bán hàng', '091100011', 'hoai.nguyen@uniqlo.vn'),
('NV012', N'Hoàng Thị Bích', N'Nhân viên bán hàng', '0911122334', 'bich12@gmail.com'),
('NV013', N'Võ Minh Quân', N'Nhân viên kho', '0911223345', 'quan13@gmail.com'),
('NV014', N'Đoàn Thu Ngân', N'Nhân viên kho', '0911334456', 'ngan14@gmail.com');

-- 5. Dữ liệu bảng KHACHHANG 
INSERT INTO KHACHHANG (MaKH, HoTen, SDT, Email, TongChiTieu, HangThanhVien) VALUES
('KH001', N'Nguyễn Văn An', '090200001', 'an.nguyen@gmail.com', 5000000, N'Vàng'),
('KH002', N'Trần Thị Bích', '090200002', 'bich.tran@gmail.com', 3500000, N'Bạc'),
('KH003', N'Phạm Văn Cường', '090200003', 'cuong.pham@gmail.com', 2000000, N'Đồng'),
('KH004', N'Lê Thị Duyên', '090200004', 'duyen.le@gmail.com', 4000000, N'Bạc'),
('KH005', N'Ngô Văn Hòa', '090200005', 'hoa.ngo@gmail.com', 1000000, N'Đồng'),
('KH006', N'Hoàng Thị Lan', '090200006', 'lan.hoang@gmail.com', 6000000, N'Vàng'),
('KH007', N'Bùi Văn Minh', '090200007', 'minh.bui@gmail.com', 2500000, N'Đồng'),
('KH008', N'Đặng Thị Ngọc', '090200008', 'ngoc.dang@gmail.com', 3000000, N'Bạc'),
('KH009', N'Vũ Văn Hải', '090200009', 'hai.vu@gmail.com', 4500000, N'Vàng'),
('KH010', N'Nguyễn Thị Phương', '090200010', 'phuong.nguyen@gmail.com', 1500000, N'Đồng'),
('KH011', N'Lê Văn Khang', '090200011', 'khang.le@gmail.com', 3500000, N'Bạc'),
('KH012', N'Trần Thị Hồng', '090200012', 'hong.tran@gmail.com', 2200000, N'Đồng'),
('KH013', N'Phạm Minh Tuấn', '090200013', 'tuan.pham@gmail.com', 3000000, N'Bạc'),
('KH014', N'Ngô Thị Thanh', '090200014', 'thanh.ngo@gmail.com', 4000000, N'Bạc'),
('KH015', N'Hoàng Văn Nam', '090200015', 'nam.hoang@gmail.com', 5000000, N'Vàng');

-- 6.Dữ liệu bảng KHUYENMAI
INSERT INTO KHUYENMAI VALUES
('KM001', N'Giảm giá áo thun', '2025-12-01', '2025-12-10', N'Giảm tiền', 50000),
('KM002', N'Khuyến mãi quần jean', '2025-12-05', '2025-12-20', N'Giảm %', 10),
('KM003', N'Giảm giá váy nữ', '2025-12-10', '2025-12-25', N'Giảm tiền', 70000),
('KM004', N'Mua 1 tặng 1 áo sơ mi', '2025-12-01', '2025-12-15', N'Mua 1 tặng 1', 0),
('KM005', N'Giảm giá áo khoác', '2025-12-08', '2025-12-18', N'Giảm %', 15),
('KM006', N'Khuyến mãi giày thể thao', '2025-12-12', '2025-12-22', N'Giảm tiền', 100000),
('KM007', N'Giảm giá túi xách', '2025-12-02', '2025-12-12', N'Giảm %', 10),
('KM008', N'Khuyến mãi áo len', '2025-12-05', '2025-12-15', N'Giảm tiền', 40000),
('KM009', N'Mua combo váy + áo', '2025-12-06', '2025-12-16', N'Mua combo', 0),
('KM010', N'Giảm giá đồ trẻ em', '2025-12-10', '2025-12-20', N'Giảm tiền', 30000);

-- 7. Dữ liệu bảng PHIEUNHAP
INSERT INTO PHIEUNHAP (MaPN, MaNV, NgayNhap, TongTien) VALUES
('PN001', 'NV001', '2025-09-01', 5850000),
('PN002', 'NV002', '2025-09-03', 6300000),
('PN003', 'NV003', '2025-09-05', 5000000),
('PN004', 'NV004', '2025-09-07', 7200000),
('PN005', 'NV005', '2025-09-10', 5250000),
('PN006', 'NV006', '2025-09-12', 3850000),
('PN007', 'NV007', '2025-09-15', 8900000),
('PN008', 'NV009', '2025-09-18', 4400000);

-- 8.Dữ liệu bảng CT_PHIEUNHAP
INSERT INTO CT_PHIEUNHAP VALUES
('PN001', 'SP001', 20, 250000, 5000000),
('PN002', 'SP005', 15, 420000, 6300000),
('PN003', 'SP007', 10, 500000, 5000000),
('PN004', 'SP011', 12, 600000, 7200000),
('PN005', 'SP008', 8, 480000, 3840000),
('PN006', 'SP010', 7, 550000, 3850000),
('PN007', 'SP004', 10, 360000, 3600000),
('PN008', 'SP002', 15, 270000, 4050000);

-- 9. Dữ liệu bảng HOABANDON
INSERT INTO HOADONBAN VALUES
('HD001','NV001','KH001','KM001','2025-11-01', 500000, N'Tiền mặt'),
('HD002','NV002','KH002','KM002','2025-11-02', 800000, N'Thẻ'),
('HD003','NV004','KH003','KM003','2025-11-03', 600000, N'Tiền mặt'),
('HD004','NV005','KH004','KM004','2025-11-04', 1200000, N'Thẻ'),
('HD005','NV008','KH005','KM005','2025-11-05', 700000, N'Tiền mặt'),
('HD006','NV009','KH006','KM006','2025-11-06', 900000, N'Thẻ'),
('HD007','NV011','KH007','KM007','2025-11-07', 550000, N'Tiền mặt'),
('HD008','NV012','KH008','KM008','2025-11-08', 450000, N'Tiền mặt'),
('HD009','NV013','KH009','KM009','2025-11-09', 650000, N'Thẻ'),
('HD010','NV001','KH010','KM010','2025-11-10', 780000, N'Tiền mặt');

-- 10. Dữ liệu bảng CT_HOABANDON
INSERT INTO CT_HOADONBAN VALUES
('HD001','SP001',2,250000,500000),
('HD002','SP005',1,420000,420000),
('HD003','SP007',1,500000,500000),
('HD004','SP011',2,600000,1200000),
('HD005','SP008',1,480000,480000),
('HD006','SP010',1,550000,550000),
('HD007','SP004',1,360000,360000),
('HD008','SP002',1,270000,270000),
('HD009','SP006',2,325000,650000),  
('HD010','SP003',2,390000,780000);

-- 11. Dữ liệu bảng PHIEUDOITRA
INSERT INTO PHIEUDOITRA (MaPhieu, MaHD, NgayDT, LoaiXuLy, LyDo, MaNV) VALUES
('DT001', 'HD001', '2025-10-01', N'Đổi sản phẩm', N'Size không phù hợp', 'NV001'),
('DT002', 'HD002', '2025-10-05', N'Trả hàng', N'Lỗi sản phẩm', 'NV002'),
('DT003', 'HD003', '2025-10-10', N'Đổi sản phẩm', N'Màu không vừa ý', 'NV001'),
('DT004', 'HD004', '2025-10-12', N'Trả hàng', N'Lỗi đường may', 'NV003'),
('DT005', 'HD010', '2025-10-15', N'Đổi sản phẩm', N'Sản phẩm bị phai màu', 'NV001'), 
('DT006', 'HD005', '2025-10-18', N'Trả hàng', N'Không đúng mô tả', 'NV004'),
('DT007', 'HD006', '2025-10-20', N'Đổi sản phẩm', N'Không vừa size', 'NV001'),
('DT008', 'HD007', '2025-10-22', N'Trả hàng', N'Lỗi chất liệu', 'NV003');

-- 12. Dữ liệu bảng CT_PHIEUDOITRA
INSERT INTO CT_PHIEUDOITRA (MaPhieu, MaSP, SoLuong, GhiChu) VALUES
('DT001', 'SP001', 1, N'Đã đổi size'),
('DT002', 'SP004', 1, N'Hoàn tiền'),
('DT003', 'SP003', 1, N'Đổi sang màu khác'),
('DT004', 'SP006', 1, N'Lỗi kỹ thuật'),
('DT005', 'SP007', 1, N'Đã đổi sản phẩm'),
('DT006', 'SP012', 1, N'Hoàn tiền'),
('DT007', 'SP014', 1, N'Đổi size'),
('DT008', 'SP005', 1, N'Hoàn tiền');

-- 13. Dữ liệu bảng TAIKHOAN
INSERT INTO TAIKHOAN (MaTK, MaNV, TenDangNhap, MatKhau, QuyenHan) VALUES
('TK001','NV001','nguyenvanhung','123456',N'Nhân viên bán hàng'),
('TK002','NV002','tranthilan','123456',N'Nhân viên bán hàng'),
('TK003','NV003','phamvantuan','123456',N'Nhân viên kho'),
('TK004','NV004','ngothimai','123456',N'Nhân viên bán hàng'),
('TK005','NV005','levanlong','123456',N'Nhân viên bán hàng'),
('TK006','NV006','hoangthiphuong','123456',N'Nhân viên kho'),
('TK007','NV007','vuvanquang','123456',N'Nhân viên thu ngân'),
('TK008','NV008','dangthihanh','123456',N'Nhân viên bán hàng'),
('TK009','NV009','phanvanbinh','123456',N'Nhân viên bán hàng'),
('TK010','NV010','buithithu','123456',N'Nhân viên kho'),
('TK011','NV001','admin_hung','admin123',N'Quản lý cửa hàng'),
('TK012','NV004','admin_mai','admin123',N'Quản lý cửa hàng'),
('TK013','NV005','admin_long','admin123',N'Quản lý cửa hàng'),
('TK014','NV007','thungan_quang','123456',N'Nhân viên thu ngân'),
('TK015','NV002','nv_banhang2','123456',N'Nhân viên bán hàng');

-- 14. Dữ liệu bảng NHATKYTONKHO
INSERT INTO NHATKYTOKHO (MaNK, MaSP, NgayGhi, LoaiPhatSinh, SoLuongThayDoi, TonSau, GhiChu) VALUES
('NK001','SP001','2025-11-01',N'Nhập hàng',20,20,N'Nhập kho lô đầu tháng'),
('NK002','SP002','2025-11-02',N'Nhập hàng',15,15,N'Nhập kho lô đầu tháng'),
('NK003','SP003','2025-11-03',N'Nhập hàng',10,10,N'Nhập kho lô đầu tháng'),
('NK004','SP004','2025-11-04',N'Nhập hàng',12,12,N'Nhập kho lô đầu tháng'),
('NK005','SP005','2025-11-05',N'Nhập hàng',8,8,N'Nhập kho lô đầu tháng'),
('NK006','SP006','2025-11-06',N'Nhập hàng',7,7,N'Nhập kho lô đầu tháng'),
('NK007','SP007','2025-11-07',N'Nhập hàng',10,10,N'Nhập kho lô đầu tháng'),
('NK008','SP008','2025-11-08',N'Nhập hàng',15,15,N'Nhập kho lô đầu tháng'),
('NK009','SP009','2025-11-09',N'Nhập hàng',20,20,N'Nhập kho lô đầu tháng'),
('NK010','SP010','2025-11-10',N'Nhập hàng',18,18,N'Nhập kho lô đầu tháng'),
('NK011','SP001','2025-11-11',N'Bán hàng',-2,18,N'Xuất bán hóa đơn HD001'),
('NK012','SP005','2025-11-12',N'Bán hàng',-1,7,N'Xuất bán hóa đơn HD002'),
('NK013','SP007','2025-11-13',N'Bán hàng',-1,9,N'Xuất bán hóa đơn HD003'),
('NK014','SP011','2025-11-14',N'Đổi trả',2,10,N'Khách hàng trả SP011, lô HD004'),
('NK015','SP012','2025-11-15',N'Đổi trả',1,6,N'Khách hàng trả SP012, lô HD005');

-- Tạo các vai trò người dùng trong cơ sở dữ liệu
CREATE ROLE Data_ReadOnly;
CREATE ROLE Data_Writer;

-- Tạo tài khoản và cấp quyền cho Nhân Viên Bán Hàng và Quản Lý Cửa Hàng
-- 1.Tạo Login (ở cấp Server)
-- Chạy từ database [master] hoặc đảm bảo có quyền
USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'NhanVienBanHang')
BEGIN
    CREATE LOGIN NhanVienBanHang 
    WITH PASSWORD = 'BanHang123',  -- Nên đổi mật khẩu thực tế
    DEFAULT_DATABASE = [QLBHUNIQLO];
END

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'QuanLyCuaHang')
BEGIN
    CREATE LOGIN QuanLyCuaHang 
    WITH PASSWORD = 'QuanLy123',  
    DEFAULT_DATABASE = [QLBHUNIQLO];
END
GO

-- 2. Tạo User (ở cấp Database) và liên kết với Login
USE [QLBHUNIQLO];
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'NhanVienBanHang')
BEGIN
    CREATE USER NhanVienBanHang FOR LOGIN NhanVienBanHang;
END

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'QuanLyCuaHang')
BEGIN
    CREATE USER QuanLyCuaHang FOR LOGIN QuanLyCuaHang;
END
GO

/* ================================================================================ 
CẤP QUYỀN CHO NHÂN VIÊN BÁN HÀNG
(Có thể thao tác dữ liệu bán hàng, nhập xuất kho)
================================================================================ */

-- Quyền trên bảng sản phẩm, nhà cung cấp (xem để tra cứu)
GRANT SELECT ON dbo.LOAISANPHAM TO NhanVienBanHang;
GRANT SELECT ON dbo.SANPHAM TO NhanVienBanHang;
GRANT SELECT ON dbo.NHACUNGCAP TO NhanVienBanHang;
GO

-- Quyền trên bảng bán hàng
GRANT SELECT, INSERT, UPDATE ON dbo.HOADONBAN TO NhanVienBanHang;
GRANT SELECT, INSERT, UPDATE ON dbo.CT_HOADONBAN TO NhanVienBanHang;
GO

-- Quyền trên bảng đổi trả
GRANT SELECT, INSERT, UPDATE ON dbo.PHIEUDOITRA TO NhanVienBanHang;
GRANT SELECT, INSERT, UPDATE ON dbo.CT_PHIEUDOITRA TO NhanVienBanHang;
GO

-- Quyền xem bảng khuyến mãi và khách hàng
GRANT SELECT ON dbo.KHUYENMAI TO NhanVienBanHang;
GRANT SELECT ON dbo.KHACHHANG TO NhanVienBanHang;
GO

-- Quyền thao tác nhật ký tồn kho (nếu cần báo kho)
GRANT SELECT, INSERT ON dbo.NHATKYTOKHO TO NhanVienBanHang;
GO

/* ================================================================================ 
CẤP QUYỀN CHO QUẢN LÝ CỬA HÀNG
(Có quyền toàn bộ các bảng để quản lý)
================================================================================ */

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.LOAISANPHAM TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.SANPHAM TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.NHACUNGCAP TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PHIEUNHAP TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CT_PHIEUNHAP TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HOADONBAN TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CT_HOADONBAN TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PHIEUDOITRA TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CT_PHIEUDOITRA TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.KHUYENMAI TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.KHACHHANG TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.NHANVIEN TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.TAIKHOAN TO QuanLyCuaHang;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.NHATKYTOKHO TO QuanLyCuaHang;
GO

-- Thêm người dùng vào nhóm vai trò trong SQL Server
-- Thêm người dùng 'nttlinh' vào nhóm chỉ đọc, giả sử tồn tại người dùng này trong cơ sở dữ liệu
ALTER ROLE Data_ReadOnly ADD MEMBER nttlinh;
-- Thêm người dùng 'nttlinh' vào nhóm ghi dữ liệu, giả sử tồn tại người dùng này trong cơ sở dữ liệu
ALTER ROLE Data_Writer ADD MEMBER nttlinh;

/*
# CLUSTERED INDEX
*/
-- 1. Clustered Index cho bảng SANPHAM trên cột MaSP
CREATE CLUSTERED INDEX IX_SANPHAM_MaSP
ON SANPHAM(MaSP);

/*
# NON-CLUSTERED INDEX
*/
-- 2. Non-Clustered Index cho cột GiaBan trong bảng SANPHAM
CREATE NONCLUSTERED INDEX NCI_SANPHAM_GiaBan
ON SANPHAM(GiaBan);

/*
# NON-CLUSTER UNIQUE INDEX
*/
-- 3. Non Clustered Index và Unique Index cho cột Email trong bảng KHACHHANG
-- Xóa index nếu đã tồn tại
DROP INDEX IF EXISTS idx_KH_Email ON KHACHHANG;
-- Tạo index để đảm bảo email không trùng và truy xuất nhanh
CREATE UNIQUE NONCLUSTERED INDEX idx_KH_Email
ON KHACHHANG(Email);
-- Test truy vấn tìm khách hàng theo email
SELECT * FROM KHACHHANG
WHERE Email = 'hai.vu@gmail.com';

/*
# Filtered index
*/
-- 4. filtered index cho bảng SANPHAM
-- Tạo chỉ mục filtered index trên bảng SANPHAM để tối ưu truy vấn lọc sản phẩm có giá bán > 500000
CREATE NONCLUSTERED INDEX NCI_SANPHAM_HighPrice
ON SANPHAM(GiaBan)
WHERE GiaBan > 500000;
-- Bất kỳ truy vấn nào trên bảng SANPHAM với điều kiện GiaBan > 500000 sẽ sử dụng chỉ mục này
SELECT * FROM SANPHAM
WHERE GiaBan > 500000;  -- truy vấn này sẽ sử dụng NCI_SANPHAM_HighPrice để cải thiện hiệu suất

/*
# COVERING NONCLUSTER INDEX(Phủ index)
*/
-- 5. Covering Index (NCI) trên cột SoLuong và bao phủ thêm cột DonGia trong bảng CT_HOADONBAN
DROP INDEX IF EXISTS NCI_CTHD_SoLuong_Covering_DonGia ON CT_HOADONBAN;
-- Tạo NCI trên cột SoLuong và bao phủ thêm cột DonGia trong bảng CT_HOADONBAN
CREATE NONCLUSTERED INDEX NCI_CTHD_SoLuong_Covering_DonGia
ON CT_HOADONBAN(SoLuong)
INCLUDE (DonGia);
-- Truy vấn SELECT DonGia theo SoLuong sẽ được tối ưu
SELECT DonGia
FROM CT_HOADONBAN
WHERE SoLuong > 1;  -- sử dụng index NCI_CTHD_SoLuong_Covering_DonGia
USE QLBH_UNIQLO;
GO

/*
# View simple
*/
--1. View thể hiện thông tin sản phẩm công khai
CREATE VIEW vw_sanpham_public AS
SELECT 
    sp.MaSP,
    sp.TenSP,
    sp.Size,
    sp.Mau,
    sp.GiaBan,
    lsp.TenLoai,
    ncc.TenNCC
FROM SANPHAM sp
INNER JOIN LOAISANPHAM lsp ON sp.MaLoai = lsp.MaLoai
INNER JOIN NHACUNGCAP ncc ON sp.MaNCC = ncc.MaNCC;
SELECT * FROM vw_sanpham_public;

/*
# View with check option
*/
--2. View with check option: tạo view hiển thị các sản phẩm có giá bán lớn hơn 500.000 đồng
IF OBJECT_ID('v_sanpham_cao_cap') IS NOT NULL
    DROP VIEW v_sanpham_cao_cap;
GO
CREATE VIEW v_sanpham_cao_cap
AS
SELECT
    MaSP,
    TenSP,
    GiaBan,
    Size,
    Mau
FROM
    SANPHAM
WHERE
    GiaBan > 500000
WITH CHECK OPTION;
GO
SELECT * FROM v_sanpham_cao_cap;
UPDATE v_sanpham_cao_cap
SET GiaBan = 350000
WHERE MaSP = 'SP014';
UPDATE v_sanpham_cao_cap
SET GiaBan = 660000
WHERE MaSP = 'SP014';

/*
# View WITH ENCRYPTION
*/
-- View bảo mật thông tin tính toán 
CREATE VIEW dbo.v_secure_price
WITH ENCRYPTION
AS
SELECT
    sp.MaSP,
    sp.TenSP,
    sp.GiaBan * 0.85 AS discounted_price, -- Giảm giá 15%, logic bí mật
    sp.Size,
    sp.Mau
FROM
    SANPHAM sp
WHERE sp.GiaBan > 500000;  -- Chỉ lấy sản phẩm cao cấp
GO
EXEC sp_helptext 'v_secure_price';
SELECT *
FROM dbo.v_secure_price
ORDER BY discounted_price DESC;

/*
# View Complex
*/
-- view tính tổng doanh số bán hàng theo khách hàng
CREATE VIEW dbo.vw_customer_sales_summary
AS
SELECT
    kh.MaKH,
    kh.HoTen,
    COUNT(hd.MaHD) AS total_invoices,        -- Số hóa đơn
    SUM(hd.TongTien) AS total_spent,         -- Tổng tiền đã chi
    AVG(hd.TongTien) AS average_invoice      -- Trung bình tiền 1 hóa đơn
FROM
    KHACHHANG kh
JOIN
    HOADONBAN hd ON kh.MaKH = hd.MaKH
GROUP BY
    kh.MaKH, kh.HoTen;
GO
SELECT *
FROM vw_customer_sales_summary
ORDER BY total_spent DESC;
-- View: Thống kê nhập xuất tồn kho cho sản phẩm
CREATE VIEW dbo.vw_inventory_summary
AS
SELECT
    sp.MaSP,
    sp.TenSP,
    SUM(pn.SoLuong) AS total_imported,        -- Tổng số lượng nhập
    SUM(hd.SoLuong) AS total_sold,            -- Tổng số lượng bán
    MAX(nk.TonSau) AS current_stock           -- Tồn kho hiện tại từ nhật ký
FROM
    SANPHAM sp
LEFT JOIN
    CT_PHIEUNHAP pn ON sp.MaSP = pn.MaSP
LEFT JOIN
    CT_HOADONBAN hd ON sp.MaSP = hd.MaSP
LEFT JOIN
    NHATKYTOKHO nk ON sp.MaSP = nk.MaSP
GROUP BY
    sp.MaSP, sp.TenSP;
GO
SELECT *
FROM vw_inventory_summary
ORDER BY current_stock DESC;

/*
# THỦ TỤC (PROCEDURE)
## 1. Ứng dụng thủ tục hiển thị thông tin 
*/
-- thủ tục hiển thị thông tin sản phẩm theo mã sản phẩm
CREATE OR ALTER PROC usp_GetSanPhamById
    @p_MaSP CHAR(10),
    @p_MaLoai CHAR(10) OUTPUT,
    @p_MaNCC CHAR(10) OUTPUT,
    @p_TenSP NVARCHAR(100) OUTPUT,
    @p_Size NVARCHAR(10) OUTPUT,
    @p_Mau NVARCHAR(20) OUTPUT,
    @p_GiaBan DECIMAL(18,2) OUTPUT
AS
BEGIN
    SELECT
        @p_MaLoai = MaLoai,
        @p_MaNCC = MaNCC,
        @p_TenSP = TenSP,
        @p_Size = Size,
        @p_Mau = Mau,
        @p_GiaBan = GiaBan
    FROM SANPHAM
    WHERE MaSP = @p_MaSP;
END;
GO
-- Kiểm tra thủ tục với mã sản phẩm hợp lệ
DECLARE 
    @v_MaLoai CHAR(10),
    @v_MaNCC CHAR(10),
    @v_TenSP NVARCHAR(100),
    @v_Size NVARCHAR(10),
    @v_Mau NVARCHAR(20),
    @v_GiaBan DECIMAL(18,2);
EXEC usp_GetSanPhamById
    @p_MaSP = 'SP001',
    @p_MaLoai = @v_MaLoai OUTPUT,
    @p_MaNCC = @v_MaNCC OUTPUT,
    @p_TenSP = @v_TenSP OUTPUT,
    @p_Size = @v_Size OUTPUT,
    @p_Mau = @v_Mau OUTPUT,
    @p_GiaBan = @v_GiaBan OUTPUT;
PRINT N'Mã loại: ' + ISNULL(@v_MaLoai, N'Không tìm thấy');
PRINT N'Mã NCC: ' + ISNULL(@v_MaNCC, N'Không tìm thấy');
PRINT N'Tên sản phẩm: ' + ISNULL(@v_TenSP, N'Không tìm thấy');
PRINT N'Size: ' + ISNULL(@v_Size, N'Không xác định');
PRINT N'Màu: ' + ISNULL(@v_Mau, N'Không xác định');
PRINT N'Giá bán: ' + ISNULL(CAST(@v_GiaBan AS NVARCHAR(20)), N'Không xác định');
-- Kiểm tra thủ tục với mã không tồn tại
DECLARE 
    @v_MaLoai CHAR(10),
    @v_MaNCC CHAR(10),
    @v_TenSP NVARCHAR(100),
    @v_Size NVARCHAR(10),
    @v_Mau NVARCHAR(20),
    @v_GiaBan DECIMAL(18,2);
EXEC usp_GetSanPhamById
    @p_MaSP = 'SP020',
    @p_MaLoai = @v_MaLoai OUTPUT,
    @p_MaNCC = @v_MaNCC OUTPUT,
    @p_TenSP = @v_TenSP OUTPUT,
    @p_Size = @v_Size OUTPUT,
    @p_Mau = @v_Mau OUTPUT,
    @p_GiaBan = @v_GiaBan OUTPUT;
PRINT N'Mã loại: ' + ISNULL(@v_MaLoai, N'Không tìm thấy');
PRINT N'Mã NCC: ' + ISNULL(@v_MaNCC, N'Không tìm thấy');
PRINT N'Tên sản phẩm: ' + ISNULL(@v_TenSP, N'Không tìm thấy');
PRINT N'Size: ' + ISNULL(@v_Size, N'Không xác định');
PRINT N'Màu: ' + ISNULL(@v_Mau, N'Không xác định');
PRINT N'Giá bán: ' + ISNULL(CAST(@v_GiaBan AS NVARCHAR(20)), N'Không xác định');

/*
## 2. Ứng dụng thủ tục để chèn, thêm, xóa, dữ liệu 
*/
-- Thủ tục: Thêm sản phẩm mới cùng các liên kết Loại sản phẩm và Nhà cung cấp
CREATE OR ALTER PROC dbo.usp_AddNewSanPham
    @p_MaSP CHAR(10),
    @p_TenSP NVARCHAR(100),
    @p_Size NVARCHAR(10) = NULL,
    @p_Mau NVARCHAR(20) = NULL,
    @p_GiaBan DECIMAL(18,2) = NULL,
    @p_MaLoai CHAR(10) = NULL,   -- loại sản phẩm
    @p_MaNCC CHAR(10) = NULL     -- nhà cung cấp
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        -- Thêm sản phẩm vào SANPHAM
        INSERT INTO SANPHAM (MaSP, MaLoai, MaNCC, TenSP, Size, Mau, GiaBan)
        VALUES (@p_MaSP, @p_MaLoai, @p_MaNCC, @p_TenSP, @p_Size, @p_Mau, @p_GiaBan);
        COMMIT;
        PRINT N'Đã thêm sản phẩm mới thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT N'Đã xảy ra lỗi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
-- Thêm sản phẩm hợp lệ vào bảng SanPham
EXEC dbo.usp_AddNewSanPham
    @p_MaSP = 'SP020',
    @p_TenSP = N'Áo Thun Test',
    @p_Size = N'M',
    @p_Mau = N'Đỏ',
    @p_GiaBan = 199000,
    @p_MaLoai = 'L001',
    @p_MaNCC = 'N001';
GO
Select * FROM SANPHAM;
-- Thêm sản phẩm không hợp lệ vào bảng SanPham 
EXEC dbo.usp_AddNewSanPham
    @p_MaSP = 'SP010',
    @p_TenSP = N'Áo Thun Test',
    @p_Size = N'M',
    @p_Mau = N'Đỏ',
    @p_GiaBan = 199000,
    @p_MaLoai = 'L001',
    @p_MaNCC = 'N001';
GO
-- Thủ tục: Xóa sản phẩm và các bản ghi liên quan
CREATE OR ALTER PROC dbo.usp_DeleteSanPham
    @p_MaSP CHAR(10)
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra sản phẩm có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM SANPHAM WHERE MaSP = @p_MaSP)
        BEGIN
            PRINT N'Không tìm thấy sản phẩm với Mã SP = ' + @p_MaSP;
            RETURN; -- Dừng thủ tục
        END
        BEGIN TRANSACTION;
        -- Xóa các bảng chi tiết liên quan
        DELETE FROM CT_PHIEUDOITRA WHERE MaSP = @p_MaSP;
        DELETE FROM CT_HOADONBAN WHERE MaSP = @p_MaSP;
        DELETE FROM CT_PHIEUNHAP WHERE MaSP = @p_MaSP;
        DELETE FROM NHATKYTOKHO WHERE MaSP = @p_MaSP;
        -- Xóa sản phẩm
        DELETE FROM SANPHAM WHERE MaSP = @p_MaSP;
        COMMIT;
        PRINT N'Đã xóa sản phẩm và các dữ liệu liên quan thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT N'Đã xảy ra lỗi khi xóa: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
-- kiểm tra thủ tục
EXEC dbo.usp_DeleteSanPham @p_MaSP = 'SP020';
GO
SELECT * FROM SANPHAM;
GO
-- Thủ tục xóa sản phẩm không hợp lệ
EXEC dbo.usp_DeleteSanPham @p_MaSP = 'SP030';
GO

/*
## 3. Ứng dụng thủ tục thống kê 
*/
-- Thủ tục: Thống kê doanh thu của khách hàng 
CREATE OR ALTER PROC dbo.usp_ThongKeDoanhThuKhachHang
    @p_start_date DATE = NULL,
    @p_end_date DATE = NULL
AS
BEGIN
    SELECT 
        kh.MaKH,
        kh.HoTen AS TenKH,
        COUNT(DISTINCT hd.MaHD) AS SoHoaDon,
        ISNULL(SUM(ct.SoLuong),0) AS TongSoLuongMua,   -- tránh NULL
        ISNULL(SUM(ct.ThanhTien),0) AS TongChiTieu      -- tránh NULL
    FROM KHACHHANG kh
    LEFT JOIN HOADONBAN hd ON kh.MaKH = hd.MaKH
    LEFT JOIN CT_HOADONBAN ct ON hd.MaHD = ct.MaHD
    WHERE 1=1
        AND (@p_start_date IS NULL OR hd.NgayBan >= @p_start_date)
        AND (@p_end_date IS NULL OR hd.NgayBan <= @p_end_date)
    GROUP BY kh.MaKH, kh.HoTen
    ORDER BY TongChiTieu DESC;
END;
GO
-- kiểm tra thủ tục
EXEC dbo.usp_ThongKeDoanhThuKhachHang;
-- thống kê theo thời gian cụ thể trong năm 2025
EXEC dbo.usp_ThongKeDoanhThuKhachHang
    @p_start_date = '2025-01-01',
    @p_end_date = '2025-12-31';

/*
## 4. Ứng dụng thủ tục để tìm kiếm 
*/
-- Thủ tục: Tìm kiếm nhân viên theo nhiều tiêu chí
CREATE OR ALTER PROC dbo.usp_TimKiemNhanVien
    @p_MaNV   CHAR(10) = NULL,
    @p_HoTen  NVARCHAR(100) = NULL,
    @p_ChucVu NVARCHAR(50) = NULL,
    @p_SDT    NVARCHAR(15) = NULL,
    @p_Email  NVARCHAR(100) = NULL
AS
BEGIN
    SELECT 
        MaNV,
        HoTen,
        ChucVu,
        SDT,
        Email
    FROM NHANVIEN
    WHERE 1 = 1
        AND (@p_MaNV IS NULL OR MaNV = @p_MaNV)
        AND (@p_HoTen IS NULL OR HoTen LIKE '%' + @p_HoTen + '%')
        AND (@p_ChucVu IS NULL OR ChucVu LIKE '%' + @p_ChucVu + '%')
        AND (@p_SDT IS NULL OR SDT = @p_SDT)
        AND (@p_Email IS NULL OR Email LIKE '%' + @p_Email + '%')
    ORDER BY HoTen;
END;
GO
-- Tìm tất cả nhân viên có chức vụ "Nhân viên bán hàng"
EXEC dbo.usp_TimKiemNhanVien
    @p_ChucVu = N'Nhân viên bán hàng';
-- Tìm nhân viên có tên chứa "Hoài"
EXEC dbo.usp_TimKiemNhanVien
    @p_HoTen = N'Hoài';

/*
## 5. Ứng dụng thủ tục để cập nhật dữ liệu
*/
-- Thủ tục: Cập nhật thông tin sản phẩm
CREATE OR ALTER PROC dbo.usp_UpdateSanPham
    @p_MaSP CHAR(10),
    @p_TenSP NVARCHAR(100) = NULL,
    @p_Size NVARCHAR(10) = NULL,
    @p_Mau NVARCHAR(20) = NULL,
    @p_GiaBan DECIMAL(20,2) = NULL,
    @p_MaLoai CHAR(10) = NULL,
    @p_MaNCC CHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE SANPHAM
        SET
            TenSP = ISNULL(@p_TenSP, TenSP),
            Size = ISNULL(@p_Size, Size),
            Mau = ISNULL(@p_Mau, Mau),
            GiaBan = ISNULL(@p_GiaBan, GiaBan),
            MaLoai = ISNULL(@p_MaLoai, MaLoai),
            MaNCC = ISNULL(@p_MaNCC, MaNCC)
        WHERE MaSP = @p_MaSP;
        PRINT N'Đã cập nhật sản phẩm thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Đã xảy ra lỗi khi cập nhật: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
EXEC dbo.usp_UpdateSanPham
    @p_MaSP = 'SP015',
    @p_GiaBan = 500000,
    @p_Mau = N'Đỏ';
SELECT * FROM SANPHAM WHERE MaSP = 'SP015';

/*
# I. TRIGGER DML
## 1\. TRIGGER AFTER
### ỨNG dụng TRIGGER AFTER dùng để ghi log(lịch sử dữ liệu)
*/

-- Tạo bảng log để ghi lại các thay đổi trên các bảng khác
drop table if exists table_log;
--Tạo bảng để ghi log, làm 1 lần duy nhất
create table table_log(
    log_id INT IDENTITY(1,1) CONSTRAINT pk_table_log PRIMARY KEY,
    table_name NVARCHAR(100) NOT NULL, -- Tên bảng bị thay đổi
    type_change NVARCHAR(50) NOT NULL, -- Loại thay đổi: INSERT, UPDATE, DELETE
    record_id char(15), -- ID của bản ghi bị thay đổi
    column_name NVARCHAR(100), -- Tên cột bị thay đổi(chỉ dùng cho UPDATE)
    old_value NVARCHAR(MAX), -- Giá trị cũ (chỉ dùng cho UPDATE, DELETE)
    new_value NVARCHAR(MAX), -- Giá trị mới (chỉ dùng cho INSERT, UPDATE)
    changed_by NVARCHAR(100) DEFAULT SUSER_SNAME(), -- Người thực hiện thay đổi
    changed_date DATETIME DEFAULT GETDATE() -- Thời gian thay đổi
)

/*
# Viết trigger after tự động kích hoạt khi gặp các sự kiện INSERT bảng SANPHAM
*/
DROP TRIGGER IF EXISTS trg_SANPHAM_Insert_Log;
-- Trigger: Ghi log khi thêm sản phẩm mới
CREATE OR ALTER TRIGGER trg_SANPHAM_Insert_Log
ON SANPHAM
AFTER INSERT
AS
BEGIN
    INSERT INTO table_log (
        table_name,
        type_change,
        record_id,
        column_name,
        old_value,
        new_value
    )
    SELECT 
        N'SANPHAM',
        N'INSERT',
        TRY_CAST(i.MaSP AS INT),        -- Nếu MaSP CHAR thì có thể để NVARCHAR luôn
        NULL,
        NULL,
        N'Tên: ' + i.TenSP
        + N', Size: ' + ISNULL(i.Size, N'NULL')
        + N', Màu: ' + ISNULL(i.Mau, N'NULL')
        + N', Giá: ' + CAST(i.GiaBan AS NVARCHAR(50))
    FROM inserted i;
END;
GO
-- thêm sản phẩm mới vào bảng SANPHAM
INSERT INTO SANPHAM (MaSP, MaLoai, MaNCC, TenSP, Size, Mau, GiaBan)
VALUES
('SP101', 'L001', 'N002', N'Áo UNIQLO U Cotton', 'M', N'Đen', 399000);
-- xem log du lieu tu bang table_log
SELECT * FROM table_log;

/*
# Viết trigger after tự động kích hoạt khi gặp các sự kiện DELETE bảng SANPHAM
*/
DROP TRIGGER IF EXISTS trg_SANPHAM_delete_Log;
-- trigger ghi log khi xóa bản ghi trong bảng SANPHAM
CREATE OR ALTER TRIGGER trigg_sanpham_log_delete
ON SANPHAM
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO table_log (
        table_name,
        type_change,
        record_id,
        column_name,
        old_value,
        new_value,
        changed_by,
        changed_date
    )
    SELECT
        N'SANPHAM' AS table_name,       
        N'DELETE' AS type_change,       
        d.MaSP AS record_id,            
        NULL AS column_name,            
        CONCAT(
            N'TenSP: ', d.TenSP,
            N', Size: ', d.Size,
            N', Mau: ', d.Mau,
            N', GiaBan: ', d.GiaBan,
            N', MaLoai: ', d.MaLoai,
            N', MaNCC: ', d.MaNCC
        ) AS old_value,                 
        NULL AS new_value,             
        SUSER_SNAME(),                 
        GETDATE()                      
    FROM deleted d;
END;
GO
DELETE FROM SANPHAM WHERE MaSP = 'SP100';
SELECT * FROM SANPHAM;

/*
## Viết trigger after tự động kích hoạt khi gặp các sự kiện **`UPDATE`** bảng SANPHAM
*/
-- Trigger: Ghi log các cập nhật trên bảng SANPHAM
CREATE OR ALTER TRIGGER trigg_sanpham_update_log
ON SANPHAM
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(MaLoai)
    BEGIN
        INSERT INTO table_log (table_name, type_change, record_id, column_name, old_value, new_value)
        SELECT 
            N'SANPHAM',
            N'UPDATE',
            i.MaSP,
            N'MaLoai',
            d.MaLoai,
            i.MaLoai
        FROM inserted i
        JOIN deleted d ON i.MaSP = d.MaSP
        WHERE ISNULL(i.MaLoai, '') <> ISNULL(d.MaLoai, '');
    END;
    IF UPDATE(MaNCC)
    BEGIN
        INSERT INTO table_log (table_name, type_change, record_id, column_name, old_value, new_value)
        SELECT 
            N'SANPHAM',
            N'UPDATE',
            i.MaSP,
            N'MaNCC',
            d.MaNCC,
            i.MaNCC
        FROM inserted i
        JOIN deleted d ON i.MaSP = d.MaSP
        WHERE ISNULL(i.MaNCC, '') <> ISNULL(d.MaNCC, '');
    END;
    IF UPDATE(TenSP)
    BEGIN
        INSERT INTO table_log (table_name, type_change, record_id, column_name, old_value, new_value)
        SELECT 
            N'SANPHAM',
            N'UPDATE',
            i.MaSP,
            N'TenSP',
            d.TenSP,
            i.TenSP
        FROM inserted i
        JOIN deleted d ON i.MaSP = d.MaSP
        WHERE ISNULL(i.TenSP, '') <> ISNULL(d.TenSP, '');
    END;
    IF UPDATE(Size)
    BEGIN
        INSERT INTO table_log (table_name, type_change, record_id, column_name, old_value, new_value)
        SELECT 
            N'SANPHAM',
            N'UPDATE',
            i.MaSP,
            N'Size',
            d.Size,
            i.Size
        FROM inserted i
        JOIN deleted d ON i.MaSP = d.MaSP
        WHERE ISNULL(i.Size, '') <> ISNULL(d.Size, '');
    END;
    IF UPDATE(Mau)
    BEGIN
        INSERT INTO table_log (table_name, type_change, record_id, column_name, old_value, new_value)
        SELECT 
            N'SANPHAM',
            N'UPDATE',
            i.MaSP,
            N'Mau',
            d.Mau,
            i.Mau
        FROM inserted i
        JOIN deleted d ON i.MaSP = d.MaSP
        WHERE ISNULL(i.Mau, '') <> ISNULL(d.Mau, '');
    END;
    IF UPDATE(GiaBan)
    BEGIN
        INSERT INTO table_log (table_name, type_change, record_id, column_name, old_value, new_value)
        SELECT 
            N'SANPHAM',
            N'UPDATE',
            i.MaSP,
            N'GiaBan',
            CAST(d.GiaBan AS NVARCHAR(50)),
            CAST(i.GiaBan AS NVARCHAR(50))
        FROM inserted i
        JOIN deleted d ON i.MaSP = d.MaSP
        WHERE ISNULL(i.GiaBan, 0) <> ISNULL(d.GiaBan, 0);
    END;
END;
GO
UPDATE SANPHAM
SET GiaBan = GiaBan + 50000
WHERE MaSP = 'SP016';
SELECT * FROM table_log where log_id= 4

/*
## Ứng dụng trigger after để **`kiểm tra logic nghiệp vụ`** để đảm bảo tính toàn vẹn dữ liệu
Kiểm tra HinhThuc trong bảng KHUYENMAI. Logic nghiệp vụ: Khi thêm chương trình khuyến mãi, HinhThuc chỉ được phép: 'Phần trăm' hoặc 'Giảm tiền'
*/
-- Kiểm tra giá trị của cột HinhThuc trong bảng KHUYENMAI, chỉ cho phép hai giá trị: "Phần trăm" và "Giảm tiền".
CREATE OR ALTER TRIGGER trigg_khuyenmai_check_hinhthuc
ON KHUYENMAI
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE LOWER(HinhThuc) NOT IN (N'phần trăm', N'giảm tiền')
    )
    BEGIN
        ;THROW 50002, N'Hình thức khuyến mãi không hợp lệ! Chỉ được "Phần trăm" hoặc "Giảm tiền".', 1;
        ROLLBACK;
    END
END;
GO
INSERT INTO KHUYENMAI(MaKM, TenCTKM, NgayBD, NgayKT, HinhThuc, GiaTriGiam)
VALUES ('KM011', N'Mùa đông siêu sale', '2025-12-01', '2025-12-31', N'ưu đãi', 15);
INSERT INTO KHUYENMAI(MaKM, TenCTKM, NgayBD, NgayKT, HinhThuc, GiaTriGiam)
VALUES ('KM011', N'Mùa đông siêu sale', '2025-12-01', '2025-12-31', N'Giảm tiền', 15);
-- trigger cập nhật hạng thành viên khách hàng sau khi có hóa đơn bán hàng mới
CREATE OR ALTER TRIGGER trg_UpdateCustomerRank
ON HOADONBAN
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Cập nhật tổng chi tiêu cho khách hàng
    UPDATE KHACHHANG
    SET TongChiTieu = KH.TongChiTieu + I.TongTien
    FROM KHACHHANG KH
    INNER JOIN inserted I ON KH.MaKH = I.MaKH;
    -- Tự động cập nhật hạng thành viên
    UPDATE KHACHHANG
    SET HangThanhVien =
        CASE 
            WHEN TongChiTieu < 5000000 THEN N'Đồng'
            WHEN TongChiTieu < 20000000 THEN N'Bạc'
            ELSE N'Vàng'
        END
    WHERE MaKH IN (SELECT MaKH FROM inserted);
END;
GO
INSERT INTO KHACHHANG (MaKH, HoTen, SDT, Email, TongChiTieu, HangThanhVien)
VALUES ('KH100', N'Nguyễn Văn Test', '0900000000', 'test@gmail.com', 0, N'Đồng');
INSERT INTO HOADONBAN (MaHD, MaNV, MaKH, MaKM, NgayBan, TongTien, HinhThucTT)
VALUES ('HDTEST1', 'NV001', 'KH100', NULL, '2025-12-01', 3000000, N'Tiền mặt');
SELECT MaKH, TongChiTieu, HangThanhVien
FROM KHACHHANG
WHERE MaKH = 'KH100';
INSERT INTO HOADONBAN (MaHD, MaNV, MaKH, MaKM, NgayBan, TongTien, HinhThucTT)
VALUES ('HDTEST2', 'NV001', 'KH100', NULL, '2025-12-02', 4000000, N'Tiền mặt');
SELECT MaKH, TongChiTieu, HangThanhVien
FROM KHACHHANG
WHERE MaKH = 'KH100';
INSERT INTO HOADONBAN (MaHD, MaNV, MaKH, MaKM, NgayBan, TongTien, HinhThucTT)
VALUES ('HDTEST3', 'NV001', 'KH100', NULL, '2025-12-03', 15000000, N'Tiền mặt');
SELECT MaKH, TongChiTieu, HangThanhVien
FROM KHACHHANG
WHERE MaKH = 'KH100';

/*
## 2. TRIGGER INSTEAD OF
### a. Ứng dụng trigger instead of để ngăn chặn hành vi DML `trực tiếp` trái phép
*/
-- Tạo bảng ghi log cho các hành vi DML trái phép
drop table if exists dml_log_illegal;
create table dml_log_illegal (
    log_id INT IDENTITY(1,1) CONSTRAINT pk_dml_log_illegal PRIMARY KEY,
    table_name NVARCHAR(256) NOT NULL, -- Tên bảng bị thao tác trái phép
    record_id NVARCHAR(10) NOT NULL, -- ID của bản ghi bị thao tác trái phép
    record_data NVARCHAR(MAX) NOT NULL, -- Dữ liệu của bản ghi bị thao tác trái phép, Nếu không có B3 thì bỏ qua bước này
    changed_by NVARCHAR(256) DEFAULT SUSER_SNAME(), -- Người thực hiện thao tác trái phép
    changed_date DATETIME DEFAULT GETDATE(), -- Thời gian thực hiện thao tác
    reason NVARCHAR(512) NULL, -- Lý do bị coi là trái phép
    restored_date DATETIME NULL, -- Thời gian khôi phục bản ghi nếu có, Nếu không có B3 thì bỏ qua bước này
    restored_by NVARCHAR(256) NULL -- Người khôi phục bản ghi nếu có, Nếu không có B3 thì bỏ qua bước này
);

/*
# Tạo một trigger instead of delete trên bảng KHACHHANG nhằm ngăn chặn hành vi xóa trái phép
*/
DROP TRIGGER IF EXISTS tr_khachhang_delete;
-- trigger tạo log khi xóa khách hàng nếu có dữ liệu liên quan
CREATE OR ALTER TRIGGER tr_khachhang_delete
ON KHACHHANG
INSTEAD OF DELETE
AS
BEGIN
    DECLARE 
        @MaKH NVARCHAR(10),
        @HoTen NVARCHAR(200),
        @SDT NVARCHAR(20),
        @Email NVARCHAR(100),
        @Hang NVARCHAR(50),
        @LyDo NVARCHAR(MAX),
        @LienQuan BIT;
    -- LẤY DỮ LIỆU BỊ XÓA
    SELECT 
        @MaKH = d.MaKH,
        @HoTen = d.HoTen,
        @SDT = d.SDT,
        @Email = d.Email,
        @Hang = d.HangThanhVien
    FROM deleted d;
    -- KIỂM TRA LIÊN QUAN
    IF EXISTS (
            SELECT 1 FROM HOADONBAN WHERE MaKH = @MaKH
        )
        OR EXISTS (
            SELECT 1 FROM PHIEUDOITRA 
            WHERE MaHD IN (SELECT MaHD FROM HOADONBAN WHERE MaKH = @MaKH)
        )
    BEGIN
        SET @LienQuan = 1;
        SET @LyDo = N'Không thể xóa khách hàng vì có dữ liệu hóa đơn / đổi trả liên quan.';
    END
    ELSE
    BEGIN
        SET @LienQuan = 0;
        SET @LyDo = N'Xóa khách hàng thành công.';
    END;
    -- GHI LOG ĐÚNG TÊN CỘT
    INSERT INTO dml_log_illegal
    (
        table_name,
        record_id,
        record_data,
        changed_by,
        changed_date,
        reason
    )
    VALUES
    (
        N'KHACHHANG',
        @MaKH,
        @HoTen + N' | '
            + COALESCE(@SDT,'') + N' | '
            + COALESCE(@Email,'') + N' | '
            + N'Hạng: ' + COALESCE(@Hang,''),
        SUSER_SNAME(),
        GETDATE(),
        @LyDo
    );
    -- XÓA NẾU KHÔNG LIÊN QUAN
    IF @LienQuan = 0
    BEGIN
        DELETE FROM KHACHHANG WHERE MaKH = @MaKH;
        PRINT N'Khách hàng đã được xóa thành công.';
    END
    ELSE
    BEGIN
        PRINT N'Không thể xóa khách hàng vì có dữ liệu liên quan.';
    END
END;
GO
-- Thêm khách hàng mới không có hóa đơn
INSERT INTO KHACHHANG (MaKH, HoTen, SDT, Email, HangThanhVien)
VALUES ('KH999', N'Test Xóa', '0123456789', 'test@gmail.com', N'Dồng');
-- Thử xóa
DELETE FROM KHACHHANG WHERE MaKH = 'KH999';
-- Xem log ghi lại
SELECT TOP 1 * FROM dml_log_illegal ORDER BY changed_date DESC;
-- Giả sử KH001 có hóa đơn liên quan
DELETE FROM KHACHHANG WHERE MaKH = 'KH001';
-- Kiểm tra xem khách hàng vẫn còn
SELECT * FROM KHACHHANG WHERE MaKH = 'KH001';
-- Kiểm tra log
SELECT TOP 1 * FROM dml_log_illegal ORDER BY changed_date DESC;
drop PROC IF EXISTS usp_RestoreKhachHang;
-- procedure hôi phục khách hàng đã xóa từ bảng KHACHHANG
CREATE OR ALTER PROC usp_RestoreKhachHang
(
    @p_MaKH NVARCHAR(10),
    @p_restore_reason NVARCHAR(MAX) = NULL
)
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM dml_log_illegal
        WHERE table_name = 'KHACHHANG'
          AND record_id = @p_MaKH
          AND restored_date IS NULL
    )
    BEGIN
        PRINT N'Không tìm thấy khách hàng hoặc đã được khôi phục.';
        RETURN;
    END
    DECLARE @data NVARCHAR(MAX);
    SELECT @data = record_data
    FROM dml_log_illegal
    WHERE table_name = 'KHACHHANG'
      AND record_id = @p_MaKH
      AND restored_date IS NULL;
    DECLARE @HoTen NVARCHAR(200),
            @SDT NVARCHAR(20),
            @Email NVARCHAR(100),
            @Hang NVARCHAR(50);
    ;WITH SPLIT AS (
        SELECT 
            value,
            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
        FROM STRING_SPLIT(@data,'|')
    )
    SELECT
        @HoTen = LTRIM(RTRIM((SELECT value FROM SPLIT WHERE rn = 1))),
        @SDT   = LTRIM(RTRIM((SELECT value FROM SPLIT WHERE rn = 2))),
        @Email = LTRIM(RTRIM((SELECT value FROM SPLIT WHERE rn = 3))),
        @Hang  = LTRIM(RTRIM(REPLACE((SELECT value FROM SPLIT WHERE rn = 4), 'Hạng:', '')));
    INSERT INTO KHACHHANG (MaKH, HoTen, SDT, Email, HangThanhVien)
    VALUES (@p_MaKH, @HoTen, @SDT, @Email, @Hang);
    UPDATE DML_LOG_ILLEGAL
    SET restored_date = GETDATE(),
        restored_by = SUSER_SNAME(),
        reason = @p_restore_reason
    WHERE table_name = 'KHACHHANG'
      AND record_id = @p_MaKH
      AND restored_date IS NULL;
    PRINT N'Khôi phục khách hàng thành công.';
END
GO
EXEC usp_RestoreKhachHang
    @p_MaKH = KH015,
    @p_restore_reason = N'Khôi phục do quản lý yêu cầu.';

/*
### b. Ứng dụng trigger instead of sử dụng trên view phức tạp(complex view)
## Viết 1 trigger instead of insert  trên **`view vw_sanpham_loaisp`**
*/
-- tạo bản xem vw_sanpham_loaisp kết hợp thông tin từ bảng SANPHAM và LOAISANPHAM
CREATE OR ALTER VIEW vw_sanpham_loaisp
AS
SELECT 
    sp.MaSP,
    sp.TenSP,
    sp.Size,
    sp.Mau,
    sp.GiaBan,
    sp.MaLoai,
    sp.MaNCC,
    lsp.TenLoai AS TenLoai,
    lsp.MoTa AS MoTaLoai
FROM SANPHAM sp
INNER JOIN LOAISANPHAM lsp
    ON sp.MaLoai = lsp.MaLoai;
GO
CREATE OR ALTER TRIGGER trigg_vw_sanpham_loaisp_insert
ON vw_sanpham_loaisp
INSTEAD OF INSERT
AS
BEGIN
    DECLARE
        @MaSP CHAR(15),
        @TenSP NVARCHAR(50),
        @Size NVARCHAR(20),
        @Mau NVARCHAR(20),
        @GiaBan DECIMAL(18,2),
        @MaLoai CHAR(15),
        @MaNCC CHAR(15),
        @TenLoai NVARCHAR(50),
        @MoTaLoai NVARCHAR(200);
    -- Lấy dữ liệu từ inserted
    SELECT 
        @MaSP = MaSP,
        @TenSP = TenSP,
        @Size = Size,
        @Mau = Mau,
        @GiaBan = GiaBan,
        @MaLoai = MaLoai,
        @MaNCC = MaNCC,
        @TenLoai = TenLoai,
        @MoTaLoai = MoTaLoai
    FROM inserted;
    -- Thêm loại sản phẩm nếu chưa tồn tại
    IF NOT EXISTS (SELECT 1 FROM LOAISANPHAM WHERE MaLoai = @MaLoai)
    BEGIN
        INSERT INTO LOAISANPHAM (MaLoai, TenLoai, MoTa)
        VALUES (@MaLoai, @TenLoai, @MoTaLoai);
        PRINT N'Loại sản phẩm ' + @MaLoai + N' đã được thêm.';
    END
    ELSE
    BEGIN
        PRINT N'Loại sản phẩm ' + @MaLoai + N' đã tồn tại, không thêm.';
    END
    -- Thêm sản phẩm nếu chưa tồn tại
    IF NOT EXISTS (SELECT 1 FROM SANPHAM WHERE MaSP = @MaSP)
    BEGIN
        INSERT INTO SANPHAM (MaSP, MaLoai, MaNCC, TenSP, Size, Mau, GiaBan)
        VALUES (@MaSP, @MaLoai, @MaNCC, @TenSP, @Size, @Mau, @GiaBan);
        PRINT N'Sản phẩm ' + @MaSP + N' đã được thêm.';
    END
    ELSE
    BEGIN
        PRINT N'Sản phẩm ' + @MaSP + N' đã tồn tại, không thêm.';
    END
END;
GO
INSERT INTO vw_sanpham_loaisp
(MaSP, TenSP, Size, Mau, GiaBan, MaLoai, MaNCC, TenLoai, MoTaLoai)
VALUES
('SP100', N'Áo Thun Trơn', 'L', N'Trắng', 199000, 'L001', 'N005', N'Áo Thun', N'Các loại áo thun');
INSERT INTO vw_sanpham_loaisp
(MaSP, TenSP, Size, Mau, GiaBan, MaLoai, MaNCC, TenLoai, MoTaLoai)
VALUES
('SP001', N'Áo Thun nam', 'M', N'Đỏ', 199000, 'L001', 'N001', N'Áo', N'Áo thời trang cơ bản');

-- ứng dụng trigger để kiểm tra tồn kho trước khi bán hàng
CREATE OR ALTER TRIGGER trg_CheckStockBeforeSell
ON CT_HOADONBAN
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra từng dòng được insert vào CT_HOADONBAN
    IF EXISTS (
        SELECT 1
        FROM inserted I
        CROSS APPLY (
            SELECT TOP 1 TonSau 
            FROM NHATKYTOKHO 
            WHERE MaSP = I.MaSP
            ORDER BY NgayGhi DESC
        ) AS T
        WHERE T.TonSau < I.SoLuong
    )
    BEGIN
        RAISERROR (N'Tồn kho không đủ để bán. Vui lòng kiểm tra lại!', 16, 1);
        ROLLBACK TRAN;
        RETURN;
    END;
    -- Nếu tồn kho hợp lệ → cho phép insert thật vào bảng gốc
    INSERT INTO CT_HOADONBAN (MaHD, MaSP, SoLuong, DonGia, ThanhTien)
    SELECT MaHD, MaSP, SoLuong, DonGia, ThanhTien
    FROM inserted;
END;
GO
INSERT INTO NHATKYTOKHO (MaNK, MaSP, NgayGhi, LoaiPhatSinh, SoLuongThayDoi, TonSau, GhiChu)
VALUES ('NKTEST1', 'SP001', GETDATE(), N'Nhập hàng', 10, 10, N'Tồn kho test');
DELETE FROM CT_HOADONBAN WHERE MaHD = 'HDTEST1';
DELETE FROM HOADONBAN WHERE MaHD = 'HDTEST1';
INSERT INTO HOADONBAN (MaHD, MaNV, MaKH, MaKM, NgayBan, TongTien, HinhThucTT)
VALUES ('HDTEST1', 'NV001', 'KH001', NULL, GETDATE(), 0, N'Tiền mặt');
-- TEST 1: Insert 5 cái → hợp lệ
INSERT INTO CT_HOADONBAN (MaHD, MaSP, SoLuong, DonGia, ThanhTien)
VALUES ('HDTEST1', 'SP001', 5, 10000, 50000);
SELECT * FROM CT_HOADONBAN WHERE MaHD = 'HDTEST1';
-- TEST 2: Insert 20 cái → trigger phải CHẶN
INSERT INTO CT_HOADONBAN (MaHD, MaSP, SoLuong, DonGia, ThanhTien)
VALUES ('HDTEST1', 'SP001', 20, 10000, 200000);

/*
## III. TRIGGER DDL
### 1. Ứng dụng ghi log cho biết ai, khi nào thay đổi cấu trúc cơ sở dữ liệu
*/
-- Tạo bảng DDL_log để ghi lại các sự kiện DDL trong cơ sở dữ liệu SQL Server
DROP TABLE IF EXISTS DDL_log;
CREATE TABLE DDL_log(
    log_id INT IDENTITY(1,1) CONSTRAINT PK_DDL_log PRIMARY KEY,
    EventTime DATETIME DEFAULT GETDATE(), 
    EventType NVARCHAR(50),
    DatabaseName NVARCHAR(255),
    SchemaName NVARCHAR(255),
    ObjectName NVARCHAR(255),
    ObjectType NVARCHAR(50),
    TSQLCommand NVARCHAR(MAX),
    ExecutedBy NVARCHAR(255) DEFAULT SUSER_SNAME(),
    ActionStatus NVARCHAR(50) DEFAULT 'SUCCESS',
    EventXML XML NULL
);
-- Trigger ghi log các sự kiện DDL trong cơ sở dữ liệu SQL Server
CREATE OR ALTER TRIGGER trigg_ddl_log
ON DATABASE
FOR 
    CREATE_TABLE, ALTER_TABLE, DROP_TABLE,
    CREATE_VIEW, ALTER_VIEW, DROP_VIEW,
    CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE,
    CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION,
    CREATE_INDEX, ALTER_INDEX, DROP_INDEX,
    CREATE_TRIGGER, ALTER_TRIGGER, DROP_TRIGGER
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @EventData XML = EVENTDATA();
    DECLARE @EventType     NVARCHAR(100)  = @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)');
    DECLARE @DatabaseName  NVARCHAR(100)  = @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'NVARCHAR(100)');
    DECLARE @SchemaName    NVARCHAR(100)  = @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectName    NVARCHAR(100)  = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectType    NVARCHAR(100)  = @EventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(100)');
    DECLARE @TSQLCommand   NVARCHAR(MAX)  = @EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)');
    DECLARE @ExecutedBy    NVARCHAR(100)  = SUSER_SNAME();
    DECLARE @EventTime     DATETIME       = GETDATE();
    BEGIN TRY
        INSERT INTO DDL_log(
            EventTime,
            EventType,
            DatabaseName,
            SchemaName,
            ObjectName,
            ObjectType,
            TSQLCommand,
            ExecutedBy,
            ActionStatus,
            EventXML
        )
        VALUES(
            @EventTime,
            @EventType,
            @DatabaseName,
            @SchemaName,
            @ObjectName,
            @ObjectType,
            @TSQLCommand,
            @ExecutedBy,
            N'SUCCESS',
            @EventData
        );
        PRINT N'[DDL LOG] Ghi log thành công.';
    END TRY
    BEGIN CATCH
        INSERT INTO DDL_log(
            EventTime,
            EventType,
            DatabaseName,
            SchemaName,
            ObjectName,
            ObjectType,
            TSQLCommand,
            ExecutedBy,
            ActionStatus,
            EventXML
        )
        VALUES(
            GETDATE(),
            N'Lỗi khi ghi log DDL',
            DB_NAME(),
            NULL,
            NULL,
            NULL,
            ERROR_MESSAGE(),
            @ExecutedBy,
            N'FAILURE',
            NULL
        );
        PRINT N'[DDL LOG] Lỗi ghi log.';
    END CATCH
END;
GO
--B3. Kiểm tra trigger DDL ghi log
create table new_table(
    id int primary key,
    name varchar(50)
);
--B4. Hiển thị bảng ddl_log
select * from ddl_log;
alter table new_table add test_column varchar(255);
drop table if exists new_table;

/*
### 2. Ứng dụng TRIGGER DDL để ngăn chặn các hành vi thay đổi cấu trúc CSDL
*/
-- trigger ngăn chặn xóa bảng SANPHAM và ghi log vào bảng DDL_log
CREATE OR ALTER TRIGGER trigg_prevent_delete_sanpham
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @EventData XML = EVENTDATA();
    DECLARE @EventType     NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)');
    DECLARE @DatabaseName  NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'NVARCHAR(100)');
    DECLARE @SchemaName    NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectName    NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)');
    DECLARE @ObjectType    NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(100)');
    DECLARE @TSQLCommand   NVARCHAR(MAX) = @EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)');
    DECLARE @ExecutedBy    NVARCHAR(100) = SUSER_SNAME();
    DECLARE @EventTime     DATETIME      = GETDATE();
    -- Ngăn chặn DROP TABLE SANPHAM
    IF UPPER(@ObjectName) = 'SANPHAM'
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT N'Không được phép xóa bảng SANPHAM. Hành động đã bị ngăn chặn bởi trigger trigg_prevent_delete_sanpham.';
        INSERT INTO DDL_log(
            EventTime, EventType, DatabaseName, SchemaName, ObjectName,
            ObjectType, TSQLCommand, ExecutedBy, ActionStatus, EventXML
        )
        VALUES (
            @EventTime,
            @EventType,
            @DatabaseName,
            @SchemaName,
            @ObjectName,
            @ObjectType,
            N'Hành vi xóa bảng SANPHAM bị chặn bởi trigger trigg_prevent_delete_sanpham.',
            @ExecutedBy,
            N'TỪ CHỐI',
            NULL
        );
    END
END;
GO
CREATE TABLE TestDrop (ID INT);
DROP TABLE TestDrop;