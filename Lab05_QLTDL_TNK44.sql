/* Học phần: Cơ sở dữ liệu
   Người thực hiện: Trần Đạt Tín
   MSSV: 2011345
   Lớp: TNK44
   Ngày bắt đầu: 14/03/2023
   Ngày hoàn thiện: 22/04/2023
   Lab 05: Quản lý tour du lịch
*/	

----------ĐỊNH NGHĨA CƠ SỞ DỮ LIỆU----------------
CREATE DATABASE Lab05_QLDL -- lenh khai bao CSDL
go
--lenh su dung CSDL
use Lab05_QLDL

go

--lenh tao cac bang
create table Tour
(
	MaTour		char(4) primary key,		
	TongSoNgay	int
)

go

create table ThanhPho
(
	MaTP	char(2) primary key,		
	TenTP	nvarchar(30) not null
)

go

create table Tour_TP
(
	MaTour	char(4)  REFERENCES Tour(MaTour),
	MaTP	char(2)  REFERENCES ThanhPho(MaTP),		
	SoNgay	int

	primary key (MaTour, MaTP)
)
--drop table Tour_TP
go

create table Lich_TourDL
(
	MaTour			char(4) REFERENCES Tour(MaTour),
	NgayKhoihanh	datetime,		
	TenHDV          nvarchar(30),
	SoNguoi         int,
	TenKH			nvarchar(30)
	primary key (MaTour,NgayKhoiHanh)
)
--drop table Lich_TourDL
go

-------------NHAP DU LIEU CHO CAC BANG-----------
--Nhap du lieu cho cac bang
insert into Tour values('T001', 3)
insert into Tour values('T002', 4)
insert into Tour values('T003', 5)
insert into Tour values('T004', 7)

--xem bảng ToSanXuat
select * from Tour

--Nhap bang SamPham
insert into ThanhPho values('01',N'Đà Lạt')
insert into ThanhPho values('02',N'Nha Trang')
insert into ThanhPho values('03',N'Phan Thiết')
insert into ThanhPho values('04',N'Huế')
insert into ThanhPho values('05',N'Đà Nẵng')
--xem bảng SanPham
select * from ThanhPho
--Nhap bang CongNhan
set dateformat dmy
go
insert into Tour_TP values('T001', '01', 2)
insert into Tour_TP values('T001', '03', 1)
insert into Tour_TP values('T002', '01', 2)
insert into Tour_TP values('T002', '02', 2)
insert into Tour_TP values('T003', '02', 2)
insert into Tour_TP values('T003', '01', 1)
insert into Tour_TP values('T003', '04', 2)
insert into Tour_TP values('T004', '02', 2)
insert into Tour_TP values('T004', '05', 2)
insert into Tour_TP values('T004', '04', 3)
--xem bảng SanPham
select * from Tour_TP
--Nhap bang ThanhPham
set dateformat dmy
go
insert into Lich_TourDL values('T001','14/02/2017', N'Vân',  20, N'Nguyễn Hoàng')
insert into Lich_TourDL values('T002','14/02/2017', N'Nam',  30, N'Lê Ngọc')
insert into Lich_TourDL values('T002','06/03/2017', N'Hùng', 20, N'Lý Dũng')
insert into Lich_TourDL values('T003','18/02/2017', N'Dũng', 20, N'Lý Dũng')
insert into Lich_TourDL values('T004','18/02/2017', N'Hùng', 30, N'Dũng Nam')
insert into Lich_TourDL values('T003','10/03/2017', N'Nam',  45, N'Nguyễn An')
insert into Lich_TourDL values('T002','28/04/2017', N'Vân',  25, N'Ngọc Dung')
insert into Lich_TourDL values('T004','29/04/2017', N'Dũng', 35, N'Lê Ngọc')
insert into Lich_TourDL values('T001','30/04/2017', N'Nam',  25, N'Trần Nam')
insert into Lich_TourDL values('T003','15/06/2017', N'Vân',  20, N'Trịnh Bá')

select * from Lich_TourDL
----------------------------------------------------------------------

--(a) Cho biết các tour du lịch có tổng số ngày của tour từ 3 đến 5 ngày

SELECT *
FROM TOUR AS T
WHERE TongSoNgay >= 3 AND TongSoNgay <= 5

--(b) Cho biết thông tin các tour được tổ chức trong tháng 2 năm 2017

SELECT *
FROM Lich_TourDL AS LTD
WHERE YEAR(LTD.NgayKhoihanh) = 2017 AND MONTH(LTD.NgayKhoihanh) = 2

--(c) Cho biết các tour không đi qua thành phố 'Nha Trang'.

SELECT *
FROM Tour as TT2
WHERE TT2.MaTour not in (
	SELECT TT.MaTour
	FROM ThanhPho AS TP, Tour_TP AS TT
	WHERE TP.MaTP = TT.MATP AND TP.TenTP LIKE N'Nha Trang'
)

--(d) Cho biết số lượng thành phố mà mỗi hướng dẫn viên hướng dẫn.

SELECT LTD.TenHDV, COUNT(TP.MaTour) AS 'Số lượng thành phố'
FROM Lich_TourDL AS LTD, Tour_TP as TP
WHERE LTD.MaTour = TP.MaTour
GROUP BY LTD.TenHDV

--(e) Cho biết số lượng tour du lịch mỗi hướng dẫn viên hướng dẫn.

SELECT LTD.TenHDV, COUNT(LTD.MaTour) AS  N'Số lượng tour'
FROM Lich_TourDL AS LTD
GROUP BY LTD.TenHDV

--(f) Cho biết tên thành phố có nhiều tour du lịch đi qua nhất.

SELECT TP.TenTP, COUNT(TTP.MaTour) N'Số tour'
FROM ThanhPho AS TP, Tour_TP AS TTP
WHERE TP.MaTP = TTP.MaTP
GROUP BY TP.MaTP,TP.TenTP
HAVING COUNT(TTP.MaTour) >= all (
	SELECT COUNT(TTP.MaTour)
	FROM ThanhPho AS TP, Tour_TP AS TTP
	WHERE TP.MaTP = TTP.MaTP
	GROUP BY TP.MaTP,TP.TenTP
)

--(g) Cho biết thông tin của tour du lịch đi qua tất cả các thành phố.

SELECT T.MaTour, T.TongSoNgay, COUNT(TTP.MATP)
FROM Tour_TP AS TTP, Tour AS T
WHERE  T.MaTour = TTP.MaTour
GROUP BY T.MaTour, T.TongSoNgay
HAVING COUNT(TTP.MaTP) = (
	SELECT COUNT(TP.MaTP)
	FROM ThanhPho AS TP
)

--(h) Lập danh sách các tour đi qua thành phố 'Đà Lạt', thông tin cần hiển thị bao gồm: Mã tour, So Ngay.

SELECT *
FROM ThanhPho AS TP, Tour_TP AS TTP
WHERE TP.MaTP = TTP.MaTP AND TenTP = N'Đà Lạt'

--(i) Cho biết thông tin của tour du lịch có tổng số lượng khách tham gia nhiều nhất.

SELECT LTDL2.MaTour
FROM Lich_TourDL AS LTDL2
GROUP BY LTDL2.MaTour
HAVING SUM(LTDL2.SoNguoi) >=all (
	SELECT SUM(LTDL.SoNguoi)
	FROM Lich_TourDL AS LTDL
	GROUP BY MaTour
)

--(j) Cho biết tên thành phố mà tất cả các tour du lịch đều đi qua.

SELECT TP2.MaTP, COUNT(TTP2.MaTP) AS N'Số tour du lịch đi qua'
FROM ThanhPho AS TP2, Tour_TP AS TTP2
WHERE TP2.MaTP = TTP2.MaTP
GROUP BY TP2.MaTP
HAVING COUNT(TTP2.MaTP) >=all (
	SELECT COUNT(T.MATour)
	FROM Tour AS T
)
