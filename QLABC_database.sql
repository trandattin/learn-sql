CREATE DATABASE QLABC
GO

USE QLABC
GO

-- I. XÂY DỰNG CƠ SỞ DỮ LIỆU

CREATE TABLE Khach_le
(
	makh			char(4) PRIMARY KEY,
	cmnd			varchar(13),
	loai_the_td		nvarchar(10),
	stk				varchar(30), 
)
GO

CREATE TABLE Cong_ty
(
	makh			char(4) PRIMARY KEY,
	mst				varchar(20) UNIQUE,
	thue_gtgt		real 
)
GO

CREATE TABLE Khach_hang
(
	makh		char(4) PRIMARY KEY,
	ho_ten		nvarchar(30) NOT NULL,
	dia_chi		nvarchar(50) NOT NULL,
	sdt			varchar(12) NOT NULL,
	loai_khach	nvarchar(10) NOT NULL 
)
GO

CREATE TABLE Phieu_qua_tang
(
	mapqt		char(5) PRIMARY KEY,
	ngay_dk		datetime NOT NULL,
	ngay_nhan	datetime NOT NULL,
	trang_thai	int NOT NULL,
	makh		char(4) REFERENCES Khach_hang(makh)
)
GO

CREATE TABLE Hop_dong
(
	mahd			char(5) PRIMARY KEY,
	ngay_bd			datetime NOT NULL,
	ngay_kt			datetime NOT NULL,
	mo_ta			nvarchar(60),
	khuyen_mai		int,
	thanh_toan		nvarchar(30),
	makh			char(4) REFERENCES Khach_hang(makh)
)
GO

ALTER TABLE Khach_le
ADD CONSTRAINT FK_KL_KH FOREIGN KEY (makh) REFERENCES Khach_hang(MaKH);

ALTER TABLE Cong_ty
ADD CONSTRAINT FK_CT_KH FOREIGN KEY (MaKH) REFERENCES Khach_hang(MaKH);

ALTER TABLE Phieu_qua_tang
ADD CONSTRAINT FK_PQT_KH FOREIGN KEY (makh) REFERENCES Khach_hang(makh);

CREATE TABLE Nhan_vien
(
	manv			char(5) PRIMARY KEY,
	ho_ten			nvarchar(20),
	ngay_sinh		datetime,
	gioi_tinh		nvarchar(5),
	dia_chi			varchar(40),
	sdt				varchar(12),
	vi_tri			nvarchar(20)
)
GO

CREATE TABLE Don_dat_hang
(
	madh		char(5) PRIMARY KEY,
	ngay_dat	datetime,
	dinh_ky		nvarchar(20),
	tong_gia	decimal(18,2),
	manv		char(5) REFERENCES Nhan_vien(manv),
	mahd		char(5) REFERENCES Hop_dong(mahd)
)
GO

CREATE TABLE San_pham
(
	masp		char(4) PRIMARY KEY,
	ten_sp		nvarchar(40) NOT NULL,
	loai_sp		nvarchar(20) NOT NULL,
	so_seri_sx	varchar(20) NOT NULL
)
GO

CREATE TABLE CT_khuyen_mai
(
	makm				char(6) PRIMARY KEY,
	ten_ct				nvarchar(40) NOT NULL,
	tg_bd				datetime NOT NULL,
	tg_kt				datetime NOT NULL,
	dieu_kien			nvarchar(40) NOT NULL
)
GO

CREATE TABLE Qua_tang
(
	maqt		char(5) PRIMARY KEY,
	ten_qua		nvarchar(50) NOT NULL
)
GO

CREATE TABLE CTKM
(
	makm			char(6) REFERENCES CT_khuyen_mai(makm),
	maqt			char(5) REFERENCES Qua_tang(maqt),
	qua_muon_nhan	varchar(50) NOT NULL,
	PRIMARY KEY (makm, maqt)
)
GO

CREATE TABLE CTPQT
(
	so_luong	int,
	makm		char(6),
	maqt		char(5),
	mapqt		char(5) REFERENCES Phieu_qua_tang(mapqt),
	FOREIGN KEY (makm, maqt) REFERENCES CTKM(makm, maqt),
	PRIMARY KEY (mapqt,makm,maqt)
)
GO

CREATE TABLE CTDH
(	
	masp		char(4) REFERENCES San_pham(masp),
	madh		char(5) REFERENCES Don_dat_hang(madh),
	so_luong	int NOT NULL,
	hinh_thuc	nvarchar(10),
	chiet_khau	real,
	PRIMARY KEY (masp,madh)
)
GO

CREATE TABLE Phieu_sua_chua
(
	maps	char(6) PRIMARY KEY,
	mo_ta			nvarchar(60),
	ngay_sua_chua	datetime,
	phi_sua_chua	decimal(18,2),
	manv			char(5) REFERENCES Nhan_vien(manv)	
)
GO

CREATE TABLE CTSC
(
	masp		 char(4),
	madh		 char(5),
	maps		 char(6) REFERENCES Phieu_sua_chua(maps),
	FOREIGN KEY (masp,madh) REFERENCES CTDH(masp,madh),
	PRIMARY KEY (masp,madh,maps)
)
GO

CREATE TABLE Phieu_giao_hang
(
	mapg			char(5) PRIMARY KEY,
	ngay_giao	datetime,
	manv			char(5) REFERENCES Nhan_vien(manv),
	madh			char(5) REFERENCES Don_dat_hang(madh)
)
GO

CREATE TABLE Phieu_thu
(
	ma_phieu_thu	char(5) PRIMARY KEY,
	ngay_thu		datetime,
	tong			decimal(18,2) NOT NULL,
	manv			char(5) REFERENCES Nhan_vien(manv),
	mapg			char(5) REFERENCES Phieu_giao_hang(mapg)
)
GO
