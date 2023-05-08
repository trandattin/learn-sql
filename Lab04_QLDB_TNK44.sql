/* Học phần: Cơ sở dữ liệu
   Người thực hiện: Trần Đạt Tín
   MSSV: 2011345
   Lớp: TNK44
   Ngày bắt đầu: 14/03/2023
   Ngày hoàn thiện: 22/04/2023
*/	

CREATE DATABASE Lab04_QLDB

go
use Lab04_QLDB

-- I. XÂY DỰNG CƠ SỞ DỮ LIỆU
--1
go 
create table BAO_TCHI
(
	MaBaoTC char(4) primary key,
	Ten nvarchar(30) not null,
	DinhKy nvarchar(20) not null,
	SoLuong int,
	GiaBan int
)

--2
go
create table PHATHANH
(
	MaBaoTC char(4) references BAO_TCHI(MaBaoTC),
	SoBaoTC	int,
	NgayPH datetime,
	primary key (SoBaoTC,MaBaoTC)
)

--3
go
create table KHACHHANG
(
	MaKH char(4) primary key,
	TenKH nvarchar(10),
	DiaChi varchar(10)
)

--4
go 
create table DATBAO
(
	MaKH char(4) references KHACHHANG(MaKH),
	MaBaoTC char(4) references BAO_TCHI(MaBaoTC),
	SLMua int,
	NgayDM datetime,
	primary key(MaKH,MaBaoTC)
)

-------------NHAP DU LIEU CHO CAC BANG-----------
--Nhập dữ liệu cho bảng BAO_TCHI
insert into BAO_TCHI values('TT01',N'Tuổi Trẻ',N'Nhật Báo',1000,1500)
insert into BAO_TCHI values('KT01',N'Kiến thức ngày nay',N'Bán nguyệt san',3000,6000)
insert into BAO_TCHI values('TN01',N'Thanh niên',N'Nhật báo',1000,2000)
insert into BAO_TCHI values('PN01',N'Phụ nữ',N'Tuần báo',2000,4000)
insert into BAO_TCHI values('PN02',N'Phụ nữ',N'Nhật báo',1000,4000)


--Nhập dữ liệu cho bảng PHATHANH
set dateformat dmy
go
insert into PHATHANH values('TT01', 123, '15/12/2005')
insert into PHATHANH values('KT01', 70, '15/12/2005')
insert into PHATHANH values('TT01', 124, '16/12/2005')
insert into PHATHANH values('TN01', 256, '17/12/2005')
insert into PHATHANH values('PN01', 45, '23/12/2005')
insert into PHATHANH values('PN02', 111, '18/12/2005')
insert into PHATHANH values('PN02', 112, '19/12/2005')
insert into PHATHANH values('TT01', 125, '17/12/2005')
insert into PHATHANH values('PN01', 46, '30/12/2005')

insert into KHACHHANG values('KH01', N'LAN', '2 NCT')
insert into KHACHHANG values('KH02', N'NAM', '32 THĐ')
insert into KHACHHANG values('KH03', N'NGỌC', '16 LHP')

set dateformat dmy
go
insert into DATBAO values('KH01', 'TT01', 100,'12/01/2000')
insert into DATBAO values('KH02', 'TN01', 150,'01/05/2001')
insert into DATBAO values('KH01', 'PN01', 200,'25/06/2001')
insert into DATBAO values('KH03', 'KT01', 200,'17/03/2002')
insert into DATBAO values('KH03', 'PN02', 250,'26/08/2003')
insert into DATBAO values('KH02', 'TT01', 250,'15/01/2004')
insert into DATBAO values('KH01', 'KT01', 300,'14/10/2004')

SELECT * FROM BAO_TCHI
SELECT * FROM PHATHANH
SELECT * FROM KHACHHANG
SELECT * FROM DATBAO

-- II. TRUY VẤN DỮ LIỆU

--1) Cho biết các tờ báo, tạp chí (MABAOTC,TEN,GIABAN) có định kỳ phát hành hàng tuần (Tuần báo)

SELECT MaBaoTC, Ten, GiaBan
FROM BAO_TCHI
WHERE DinhKy = N'Tuần báo'

--2) Cho biết thông tin về các tờ báo thuộc loại báo phụ nữ (mã báo tạp chí bắt đầu bằng PN).

SELECT *
FROM BAO_TCHI
WHERE MaBaoTC LIKE 'PN%'

--3) Cho biết tên các khách hàng có đặt mua báo phụ nữ (mã báo tạp chí bắt đầu bằng PN), không liệt kê khách hàng trùng

SELECT KH.TenKH
FROM KHACHHANG as KH, DATBAO as DB
WHERE KH.MaKH = DB.MaKH AND DB.MaBaoTC LIKE 'PN%'
GROUP BY KH.TenKH

--4) Cho biết tên các khách hàng có đặt mua tất cả các báo phụ nữ (mã báo tạp chí bắt đầu bằng PN)

SELECT KH.TenKH
FROM KHACHHANG as KH, DATBAO as DB
WHERE KH.MaKH = DB.MaKH AND DB.MaBaoTC LIKE 'PN%'
GROUP BY KH.TenKH
HAVING COUNT(DB.MaBaoTC) = (
	SELECT COUNT(DB.MaBaoTC)
	FROM DATBAO as DB
	WHERE DB.MaBaoTC LIKE 'PN%'
)

--5) Cho biết các khách hàng không đặt mua báo thanh niên

SELECT KH2.TenKH, KH2.DiaChi
FROM KHACHHANG as KH2 
WHERE KH2.MaKH not in ( 
	SELECT KH.MaKH
	FROM KHACHHANG AS KH, DATBAO as DB
	WHERE KH.MaKH = DB.MaKH AND MaBaoTC LIKE 'TN%'
)

--6) Cho biết số tờ báo mà mỗi khách hàng đa đặt mua

SELECT KH.TenKH, SUM(DB.SLMua) as N'Số lượng mua'
FROM KHACHHANG AS KH, DATBAO AS DB
WHERE KH.MaKH = DB.MaKH
GROUP BY KH.TenKH

--7) Cho biết số khách hàng đặt mua báo trong năm 2004

SELECT COUNT(MaKH) as 'Số khách hàng đặt mua năm 2004'
FROM DATBAO AS DB
WHERE YEAR(DB.NgayDM) = 2004

--8) Cho biết thông tin đặt mua báo của các khách hàng (TenKH, TeN, DinhKy, SLMua, SoTien), trong đó So Tien = SLMua x DonGia

SELECT KH.TenKH, BTC.Ten, BTC.DinhKy, DB.SLMua, SUM(DB.SLMua*BTC.GiaBan) AS N'Số tiền'
FROM BAO_TCHI AS BTC, DATBAO AS DB, KHACHHANG AS KH
WHERE BTC.MaBaoTC = DB.MaBaoTC AND KH.MAKH = DB.MaKH
GROUP BY KH.TenKH, BTC.Ten, BTC.DinhKy, DB.SLMua

--9) Cho biết các tờ báo, tạp chí (Ten, DinhKy) và tổng số lượng đặt mua của các khách hàng đối với tờ báo, tạp chí đó.

SELECT BTC.Ten, BTC.DinhKy, SUM(DB.SLMua) as N'Tổng số lượng đặt mua'
FROM BAO_TCHI AS BTC, DATBAO AS DB
WHERE BTC.MaBaoTC = DB.MaBaoTC
GROUP BY BTC.Ten, BTC.DinhKy

--10) Cho biết tên các tờ báo dành cho học sinh, sinh viên (mã boá tạp chí bắt đầu bằng HS).

SELECT BTC.Ten
FROM BAO_TCHI AS BTC
WHERE BTC.MaBaoTC LIKE 'HS%'


--11) Cho biết những tờ báo không có người đặt mua

SELECT BTC.Ten
FROM BAO_TCHI AS BTC
WHERE BTC.MaBaoTC not in (
	SELECT DB.MaBaoTC
	FROM DATBAO AS DB
	GROUP BY DB.MaBaoTC
)

--debug
/*
insert into BAO_TCHI values('HS01',N'Nhi Đồng',N'Nhật báo',2000,3000)
DELETE FROM BAO_TCHI 
WHERE MaBaoTC = 'HS01' 
  AND Ten = N'Nhi Đồng' 
  AND DinhKy = N'Nhật báo' 
  AND SoLuong = 2000 
  AND GiaBan = 3000;
*/

--12) Cho biết tên, định kỳ, của những tờ báo có nhiều người đặt mua nhất

SELECT BTC.Ten,BTC.DinhKy,Count(BTC.MaBaoTC) AS N'Số người đặt mua'
FROM BAO_TCHI AS BTC, DATBAO AS DB
WHERE BTC.MaBaoTC = DB.MaBaoTC
GROUP BY BTC.Ten,BTC.DinhKy
HAVING Count(BTC.MaBaoTC) >=all (
	SELECT COUNT(BTC2.MaBaoTC)
	FROM BAO_TCHI AS BTC2, DATBAO AS DB2
	WHERE BTC2.MaBaoTC = DB2.MaBaoTC
	GROUP BY BTC2.MaBaoTC
)

--13) Cho biết khách hàng đặt mua nhiều báo, tạp chí nhất

SELECT KH.MaKH, KH.TenKH, KH.DiaChi, COUNT(DB2.MaBaoTC) AS N'Số lần đặt'
FROM KHACHHANG AS KH, DATBAO AS DB2
WHERE KH.MaKH = DB2.MaKH 
GROUP BY KH.MaKH, KH.TenKH, KH.DiaChi
HAVING COUNT(DB2.MaBaoTC) >=all (
	SELECT COUNT(DB.MaBaoTC)
	FROM DATBAO AS DB
	GROUP BY DB.MaKH
)

--14) Cho biết các tờ báo phát hành định kỳ một tháng 2 lần.

SELECT BTC.MaBaoTC, BTC.Ten 
FROM BAO_TCHI AS BTC
WHERE BTC.DinhKy LIKE N'Bán nguyệt san'

--15) Cho biết các tờ báo, tạp chí có từ 3 khách hàng đặt mua trở lên

SELECT BTC.Ten
FROM DATBAO AS DB, BAO_TCHI AS BTC
WHERE DB.MaBaoTC = BTC.MaBaoTC 
GROUP BY BTC.Ten
HAVING COUNT(BTC.MaBaoTC) >= 2

-- II HÀM & THỦ TỤC
-- A. Viết các hàm sau
-- a. Tính tổng số tiền mua báo/tạp chí của một khách hàng cho trước

create function TinhTongTien (@MaKH char(4))
RETURNs int
AS
BEGIN
	declare @sum int = 0
	SELECT @sum = SUM(db.SLMua * btc.GiaBan)
	FROM DATBAO AS db
    INNER JOIN BAO_TCHI AS btc ON db.MaBaoTC = btc.MaBaoTC
	WHERE db.MaKH = @MaKH
	return @sum
END

print dbo.TinhTongTien('KH01')
SELECT * FROM KHACHHANG

-- b. Tính tổng số tiền thu được của một tờ báo/tạp chí cho trước

create function TinhTongTienTapChi (@MaBaoTC char(4))
RETURNS int
AS
BEGIN
		declare @sum int = 0
		select @sum = sum(btc.GiaBan * db.slmua)
		from datbao as db
		INNER JOIN BAO_TCHI as btc ON btc.MaBaoTC = db.MaBaoTC
		where btc.MaBaoTC = @MaBaoTC
		return @sum
END

print dbo.TinhTongTienTapChi('TT01')

-- B. Viết các thủ tục sau
-- a. In danh mục báo, tạp chí phải giao cho một khách hàng cho trước.
create procedure indanhmucbao
	@MaKH char(4)
AS
BEGIN
	IF EXISTS (SELECT * FROM KHACHHANG WHERE MaKh = @MaKH)
		SELECT btc.Ten, btc.DinhKy
		FROM DATBAO as DB
		INNER JOIN BAO_TCHI AS BTC ON btc.MaBaoTC = db.MaBaoTC
		Where db.MaKH = @MaKH
	ELSE
		PRINT N'Không tồn tại khách hàng đã cho'
END

exec indanhmucbao 'KH01'

-- b. In danh sách khách hàng đặt mua báo/tạp chí cho trước.

create procedure indanhsachkhachhang
	@MaBaoTC char(4)
AS
BEGIN
	IF EXISTS (SELECT * FROM BAO_TCHI WHERE @MaBaoTC = MaBaoTC)
		SELECT KH.TenKH, KH.DiaChi
		FROM DATBAO as DB
		INNER JOIN  KHACHHANG AS KH ON KH.MaKH = DB.MaKH
		WHERE DB.MaBaoTC = @MaBaoTC
	ELSE
		PRINT N'Không tồn tại báo/tạp chí đã cho'
END

exec indanhsachkhachhang 'TT01'