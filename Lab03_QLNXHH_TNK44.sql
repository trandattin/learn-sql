/* Học phần: Cơ sở dữ liệu
   Người thực hiện: Trần Đạt Tín
   MSSV: 2011345
   Lớp: TNK44
   Ngày bắt đầu: 14/03/2023
   Ngày hoàn thiện: 22/04/2023
   Lab 03: Quản lý nhập xuất hàng hoá
*/	

CREATE DATABASE Lab03_QLNXHH

go
use Lab03_QLNXHH

-- I. XÂY DỰNG CƠ SỞ DỮ LIỆU

--1
go 
create table HANGHOA
(
	MAHH varchar(5) primary key,
	TENHH varchar(40) not null,
	DVT nvarchar(10),
	SOLUONGTON int,
)

--2
go 
create table DOITAC
(
	MADT char(5) primary key,
	TENDT nvarchar(30) not null,
	DIACHI nvarchar(40) not null,
	DIENTHOAI varchar(12)
)

--3
go 
set dateformat dmy
create table HOADON
(
	SOHD char(5) primary key,
	NGAYLAPHD datetime,
	MADT char(5) references DOITAC(MADT),
	TONGTG int
)

--4
go 
create table KHANANGCC
(
	MADT char(5) references DOITAC(MADT),
	MAHH varchar(5) references HANGHOA(MAHH),
	primary key(MADT,MAHH)
)

--5
go
create table CT_HOADON
(
	SOHD char(5) references HOADON(SOHD),
	MAHH varchar(5) references HANGHOA(MAHH),
	DONGIA int,
	SOLUONG int,
	primary key (SOHD,MAHH)
)

-------------NHAP DU LIEU CHO CAC BANG-----------
--Nhập dữ liệu cho bảng Hàng Hoá
insert into HANGHOA values('CPU01','CPU INTEL, CELERON 600 BOX',N'CÁI',5)
insert into HANGHOA values('CPU02','CPU INTEL, PIII 700',N'CÁI',10)
insert into HANGHOA values('CPU03','CPU AMD K7 ATHL,ON 600',N'CÁI',8)
insert into HANGHOA values('HDD01','HDD 10.2 GB QUANTUM',N'CÁI',10)
insert into HANGHOA values('HDD02','HDD 13.6 GB SEAGATE',N'CÁI',15)
insert into HANGHOA values('HDD03','HDD 20 GB QUANTUM',N'CÁI',6)
insert into HANGHOA values('KB01','KB GENIUS',N'CÁI',12)
insert into HANGHOA values('KB02','KB MITSUMIMI',N'CÁI',5)
insert into HANGHOA values('MB01','GIGABYTE CHIPSET INTEL',N'CÁI',10)
insert into HANGHOA values('MB02','ACOPR BX CHIPSET VIA',N'CÁI',10)
insert into HANGHOA values('MB03','INTEL PHI CHIPSET INTEL',N'CÁI',10)
insert into HANGHOA values('MB04','ECS CHIPSET SIS',N'CÁI',10)
insert into HANGHOA values('MB05','ECS CHIPSET VIA',N'CÁI',10)
insert into HANGHOA values('MNT01','SAMSUNG 14" SYNCMASTER',N'CÁI',5)
insert into HANGHOA values('MNT02','LG 14"',N'CÁI',5)
insert into HANGHOA values('MNT03','ACER 14"',N'CÁI',8)
insert into HANGHOA values('MNT04','PHILIPS 14"',N'CÁI',6)
insert into HANGHOA values('MNT05','VIEWSONIC 14"',N'CÁI',7)

SELECT * FROM HANGHOA
--DELETE FROM HANGHOA

insert into DOITAC values('CC001',N'Cty TNC',N'176 BTX Q1 - TP.HCM','08.8250259')
insert into DOITAC values('CC002',N'Cty Hoàng Long',N'15A TTT Q1 - TP.HCM','08.8250898')
insert into DOITAC values('CC003',N'Cty Hợp Nhất',N'152 BTX Q1 - TP.HCM','08.8252376')
insert into DOITAC values('K0001',N'Nguyễn Minh Hải',N'91 Nguyễn Văn Trỗi Tp.Đà Lạt','063.831129')
insert into DOITAC values('K0002',N'Như Quỳnh',N'21 Điện Biên Phủ. N.Trang','058590270')
insert into DOITAC values('K0003',N'Trần Nhật Duật',N'Lê Lợi TP.Huế','054.848376')
insert into DOITAC values('K0004',N'Phan Nguyễn Hùng Anh',N'11 Nam Kỳ Khởi Nghĩa - TP.Đà lạt','063.823409')

SELECT * FROM DOITAC
--DELETE FROM DOITAC

set dateformat dmy 
go
insert into HOADON values('N0001','25/01/2006','CC001',null)
insert into HOADON values('N0002','01/05/2006','CC002',null)
insert into HOADON values('X0001','12/05/2006','K0001',null)
insert into HOADON values('X0002','16/06/2006','K0002',null)
insert into HOADON values('X0003','20/04/2006','K0001',null)

SELECT * FROM HOADON

insert into KHANANGCC values('CC001','CPU01')
insert into KHANANGCC values('CC001','HDD03')
insert into KHANANGCC values('CC001','KB01')
insert into KHANANGCC values('CC001','MB02')
insert into KHANANGCC values('CC001','MB04')
insert into KHANANGCC values('CC001','MNT01')
insert into KHANANGCC values('CC002','CPU01')
insert into KHANANGCC values('CC002','CPU02')
insert into KHANANGCC values('CC002','CPU03')
insert into KHANANGCC values('CC002','KB02')
insert into KHANANGCC values('CC002','MB01')
insert into KHANANGCC values('CC002','MB05')
insert into KHANANGCC values('CC002','MNT03')
insert into KHANANGCC values('CC003','HDD01')
insert into KHANANGCC values('CC003','HDD02')
insert into KHANANGCC values('CC003','HDD03')
insert into KHANANGCC values('CC003','MB03')

SELECT * FROM KHANANGCC

insert into CT_HOADON values('N0001','CPU01',63,10)
insert into CT_HOADON values('N0001','HDD03',97,7)
insert into CT_HOADON values('N0001','KB01',3,5)
insert into CT_HOADON values('N0001','MB02',57,5)
insert into CT_HOADON values('N0001','MNT01',112,3)
insert into CT_HOADON values('N0002','CPU02',115,3)
insert into CT_HOADON values('N0002','KB02',5,7)
insert into CT_HOADON values('N0002','MNT03',111,5)
insert into CT_HOADON values('N0002','CPU02',67,2)
insert into CT_HOADON values('X0001','CPU01',67,2)
insert into CT_HOADON values('X0001','HDD03',100,2)
insert into CT_HOADON values('X0001','KB01',5,2)
insert into CT_HOADON values('X0001','MB02',62,1)
insert into CT_HOADON values('X0002','CPU01',67,1)
insert into CT_HOADON values('X0002','KB02',7,3)
insert into CT_HOADON values('X0002','MNT01',115,2)
insert into CT_HOADON values('X0003','CPU01',67,1)
insert into CT_HOADON values('X0003','MNT03',115,2)

SELECT * FROM CT_HOADON

---------------------------------------------------------
-- II TRUY VẤN DỮ LIỆU
--1) Liệt kê các mặt hàng thuộc loại đĩa cứng
SELECT *
FROM HANGHOA
WHERE MAHH LIKE 'HDD%'

--2) Liệt kê các mặt hàng có số lượng tồn trên 10
SELECT *
FROM HANGHOA
WHERE SOLUONGTON > 10

--3) Cho biết thông tin về các nhà cung cấp ở TP HCM
SELECT *
FROM DOITAC
WHERE DIACHI LIKE '%HCM%'

--4) Liệt kê các hoá đơn nhập hàng trong tháng 5/2006, thông tin hiển thị gồm
--sohd; ngayaphd; ten,ten,dia chi và điện thoại của nhà cung cấp, số mặt hàng

SELECT HD.SOHD, HD.NGAYLAPHD, DT.TENDT, DT.DIACHI, DT.DIENTHOAI, COUNT(CTHD.SOLUONG) as 'Số mặt hàng'
FROM HOADON as HD, CT_HOADON as CTHD, DOITAC as DT 
WHERE DT.MADT = HD.MADT AND CTHD.SOHD = HD.SOHD AND MONTH(NGAYLAPHD) = 05 AND YEAR(NGAYLAPHD) = 2006 AND HD.SOHD LIKE 'N%'
GROUP BY HD.SOHD,HD.NGAYLAPHD, DT.TENDT, DT.DIACHI, DT.DIENTHOAI

--5) Cho biết tên các nhà cung cấp có cung cấp đĩa cứng

SELECT DISTINCT DT.TENDT
FROM DOITAC as DT, KHANANGCC as KN, HANGHOA as HH
WHERE HH.MAHH = KN.MAHH AND KN.MADT = DT.MADT AND HH.MAHH LIKE 'HDD%'

--6) Cho biết tên các nhà cung cấp có thể cung cấp tất cả các loại đĩa cứng

SELECT DT.TENDT
FROM DOITAC as DT, KHANANGCC as KN, HANGHOA as HH
WHERE HH.MAHH = KN.MAHH AND KN.MADT = DT.MADT AND HH.MAHH LIKE 'HDD%'
GROUP BY DT.TENDT
HAVING COUNT(HH.MAHH) = (
	SELECT COUNT(MAHH)
	FROM HANGHOA
	WHERE MAHH LIKE 'HDD%'
)

--7) Cho biết tên nhà cung cấp không cung cấp đĩa cứng
SELECT DISTINCT TENDT
FROM DOITAC
WHERE MADT LIKE 'C%' AND MADT NOT IN (
	SELECT DISTINCT KN.MADT
	FROM KHANANGCC as KN
	WHERE KN.MAHH LIKE 'HDD%'
)

-- 8) Cho biết thông tin mặt hàng chưa bán được

SELECT *
FROM HANGHOA
WHERE MAHH NOT IN (
	SELECT DISTINCT MAHH
	FROM CT_HOADON
	WHERE SOHD LIKE 'X%'
)

--9) Cho biết tên và tổng số lượng bán của mặt hàng bán chạy nhất (tính theo số lượng)

SELECT HH.TENHH, SUM(CT.SOLUONG) 
FROM HANGHOA as HH, CT_HOADON as CT
WHERE HH.MAHH = CT.MAHH AND SOHD LIKE 'X%'
GROUP BY HH.TENHH
HAVING SUM(CT.SOLUONG) >=all (
	SELECT SUM(SOLUONG)
	FROM CT_HOADON
	WHERE SOHD LIKE 'X%'
	GROUP BY MAHH
)

--10) Cho biết tên và tổng số lượng của mặt hàng nhập về ít nhất

SELECT CT.MAHH, SUM(SOLUONG) as 'Tổng số lượng'
FROM CT_HOADON as CT, HANGHOA as HH
WHERE CT.MAHH = HH.MAHH AND CT.SOHD LIKE 'N%'
GROUP BY CT.MAHH
HAVING SUM(SOLUONG) <=all (
	SELECT SUM(SOLUONG)
	FROM CT_HOADON
	WHERE CT_HOADON.SOHD LIKE 'N%'
	GROUP BY MAHH
)

--11) Cho biết hoá đơn nhập nhiều mặt hàng nhất

SELECT B.SOHD, B.NGAYLAPHD
FROM CT_HOADON as A, HOADON as B
WHERE A.SOHD = B.SOHD AND A.SOHD LIKE 'N%'
GROUP BY B.SOHD, B.NGAYLAPHD
HAVING COUNT(MAHH) >=all (
	SELECT COUNT(MAHH)
	FROM CT_HOADON
	WHERE SOHD LIKE 'N%'
	GROUP BY SOHD
)

--12) Cho biết các mặt hàng không được nhập trong tháng 1/2006

SELECT *
FROM HANGHOA 
WHERE HANGHOA.MAHH NOT IN (
	SELECT HH.MAHH
	FROM HOADON as HD, CT_HOADON as CT, HANGHOA as HH
	WHERE HH.MAHH = CT.MAHH AND HD.SOHD = CT.SOHD AND CT.SOHD LIKE 'N%' AND MONTH(HD.NGAYLAPHD) = 1 AND YEAR(HD.NGAYLAPHD) = 2006
)

--13) Cho biết tên các mặt hàng không bán được trong tháng 6/2006
SELECT *
FROM HANGHOA 
WHERE HANGHOA.MAHH NOT IN (
	SELECT HH.MAHH
	FROM HOADON as HD, CT_HOADON as CT, HANGHOA as HH
	WHERE HH.MAHH = CT.MAHH AND HD.SOHD = CT.SOHD AND CT.SOHD LIKE 'X%' AND MONTH(HD.NGAYLAPHD) = 6 AND YEAR(HD.NGAYLAPHD) = 2006
)

--14) Cho biết cửa hàng bán bao nhiêu mặt hàng
SELECT COUNT(MAHH)
FROM HANGHOA

--15) Cho biết số mặt hàng mà từng nhà cung cấp có khả năng cung cấp
SELECT DT.TENDT, COUNT(MAHH) as 'Số mặt hàng'
FROM DOITAC as DT, KHANANGCC as KN
WHERE DT.MADT = KN.MADT
GROUP BY DT.TENDT

--16) Cho biết thông tin của khách hàng có giao dịch với cửa hàng nhiều nhất

SELECT DT2.TENDT, DT2.DIACHI, DT2.DIENTHOAI, COUNT(HD2.SOHD) as 'Số lần giao dịch'
FROM DOITAC as DT2, HOADON as HD2
WHERE DT2.MADT = HD2.MADT AND HD2.SOHD LIKE 'X%'
GROUP BY DT2.TENDT, DT2.DIACHI, DT2.DIENTHOAI
HAVING COUNT(HD2.SOHD) >=all (
	SELECT COUNT(HD.SOHD)
	FROM HOADON as HD
	WHERE HD.SOHD LIKE 'X%'
	GROUP BY HD.MADT
)

--17) Tính tổng doanh thu năm 2006
SELECT sum(Soluong*DonGia) as 'Tổng doanh thu 2006'
FROM CT_HOADON AS CT, HOADON AS HD
WHERE CT.SOHD = HD.SOHD AND CT.SOHD LIKE 'X%' AND YEAR(HD.NGAYLAPHD) = 2006

--18) Cho biết loại mặt hàng bán chạy nhất
SELECT left(CT.MAHH,LEN(CT.MAHH)-2) as 'Loại mặt hàng', SUM(SOLUONG) as 'Số lượng'
FROM CT_HOADON as CT
WHERE CT.SOHD LIKE 'X%'
GROUP BY left(CT.MAHH,LEN(CT.MAHH)-2)  
HAVING SUM(SOLUONG) >= all (
	SELECT SUM(SOLUONG)
	FROM CT_HOADON as CT
	WHERE CT.SOHD LIKE 'X%'
	GROUP BY left(CT.MAHH,LEN(CT.MAHH)-2)  
)

--19) Liệt kê thông tin bán hàng của tháng 05/2006 bao gồm: mahh,tenhh,dvt,tổng số lượng,tổng thành tiền
SELECT HH.MAHH, HH.TENHH, HH.DVT, SUM(SOLUONG) AS N'Tổng số lượng', SUM(SOLUONG*CT.DONGIA) AS N'Tổng Thành Tiền'
FROM HANGHOA AS HH, HOADON AS HD, CT_HOADON AS CT
WHERE HH.MAHH = CT.MAHH AND HD.SOHD = CT.SOHD AND MONTH(HD.NGAYLAPHD) = 05 AND YEAR(HD.NGAYLAPHD) = 2006
GROUP BY HH.MAHH, HH.TENHH, HH.DVT

--20) Liệt kê thông tin của mặt hàng có nhiều người mua nhất

SELECT HH.MAHH,HH.TENHH,HH.DVT,HH.SOLUONGTON, SUM(CT.SOLUONG) AS N'Số lượng mua'
FROM HANGHOA AS HH, CT_HOADON AS CT
WHERE HH.MAHH = CT.MAHH AND CT.SOHD LIKE 'X%'
GROUP BY HH.MAHH,HH.TENHH,HH.DVT,HH.SOLUONGTON
HAVING SUM(CT.SOLUONG) >=all (
    SELECT SUM(SOLUONG)
	FROM CT_HOADON 
	WHERE SOHD LIKE 'X%'
	GROUP BY MAHH
)

--21) Tính và cập nhật tổng giá trị hoá đơn

UPDATE HoaDon 
SET TONGTG = (
	SELECT SUM(DONGIA * SOLUONG)
	FROM  CT_HOADON AS CT
	WHERE CT.SOHD = HOADON.SOHD
);

SELECT * FROM HOADON

-- III Thủ tục & Hàm
-- A. Viết các hàm sau:

-- a. Tính tổng số lượng nhập trong một khoảng thời gian của một mặt hàng cho trước.

CREATE FUNCTION fn_TinhTongSoLuongNhap (@nbd datetime,@nkt datetime)
RETURNS int
AS
BEGIN
	IF (@nbd > @nkt)
        RETURN 0

	declare @sum int = 0
	IF EXISTS (SELECT * FROM HOADON WHERE NGAYLAPHD BETWEEN @nbd AND @nkt)
		BEGIN
			SELECT @sum = sum(CTHD.SoLuong)
			FROM HOADON AS HD
			INNER JOIN CT_HOADON AS CTHD ON HD.SOHD = CTHD.SOHD
			WHERE HD.NgayLapHD BETWEEN @nbd AND @nkt AND CTHD.SOHD LIKE 'N%'
		END
	IF @sum IS NULL
		RETURN 0
	ELSE
		RETURN @sum
	RETURN -1
END

set dateformat dmy
SELECT DBO.fn_TinhTongSoLuongNhap('24/01/2006','26/01/2006') ;

-- b. Tính tổng số lượng xuất trong một khoảng thời gian của một mặt hàng cho trước.

CREATE FUNCTION fn_TinhTongSoLuongXuat (@nbd datetime, @nkt datetime)
RETURNS int
AS
BEGIN
	IF (@nbd > @nkt)
        RETURN 0

	declare @sum int = 0
	IF EXISTS (SELECT * FROM HOADON WHERE NGAYLAPHD BETWEEN @nbd AND @nkt)
		BEGIN
			SELECT @sum = sum(CTHD.SoLuong)
			FROM HOADON AS HD
			INNER JOIN CT_HOADON AS CTHD ON HD.SOHD = CTHD.SOHD
			WHERE HD.NgayLapHD BETWEEN @nbd AND @nkt AND CTHD.SOHD LIKE 'X%'
		END
	IF @sum IS NULL
		RETURN 0
	ELSE 
		RETURN @sum
	RETURN -1
END

set dateformat dmy
SELECT DBO.fn_TinhTongSoLuongXuat('24/01/2006','13/05/2006') ;

-- c. Tính tổng doanh thu trong một tháng cho trước.

select * from 

CREATE FUNCTION fn_tongdoanhthutheothang (@thang char(2), @nam char(4))
RETURNS int
AS
BEGIN
	DECLARE @sum int = 0
	IF EXISTS (SELECT * FROM HOADON AS HD WHERE MONTH(HD.NGAYLAPHD) = @thang AND YEAR(HD.NGAYLAPHD) = @nam)
		BEGIN
			SELECT @sum = sum(CTHD.DONGIA * CTHD.SOLUONG)
			FROM HOADON AS HD
			INNER JOIN CT_HOADON AS CTHD ON HD.SOHD = CTHD.SOHD
			WHERE MONTH(HD.NGAYLAPHD) = @thang AND YEAR(HD.NGAYLAPHD) = @nam AND CTHD.SOHD LIKE 'X%'
		END
	IF @sum IS NULL
		RETURN 0
	ELSE
		RETURN @sum
	RETURN -1
END

	SELECT DBO.fn_tongdoanhthutheothang('05','2006') AS N'Tổng doanh thu theo tháng đã cho';

-- d. Tính tổng doanh thu của một mặt hàng trong một khoảng thời gian cho trước.

CREATE FUNCTION fn_tongDoanhThuMatHangTheoThoiGian (@nbd datetime, @nkt datetime, @mamh varchar(5))
RETURNS int
AS
BEGIN
	DECLARE @sum int = 0

	IF (@nbd > @nkt)
        RETURN 0

	SELECT @sum = sum(CTHD.DONGIA * CTHD.SOLUONG)
	FROM HOADON AS HD
	INNER JOIN CT_HOADON AS CTHD ON HD.SOHD = CTHD.SOHD 
	WHERE HD.NGAYLAPHD BETWEEN @nbd AND @nkt AND CTHD.MAHH = @mamh AND CTHD.SOHD LIKE 'X%'
		
	IF @sum IS NULL
		RETURN 0
	RETURN @sum
END

set dateformat dmy
SELECT DBO.fn_tongDoanhThuMatHangTheoThoiGian('24/01/2006','13/05/2006','MB02') AS N'Tổng doanh thu mặt hàng theo thời gian đã cho';


-- e. Tính tổng số tiền nhập hàng trong một khoảng thời gian cho trước.

CREATE FUNCTION fn_tongTienNhapHang (@nbd datetime, @nkt datetime)
RETURNS int
AS
BEGIN
	IF (@nbd > @nkt)
        RETURN 0
    
    DECLARE @sum int = 0

    SELECT @sum = SUM(CTHD.DONGIA * CTHD.SOLUONG)
    FROM HOADON AS HD
    INNER JOIN CT_HOADON AS CTHD ON HD.SOHD = CTHD.SOHD 
    WHERE HD.NGAYLAPHD BETWEEN @nbd AND @nkt AND CTHD.SOHD LIKE 'N%'

    IF (@sum IS NULL)
        RETURN 0
    RETURN @sum
END

set dateformat dmy
SELECT DBO.fn_tongTienNhapHang ('26/01/2005','13/05/2006') AS N'Tổng tiền nhập hàng theo thời gian đã cho';

-- f. Tính tổng số tiền của một hoá đơn cho trước.

CREATE FUNCTION fn_TongTienHoaDon(@sohd char(5))
RETURNS int
AS
BEGIN
	DECLARE @sum int

	SELECT @sum = sum(DONGIA * SOLUONG)
	FROM CT_HOADON
	WHERE SOHD = @sohd
	
	IF @sum IS NULL RETURN 0
	RETURN @sum
END

SELECT DBO.fn_TongTienHoaDon('N0002')

-- B Viết các thủ tục sau:

-- a. Cập nhật số lượng tồn của một mặt hàng khi nhập hàng hoặc xuất hàng

CREATE PROCEDURE use_CapNhatHangTon
	@MaHH char(5),
    @SoLuongCapNhat int
AS
BEGIN
	-- Cập nhật số lượng tồn của mặt hàng khi nhập hàng
    IF  (@MaHH LIKE 'N%')
    BEGIN
        UPDATE HANGHOA
        SET SOLUONGTON = SOLUONGTON + @SoLuongCapNhat
        WHERE MAHH = @MaHH;
    END

	IF (@MaHH LIKE 'X%')
    BEGIN
        UPDATE HANGHOA
        SET SOLUONGTON = SOLUONGTON - @SoLuongCapNhat
        WHERE MAHH = @MaHH;
    END
END

go
exec use_CapNhatHangTon 'CPU03', '2'
SELECT * FROM HANGHOA
-- b. Cập nhật tổng trị giá của một hoá đơn.

CREATE PROCEDURE use_CapNhatTongTriGia
	@SoHD char(5)
AS
BEGIN
	DECLARE @TongTriGia int
	
	SELECT @TongTriGia = SUM(SOLUONG * DONGIA)
	FROM CT_HOADON
	WHERE SOHD = @SoHD

	IF @TongTriGia IS NULL
	BEGIN
		PRINT N'Không tìm thấy hóa đơn'
		RETURN
	END

	UPDATE HOADON 
	SET TONGTG = @TongTriGia
	WHERE SOHD = @SoHD

	IF @@ROWCOUNT > 0
		PRINT N'Cập nhật thành công'
	ELSE
		PRINT N'Cập nhật không thành công'
END

go
exec use_CapNhatTongTriGia 'X0003';
SELECT * FROM HOADON

-- c. In đầy đủ thông tin của một hoá đơn

CREATE PROCEDURE use_InThongTinHoaDon
	@SoHD char(5)
AS
BEGIN
	IF NOT EXISTS ( SELECT SOHD FROM HOADON WHERE SOHD = @SoHD)
	BEGIN
		PRINT N'Không tìm thấy hóa đơn'
		RETURN
	END

	SELECT *
	FROM CT_HOADON AS CT
	INNER JOIN HOADON AS HD ON CT.SOHD = HD.SOHD
	WHERE CT.SOHD = @SoHD
END

go
exec use_InThongTinHoaDon 'X0003';
