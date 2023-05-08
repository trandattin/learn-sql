/* Học phần: Cơ sở dữ liệu
   Người thực hiện: Trần Đạt Tín
   MSSV: 2011345
   Lớp: TNK44
   Ngày bắt đầu: 14/03/2023
   Ngày hoàn thiện: 22/04/2023
   Lab 02: Quản lý sản xuất
*/	
----------ĐỊNH NGHĨA CƠ SỞ DỮ LIỆU----------------
CREATE DATABASE Lab02_QLSX -- lenh khai bao CSDL

go
use Lab02_QLSX

--1) Tạo các table và thiết lập mối quan hệ giữa các Table. Dựa vào dữ liệu mẫu, sinh viên tự chọn 
-- kiểu dữ liệu phù hợp cho các field của các bảng

go
create table ToSanXuat
(
	MATSX char(4) primary key,
	TenTSX nvarchar(5)
)

--2
go 
create table SanPham
(
	MASP char(5) primary key,
	TenSP nvarchar(30),
	DVT nvarchar(10),
	TienCong int,
)

--3
go 
create table CongNhan
(
	MACN char(5) primary key,		 
	Ho	nvarchar(30) not null,
	Ten nvarchar(10) not null,
	Phai nvarchar(5),
	NgaySinh datetime,
	MaTSX char(4) references ToSanXuaT(MaTSX)
)

--4
go 
create table ThanhPham
(
	MACN char(5) references CongNhan(MACN),
	MASP char(5) references SanPham(MASP),
	Ngay datetime,
	Soluong int,
	primary key(MACN,MASP,Ngay)
)

--2) Cài đặt các RBTV sau:
-- a) Tiền công > 0.

ALTER TABLE SanPham
ADD CONSTRAINT CK_SanPham_TienCong CHECK (TienCong > 0);
 
-- b) Tên tổ sản xuất phải phân biệt.
ALTER TABLE ToSanXuat
ADD CONSTRAINT UQ_ToSanXuat_TenTSX UNIQUE (TenTSX);

-- c) Tên sản phẩm phải khác nhau.

ALTER TABLE SanPham
ADD CONSTRAINT UQ_SanPham_TenSP UNIQUE (TenSP);

-- d) Số lượng phải nguyên dương.

ALTER TABLE ThanhPham
ADD CONSTRAINT CK_ThanhPham_SoLuong CHECK (Soluong > 0);

-------------NHAP DU LIEU CHO CAC BANG-----------
--Nhập dữ liệu cho bảng Tổ Sản Xuất
insert into ToSanXuat values('TS01', N'Tổ 1')
insert into ToSanXuat values('TS02', N'Tổ 2')

--xem bảng Chi nhánh
select * from ToSanXuat

insert into SanPham values('SP001',N'Nồi đất',N'cái',10000)
insert into SanPham values('SP002',N'Chén',N'cái',2000)
insert into SanPham values('SP003',N'Bình gốm nhỏ',N'cái',20000)
insert into SanPham values('SP004',N'Bình gốm lớn',N'cái',25000)

select * from SanPham

--Nhập dữ liệu cho bảng Công Nhân
set dateformat dmy
go
insert into CongNhan values ('CN001',N'Nguyễn Trường',N'An',N'Nam','12/05/1981','TS01')
insert into CongNhan values ('CN002',N'Lê Thị Hồng',N'Gấm',N'Nữ','04/06/1980','TS01')
insert into CongNhan values ('CN003',N'Nguyễn Công',N'Thành',N'Nam','04/05/1981','TS02')
insert into CongNhan values ('CN004',N'Võ Hữu',N'Hạnh',N'Nam','15/02/1980','TS02')
insert into CongNhan values ('CN005',N'Lý Thanh',N'Hân',N'Nữ','03/12/1981','TS01')

select * from CongNhan

--Nhập dữ liệu cho bảng Sản Phẩm
set dateformat dmy
go
insert into ThanhPham values('CN001','SP001','01/02/2007',10)
insert into ThanhPham values('CN002','SP001','01/02/2007',5)
insert into ThanhPham values('CN003','SP002','10/01/2007',50)
insert into ThanhPham values('CN004','SP003','12/01/2007',10)
insert into ThanhPham values('CN005','SP002','12/01/2007',100)
insert into ThanhPham values('CN002','SP004','13/02/2007',10)
insert into ThanhPham values('CN001','SP003','14/02/2007',15)
insert into ThanhPham values('CN003','SP001','15/01/2007',20)
insert into ThanhPham values('CN003','SP004','14/02/2007',15)
insert into ThanhPham values('CN004','SP002','30/01/2007',100)
insert into ThanhPham values('CN005','SP003','01/02/2007',50)
insert into ThanhPham values('CN001','SP001','20/02/2007',30)

select * from ThanhPham
--delete from ThanhPham
--Xem tất cả các quan hệ có trong CSDL
select * from ToSanXuat
select * from SanPham
select * from CongNhan
select * from ThanhPham

-----------------------------------------QUERY----------------------------------------
--Cau 1: Liệt kê các công nhân theo tổ sản xuất gồm: TenTSX, HoTen, NgaySinh, Phai
--(xếp thứ tự tăng dần của tên tổ sản xuất, tên của công nhân)
select B.TenTSX, A.Ho + ' ' + A.Ten as HoTen, A.NgaySinh, A.Phai
from CongNhan as A, ToSanXuat as B
where B.MATSX = A.MaTSX
order by B.TenTSX, A.Ten

--Câu 2: Liệt kê các thành phẩm mà công nhân 'Nguyễn tường An' đã làm được gồm các thông tin
--Tên SP, Ngay, So Luong, Thanh Tien (Xếp theo thu tự tăng dần của ngày)
select TenSP, Ngay, Soluong, Soluong*TienCong as ThanhTien
from SanPham as A, ThanhPham as B, CongNhan as C
where A.MASP = B.MASP and C.MACN = B.MACN and C.Ho = N'Nguyễn Trường' and C.Ten = N'An'

--Câu 3: Liệt kê các công nhân không sản xuất sản phẩm 'Bình gốm lớn'
select Ho + ' ' + Ten as HoTen, A.MACN
from CongNhan as A --, SanPham as B, ThanhPham as C (Dư)
where /*B.MASP = C.MASP and A.MACN = C.MACN and (DƯ) */ A.MACN not in (
	select C.MACN
	from SanPham as B, ThanhPham as C
	where B.MASP = C.MASP and TenSP = N'Bình gốm lớn'
)
--group by A.MACN, A.Ho, A.Ten (Dư)

--Câu 4: Liệt kê thông tin các công nhân có sản xuất cả 'Nồi đất' và 'Bình gốm nhỏ'
select distinct Ho + ' ' + Ten as HoTen
from CongNhan as A, SanPham as B, ThanhPham as C
where A.MACN = C.MACN and B.MASP = C.MASP and B.TenSP = N'Nồi Đất' and A.MACN in (
	select F.MACN
	from SanPham as E, ThanhPham as F
	where E.MASP = F.MASP and E.TenSP = N'Bình gốm nhỏ'
)

--Câu 5: Thống kê Số lượng công nhân theo từng tổ sản xuất
select TenTSX as N'Tên tổ sản xuất', count(MACN) as N'Số lượng'
from CongNhan as A, ToSanXuat as B
where A.MaTSX = B.MATSX
group by TenTSX

--Câu 6: Tổng số lượng thành phẩm theo từng loại mà mỗi nhân viên làm được (Ho,Ten,TenSP,TongSoluongSP,TongThanhTien)
select Ho + ' ' + Ten as N'Họ Tên', TenSP, sum(Soluong) as TongSoLuongSP, sum(B.Soluong*C.TienCong) as TongThanhTien
from CongNhan as A, ThanhPham as B, SanPham as C
where B.MACN = A.MACN and C.MASP = B.MASP
Group by Ten,Ho,TenSP

--Câu 7: Tổng số tiền công đã trả cho công nhân trong tháng 1 năm 2007
select A.MACN, sum(A.Soluong*B.TienCong) as TongThanhTien
from ThanhPham as A, SanPham as B
where A.MASP = B.MASP and Month(A.Ngay) = 1 and YEAR(A.Ngay) = 2007
Group by A.MACN

--Câu 8: Cho biết sản phẩm được sản xuất nhiều nhất trong tháng 2/2007
SELECT TenSP as N'Tên Sản Phẩm'
FROM ThanhPham AS A, SanPham AS B
WHERE A.MASP = B.MASP AND MONTH(A.Ngay) = 2 AND YEAR(A.Ngay) = 2007
GROUP BY TenSP
HAVING SUM(A.Soluong) >=all (
	SELECT SUM(F.Soluong)
	FROM ThanhPham as F
	WHERE MONTH(F.Ngay) = 2 AND YEAR(F.Ngay) = 2007
	GROUP BY F.MASP)

--Câu 9: Cho biết công nhân sản xuất được nhiều 'Chén' nhất
SELECT CN.Ho + ' ' + CN.Ten AS N'Họ Tên', SUM(TP.Soluong)
FROM CongNhan AS CN, SanPham AS SP, ThanhPham AS TP
WHERE CN.MaCN = TP.MaCN AND SP.MaSP = Tp.MaSP AND TenSP = 'Chén'
GROUP BY CN.Ho, CN.Ten
HAVING SUM(TP.Soluong) >=ALL 
(
	SELECT SUM(TP2.Soluong)
	FROM ThanhPham AS TP2, SanPham AS SP2
	WHERE TP2.MaSP = SP2.MaSP AND TenSP = 'Chén'
	GROUP BY TP2.MACN
)

--Câu 10: Tiền Công Tháng 2/2007 của công nhân viên có mã số 'CN002'
SELECT SUM(SP.TienCong*TP.Soluong) as N'Tiền Công của CN002'
FROM SanPham AS SP, ThanhPham as TP
WHERE SP.MASP = TP.MASP AND MONTH(Ngay) = 2 AND YEAR(NGAY) = 2007 AND TP.MACN = 'CN002'

--Câu 11: Liệt kê các công nhân có sản xuất từ 3 loại sản phẩm trở lên
SELECT Ho + ' ' + Ten as N'Họ Tên', COUNT(SP.MASP) as 'Số Sản Phẩm'
FROM CongNhan AS CN, ThanhPham AS TP, SanPham AS SP
WHERE SP.MASP = TP.MASP AND CN.MACN = TP.MACN
GROUP BY Ho, Ten
HAVING COUNT(SP.MASP) = 3

--Câu 12: Cập nhật giá tiền công của các loại bình gốm thêm 1000.
--UPDATE SanPham
--SET TienCong = TienCong + 1000
--WHERE TenSP LIKE N'Bình gốm'

--Câu 13: Thêm bộ <'CN006','Lệ Thị','Lan','Nữ','TS02'> vào bảng CongNhan
INSERT INTO CongNhan VALUES ('CN006', N'Lệ Thị', N'Lan', N'Nữ', NULL, 'TS02')
SELECT *
FROM CongNhan

------------------------------III.Thủ tục & Hàm---------------------------------
-- A. Viết các hàm sau:
-- a. Tính tổng số công nhân của một tổ sản xuất cho trước.

CREATE FUNCTION fn_TongSoCongNhan(@MaTSX char(4))
RETURNS int
AS
BEGIN
	DECLARE @sum int = 0
	
	IF NOT EXISTS (SELECT MaTSX FROM CongNhan WHERE MaTSX = @MaTSX)
		RETURN -1
	SELECT @sum = COUNT(MaTSX)
	FROM CongNhan 
	WHERE MATSX = @MaTSX

	IF @sum IS NULL
		RETURN 0
	ELSE
		RETURN @sum
END

SELECT * FROM CongNhan

SELECT DBO.fn_TongSoCongNhan('TS03') AS N'Tổng số lượng công nhân theo mã tổ sản xuất';


-- b. Tính tổng số lượng sản xuất trong một tháng của một loại sản phẩm cho trước

CREATE FUNCTION fn_TongSanPham(@masp char(5), @thang char(2), @nam char(4))
RETURNS int
AS
BEGIN
	DECLARE @sum int = 0

	IF NOT EXISTS (SELECT MaSP FROM SanPham WHERE MaSP = @masp)
		RETURN -1

	SELECT @sum = SUM(TP.Soluong)
	FROM ThanhPham AS TP
	INNER JOIN SanPham AS SP ON SP.MASP = TP.MASP
	WHERE SP.MASP = @masp AND MONTH(TP.Ngay) = @thang AND YEAR(TP.Ngay) = @nam

	IF @sum IS NULL
		RETURN 0
	RETURN @sum
END

SELECT DBO.fn_TongSanPham('SP001','02','2007') AS N'Tổng số lượng sản phẩm theo tháng và năm cho trước';

-- c. Tính tổng tiền công tháng của một công nhân cho trước.

ALTER FUNCTION fn_TongTienCong(@macn char(5), @thang char(2), @nam char(4))
RETURNS int
AS
BEGIN
	DECLARE @sum int 
	IF NOT EXISTS (SELECT MACN FROM ThanhPham WHERE MACN = @macn)
		RETURN -1
	SELECT @sum = SUM(SP.TienCong*TP.Soluong)
	FROM ThanhPham AS TP
	INNER JOIN CongNhan AS CN ON TP.MACN = CN.MACN
	INNER JOIN SanPham AS SP ON SP.MASP = TP.MASP
	WHERE @macn = TP.MACN AND @nam = YEAR(TP.Ngay) AND @thang = MONTH(TP.Ngay)
	IF @sum IS NULL
		RETURN 0
	RETURN @sum
END

SELECT DBO.fn_TongTienCong('CN001','02','2007') AS N'Tổng số lượng sản phẩm theo tháng và năm cho trước';

SELECT * FROM ThanhPham
-- d. Tính tổng thu nhập trong năm của một tổ sản xuất cho trước.

CREATE FUNCTION fn_TongThuNhap(@MaTSX char(4), @nam char(4))
RETURNS int
AS
BEGIN
	DECLARE @sum int
	IF NOT EXISTS (SELECT MaTSX FROM ToSanXuat WHERE MaTSX = @MaTSX)
		RETURN -1
	SELECT @sum = SUM(SP.TienCong*TP.Soluong)
	FROM ThanhPham AS TP
	INNER JOIN CongNhan AS CN ON TP.MACN = CN.MACN
	INNER JOIN SanPham AS SP ON SP.MASP = TP.MASP
	WHERE @MaTSX = CN.MaTSX AND @nam = YEAR(TP.Ngay) 
	IF @sum IS NULL
		RETURN 0
	RETURN @sum
END

SELECT DBO.fn_TongThuNhap('TS01','2007') AS 'Tổng thu nhập của Tổ theo năm cho trước';

-- e. Tính tổng sản lượng sản xuất của một loại sản phẩm trong một khoảng thời gian cho trước


CREATE FUNCTION fn_TongSanLuong (@masp char(5), @nbd datetime, @nkt datetime)
RETURNS int
AS
BEGIN
	DECLARE @sum int
	IF (@nbd > @nkt)
        RETURN 0

	IF NOT EXISTS (SELECT MASP FROM SANPHAM WHERE @masp = MASP)
		RETURN -1
	SELECT @sum = SUM(TP.Soluong)
	FROM ThanhPham AS TP
	WHERE @masp = TP.MaSP AND TP.Ngay BETWEEN @nbd AND @nkt
	IF @sum IS NULL
		RETURN 0
	RETURN @sum
END

set dateformat dmy
SELECT DBO.fn_TongSanLuong('SP001','01/02/2007','02/02/2007')
-- B. Viết các thủ tục sau:

-- a. In danh sách các công nhân của một tổ sản xuất cho trước

CREATE PROCEDURE use_InCongNhan
	@MaTSX char(4)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM CongNhan WHERE MaTSX = @MaTSX)
	BEGIN
		PRINT(N'Không tồn tại tổ sản xuất đã cho')
		RETURN
	END
	SELECT *
	FROM CongNhan AS CN
	WHERE CN.MaTSX = @MaTSX
END

exec use_InCongNhan 'TS01';


-- b. In bảng chấm công sản xuất trong một tháng của một công nhân cho trước (bao gồm Tên sản phẩm, đơn vị tính,
-- ,số lượng sản xuất trong tháng, đơn giá, thành tiền).

ALTER PROCEDURE use_BangChamCong 
	@mscn char(5)
AS
BEGIN
	IF NOT EXISTS (SELECT MACN FROM ThanhPham WHERE MACN = @mscn)
	BEGIN
		PRINT(N'Không tồn tại tổ sản xuất đã cho')
		RETURN
	END
	SELECT TP.MASP, SP.DVT, SP.TienCong,MONTH(TP.Ngay), YEAR(TP.Ngay), SUM(SP.TienCong*TP.SoLuong)
	FROM SanPham AS SP
	INNER JOIN ThanhPham AS TP ON TP.MASP = SP.MASP
	WHERE TP.MACN = @mscn
	GROUP BY MONTH(TP.Ngay), YEAR(TP.Ngay), TP.MASP, SP.DVT, SP.TienCong
END

exec use_BangChamCong 'CN002'