/* Học phần: Cơ sở dữ liệu
   Người thực hiện: Trần Đạt Tín
   MSSV: 2011345
   Lớp: TNK44
   Ngày bắt đầu: 14/03/2023
   Ngày hoàn thiện: 25/04/2023
   Lab 07: Quản lý sinh viên
*/	
----------ĐỊNH NGHĨA CƠ SỞ DỮ LIỆU----------------
CREATE DATABASE Lab07_QLSV -- lenh khai bao CSDL

go
--lenh su dung CSDL
use Lab07_QLSV

-- I. XÂY DỰNG CƠ SỞ DỮ LIỆU

create table Khoa
(
	MSKhoa		char(2) primary key,		
	TenKhoa	nvarchar(50) not null,
	TenTat	nvarchar(4) not null
)
go

create table Lop

(
	MSLop	 char(4) primary key,
	TenLop	 nvarchar(50) not null,		
	MSKhoa   char(2) not null ,
	NienKhoa int
)

go

create table Tinh

(
	MSTinh	 char(2) primary key,
	TenTinh	 nvarchar(30) not null
)

go

create table MonHoc

(
	MSMH	 char(4) primary key,
	TenMH	 nvarchar(50) not null,
	HeSo	 int not null
)

go

create table BangDiem

(
	MSSV	 char(7) not null REFERENCES SinhVien(MSSV),
	MSMH	 char(4) not null REFERENCES Monhoc(MSMH),
	LanThi	 int     not null,
	Diem	 float   not null
	primary key (MSSV, MSMH,LanThi)
)
go

create table SinhVien
(
	MSSV		char(7) primary key,
	Ho			nvarchar(30) not null,
    Ten			nvarchar(30) not null,
	NgaySinh	datetime not null,
	MSTinh		char(2) not null,
	NgayNhapHoc	datetime not null,
	MSLop		char(4) not null,
	Phai        nvarchar(3),
	DiaChi		nvarchar(50),
	DienThoai   varchar(16)
)
go

insert into Khoa values('01', N'Công nghệ thông tin', 'CNTT')
insert into Khoa values('02', N'Điện tử viễn thông',  'DTVT')
insert into Khoa values('03', N'Quản trị kinh doanh', 'QTKD')
insert into Khoa values('04', N'Công nghệ sinh học',  'CNSH')
select * from Khoa

insert into Lop values('98TH', N'Tin hoc khoa 1998',    '01', 1998)
insert into Lop values('98VT', N'Vien thong khoa 1998', '02', 1998)
insert into Lop values('99TH', N'Tin hoc khoa 1999',    '01', 1999)
insert into Lop values('99VT', N'Vien thong khoa 1999', '02', 1999)
insert into Lop values('99QT', N'Quan tri khoa 1999',   '03', 1999)
select * from Lop

insert into Tinh values('01', N'An Giang')
insert into Tinh values('02', N'TPHCM')
insert into Tinh values('03', N'Dong Nai')
insert into Tinh values('04', N'Long An')
insert into Tinh values('05', N'Hue')
insert into Tinh values('06', N'Ca Mau')
select * from Tinh

insert into MonHoc values('TA01', N'Nhan mon tin hoc',    2)
insert into MonHoc values('TA02', N'Lap trinh co ban',    3)
insert into MonHoc values('TB01', N'Cau truc du lieu',    2)
insert into MonHoc values('TB02', N'Co so du lieu',       2)
insert into MonHoc values('QA01', N'Kinh te vi mo',       2)
insert into MonHoc values('QA02', N'Quan tri chat luong', 3)
insert into MonHoc values('VA01', N'Dien tu co ban',      2)
insert into MonHoc values('VA02', N'Mach so',             3)
insert into MonHoc values('VB01', N'Truyen so lieu',      3)
insert into MonHoc values('XA01', N'Vat ly dai cuong',    2)
select * from MonHoc

insert into BangDiem values('98TH001', 'TA01', 1, 8.5)
insert into BangDiem values('98TH001', 'TA02', 1, 8)
insert into BangDiem values('98TH002', 'TA01', 1, 4)
insert into BangDiem values('98TH002', 'TA01', 2, 5.5)
insert into BangDiem values('98TH001', 'TB01', 1, 7.5)
insert into BangDiem values('98TH002', 'TB01', 1, 8)
insert into BangDiem values('98VT001', 'VA01', 1, 4)
insert into BangDiem values('98VT001', 'VA01', 2, 5)
insert into BangDiem values('98VT002', 'VA02', 1, 7.5)
insert into BangDiem values('99TH001', 'TA01', 1, 4)
insert into BangDiem values('99TH001', 'TA01', 2, 6)
insert into BangDiem values('99TH001', 'TB01', 1, 6.5)
insert into BangDiem values('99TH002', 'TB01', 1, 10)
insert into BangDiem values('99TH002', 'TB01', 1, 9)
insert into BangDiem values('99TH003', 'TA02', 1, 7.5)
insert into BangDiem values('99TH003', 'TB01', 1, 3)
insert into BangDiem values('99TH003', 'TB01', 2, 6)
insert into BangDiem values('99TH003', 'TB02', 1, 8)
insert into BangDiem values('99TH004', 'TB02', 1, 2)
insert into BangDiem values('99TH004', 'TB02', 2, 4)
insert into BangDiem values('99TH004', 'TB02', 3, 3)
insert into BangDiem values('99QT001', 'QA01', 1, 7)
insert into BangDiem values('99QT001', 'QA02', 1, 6.5)
insert into BangDiem values('99QT002', 'QA01', 1, 8.5)
insert into BangDiem values('99QT002', 'QA02', 1, 9)
select * from BangDiem

set dateformat dmy
go
insert into SinhVien values('98TH001', N'Nguyen Van',  N'An',    '06/08/80', '01', '03/09/98', '98TH', 'Yes', '12 Tran Hung Dao, Q.1',   '8234512') 
insert into SinhVien values('98TH002', N'Le Thi',      N'An',    '17/10/79', '01', '03/09/98', '98TH', 'No',  '12 CMT8, Q.Tan Binh',     '0303234342')
insert into SinhVien values('98VT001', N'Nguyen Duc',  N'Binh',  '25/11/81', '02', '03/09/98', '98VT', 'Yes', '12 Lac Long Quan, Q.11',  '8234512') 
insert into SinhVien values('98VT002', N'Tran Ngoc',   N'Anh',   '19/08/80', '02', '03/09/98', '98VT', 'No',  '12 Tran Hung Dao, Q.1',    NULL)
insert into SinhVien values('99TH001', N'Ly Van Hung', N'Dung',  '27/09/81', '03', '05/10/99', '99TH', 'Yes', '12 CMT8, Q.Tan Binh',     '8234512') 
insert into SinhVien values('99TH002', N'Van Minh',    N'Hoang', '01/01/81', '04', '05/10/99', '99TH', 'Yes', '12 Ly Thuong Kiet, Q.10', '8234512') 
insert into SinhVien values('99TH003', N'Nguyen', 	   N'Tuan',  '12/01/80', '03', '05/10/99', '99TH', 'Yes', '12 Tran Hung Dao, Q.5',    NULL)
insert into SinhVien values('99TH004', N'Tran Van',    N'Minh',  '25/06/81', '04', '05/10/99', '99TH', 'Yes', '12 Dien Bien Phu, Q.3',   '8234512') 
insert into SinhVien values('99TH005', N'Nguyen Thai', N'Minh',  '01/01/80', '04', '05/10/99', '99TH', 'Yes', '12 Le Dai Hanh, Q.11',     NULL)
insert into SinhVien values('99VT001', N'Le Ngoc',     N'Mai',   '21/06/82', '01', '05/10/99', '99VT', 'No',  '12 Tran Hung Dao, Q.1',   '0903124534')
insert into SinhVien values('99QT001', N'Nguyen Thi',  N'Oanh',  '19/08/73', '04', '05/10/99', '99QT', 'No',  '12 Hung Vuong, Q.5',      '0901656324')
insert into SinhVien values('99QT002', N'Le My',       N'Thanh', '20/05/76', '04', '05/10/99', '99QT', 'No',  '12 Pham Ngoc Thach, Q.3',  NULL)
select * from SinhVien
----------------------------------------------------------------------
-- II. TRUY VẤN DỮ LIỆU

--1) Liệt kê MSSV, Họ, Tên, Địa chỉ của tất cả các sinh viên

SELECT SV.MSSV, SV.Ho, SV.Ten, SV.DiaChi
FROM SinhVien AS SV

--2) Liệt kê MSSV, Họ Tên, MS Tỉnh của tất cả các sinh viên. Sắp xếp kết quả theo MS tỉnh, trong cùng tỉnh sắp xếp theo họ tên của sinh viên

SELECT SV.MSSV, SV.Ho + ' ' + SV.Ten AS N'Họ Tên', T.MSTinh 
FROM SinhVien AS SV, Tinh AS T
WHERE T.MSTinh = SV.MSTinh
ORDER BY MSTinh ASC, Ho ASC, Ten ASC;

--3) Liệt kê các sinh viên nữ của tỉnh Long An

SELECT SV.*
FROM SINHVIEN AS SV, Tinh AS T
WHERE SV.MSTinh = T.MSTinh AND SV.PHAI = 'No' AND T.TenTinh = N'Long An'

--4) Liệt kê các sinh viên có sinh nhật trong tháng giêng

SELECT SV.*
FROM SINHVIEN AS SV
WHERE MONTH(SV.NgaySinh) = 01

--5) Liệt kê các sinh viên có sinh nhật nhằm ngày 1/1

SELECT SV.*
FROM SINHVIEN AS SV
WHERE MONTH(SV.NgaySinh) = 01 AND DAY(SV.NgaySinh) = 01 

--6) Liệt kê các sinh viên có số điện thoại

SELECT SV.*
FROM SINHVIEN AS SV
WHERE SV.DienThoai IS NOT NULL

--7) Liệt kê các sinh viên có số điện thoại di động

SELECT *
FROM SINHVIEN 
WHERE SINHVIEN.DienThoai like '09%' or SinhVien.DienThoai LIKE '01%'

--8) Liệt kê các sinh viên tên `Minh' học lớp `99TH'

SELECT *
FROM SinhVien
WHERE SinhVien.Ten = 'Minh' AND SinhVien.MSLop = '99TH'

--9) Liệt kê cac sinh viên có địa chỉ ở đường `Tran Hung Dao'

SELECT *
FROM SinhVien
WHERE SinhVien.DiaChi LIKE '%Tran Hung Dao%'

--10) Liệt kê các sinh viên có tên lót chữ `Van' (không liệt kê người họ `Van')

SELECT * FROM SinhVien WHERE Ho LIKE '%Van%'

--11) Liệt kê MSSV Họ, Tên (Ghép họ và tên thành một cột), Tuổi của các sinh viên ở tỉnh Long An.

SELECT
	sv.MSSV,
	sv.Ho + ' ' + sv.Ten AS N'Họ Tên',
	YEAR(GETDATE ()) - YEAR(NgaySinh) AS Tuoi
FROM
	SinhVien AS sv
	JOIN Tinh AS t ON sv.MSTinh = t.MSTinh
WHERE
	t.TenTinh = N'Long An';

--12) Liệt kê các sinh viên nam từ 23 đến 28 tuổi.

SELECT 
		*, 
		YEAR(GETDATE()) - YEAR(NgaySinh) AS N'Tuổi'
FROM 
		SinhVien
WHERE
		Phai = 'Yes'
		AND YEAR (GETDATE()) - YEAR(NgaySinh) >= 40 
		AND YEAR (GETDATE()) - YEAR(NgaySinh) <= 45

--13) Liệt kê các sinh viên nam từ 32 tuổi trở lên và các sinh viên nữ từ 27 trở lên.

SELECT 
		*, 
		YEAR(GETDATE()) - YEAR(NgaySinh) AS N'Tuổi'
FROM 
		SinhVien
WHERE
		   (Phai = 'Yes' AND YEAR (GETDATE()) - YEAR(NgaySinh) >= 40)
		OR (Phai = 'No'  AND YEAR (GETDATE()) - YEAR(NgaySinh) >= 32)

--14) Liệt kê các sinh viên khi nhập học còn dưới 18 tuổi, hoặc đã trên 25 tuổi.

SELECT 
		*,
		YEAR(NgayNhapHoc) - YEAR (NgaySinh) AS Tuoi
FROM 
		SinhVien
WHERE 
		   YEAR(NgayNhapHoc) - YEAR (NgaySinh) < 19
		OR YEAR(NgayNhapHoc) - YEAR (NgaySinh) > 25
ORDER BY 
		Tuoi;

--15) Liệt kê danh sách các sinh viên của khối 99 (MSSV có 2 ký tự đầu là '99').

SELECT * FROM SinhVien WHERE MSSV LIKE '98%'

--16) Liệt kê MSSV, Điểm thi lần 1 mô `Cơ sở dữ liệu' của lớp `99TH'

SELECT
		sv.MSSV,
		bd.Diem
FROM 
		SinhVien AS sv
		JOIN BangDiem AS bd ON sv.MSSV = bd.MSSV
		JOIN MonHoc AS mh ON mh.MSMH = bd.MSMH
WHERE
		bd.LanThi = 1 
		AND mh.TenMH = 'Co so du lieu'
		AND sv.MSLop LIKE '99TH%';

--17) Liệt kê MSSV, Họ tên của các sinh viên lớp `99TH' thi không đạt lần 1 môn `Cơ sở dữ liệu'

SELECT
		sv.MSSV,
		sv.Ho + ' ' + sv.Ten AS N'Họ Tên',
		bd.Diem,
		bd.MSMH
FROM 
		SinhVien as sv
		JOIN BangDiem AS bd ON bd.MSSV = sv.MSSV
WHERE
		sv.MSLop = '99TH'
		AND bd.Diem < 5
		AND bd.MSMH = 'TB02';

--18) Liệt kê các điểm thi của sinh viên có mã số `99TH001' theo mẫu sau:
-- MSMH - Tên MH - Lần thi - Điểm

SELECT
		mh.MSMH,
		mh.TenMH,
		bd.Lanthi,
		bd.Diem
FROM 
		SinhVien AS sv
		JOIN BangDiem AS bd ON bd.MSSV = sv.MSSV
		JOIN MonHoc AS mh ON mh.MSMH = bd.MSMH
WHERE
		sv.MSSV = '99TH001';

--19) Liệt kê MSSV, họ tên, MSLop của các sinh viên có điểm thi lần 1 môn `Cơ sở dữ liệu' từ 8 điểm trở lên.

SELECT 
		sv.MSSV, 
		sv.Ho + ' ' + sv.Ten AS HoTen, 
		sv.MSLop, 
		bd.Diem
FROM 
		Sinhvien AS sv
		JOIN BangDiem AS bd ON bd.MSSV = sv.MSSV
		JOIN MonHoc AS mh ON mh.MSMH = bd.MSMH
WHERE
		mh.TenMH = 'Co so du lieu'
		AND bd.Diem >= 8
		AND bd.LanThi = 1;

--20) Liệt kê các tỉnh không có sinh viên theo học.

SELECT 
		*
FROM 
		Tinh
WHERE 
		MSTinh NOT IN (
SELECT 
		MSTinh
FROM 
		SinhVien);

--21) Liệt kê các sinh viên hiện chưa có điểm môn thi nào.
SELECT 
		*
FROM 
		SinhVien
WHERE
		MSSV NOT IN (
SELECT DISTINCT 
		MSSV
FROM 
		BangDiem
);
--22) Thống kê số lượng sinh viên ở mỗi lớp theo mẫu sau: MSLop, TenLop, SoLuongSV

SELECT 
		l.MSLop, 
		l.TenLop, 
		COUNT(sv.MSSV) AS SoLuongSV
FROM 
		SinhVien AS sv 
		JOIN Lop AS l ON l.MSLop = sv.MSLop
GROUP BY 
		l.MSLop, 
		l.TenLop
ORDER BY count(*);

--23) Thống kê số lượng sinh viên ở mỗi tỉnh theo mẫu sau: MSTinh, Số SV Nam, Số SV Nữ, Tổng cộng

SELECT 
		t.MSTinh, 
		t.TenTinh, 
		COUNT(
				CASE WHEN sv.Phai = 'Yes' THEN
						1
				END) AS "SoSVNam",
		COUNT (
				CASE WHEN sv.Phai = 'No' THEN
						1
				END) AS "SoSVNu",
		COUNT(MSSV) AS "TongSoSV"
FROM 
		SinhVien AS sv 
		JOIN Tinh AS t ON sv.MSTinh = t.MSTinh
GROUP BY t.MSTinh, 
		 t.TenTinh
ORDER BY COUNT(*);

--24) Thống kê kết quả thi lần 1 môn 'Co so du lieu' theo mẫu sau: MSLop, TenLop, SoSVdat, TiLeDat (%),
-- Số sinh viên không đạt, tỉ lệ không đạt

SELECT 
		l.MSLop, 
		l.TenLop, 
		COUNT(CASE WHEN bd.Diem >= 5 Then 1 END) AS "SoSVDat",
		CAST(COUNT(CASE WHEN bd.Diem >= 5 THEN 1 END) AS float)/COUNT(*)*100 AS "TiLeDat",
		COUNT(CASE WHEN bd.Diem <  5 THEN 1 END) AS "SoSVKhongDat",
		CAST(COUNT(CASE WHEN bd.Diem <  5 THEN 1 END) AS float)/COUNT(*)*100 AS "TiLeKhongDat"
FROM 
		SinhVien AS sv 
		JOIN BangDiem AS bd ON bd.MSSV = sv.MSSV
		JOIN MonHoc AS mh ON mh.MSMH = bd.MSMH
		JOIN Lop AS l ON l.MSLop = sv.MSLop
GROUP BY 
		l.MSLop, l.TenLop

--25) Lọc ra điểm cao nhất trong các lần thi cho các sinh viên theo mẫu sau (điểm in ra của mỗi môn là điểm
-- cao nhất trong các lần thi của môn đó):
-- MSSV, MSMH, TenMH, HeSo, Diem, Diem x hệ số

SELECT
	bd.MSSV, 
	mh.MSMH, 
	mh.TenMH, 
	mh.HeSo, 
	MAX(bd.Diem) AS N'Điểm cao nhất', 
	MAX(bd.Diem) * mh.HeSo AS N'Điểm cao nhất x Hệ Số'
FROM 
		Bangdiem AS bd
		JOIN MonHoc AS mh ON bd.MSMH = mh.MSMH
GROUP BY
		bd.MSSV, 
		mh.MSMH, 
		mh.TenMH, 
		mh.HeSo;
		--bd.Diem,

--26) Lập bảng tổng kết theo mẫu sau: MSSV, Họ, Tên, ĐTB = TỔng (điểm x hệ số)/Tổng hệ số

SELECT
		sv.MSSV, 
		sv.Ho, 
		sv.Ten,
		sum((bd.diem * mh.HeSo))/sum(mh.HeSo) AS DTB
FROM 
		SinhVien AS sv 
		JOIN BangDiem AS bd ON bd.MSSV = sv.MSSV
		JOIN MonHoc AS mh ON mh.MSMH = mh.MSMH
WHERE
		bd.diem >=all (
			SELECT bd2.diem 
			FROM BangDiem AS bd2
			WHERE bd2.MSSV = sv.MSSV AND bd2.MSMH = mh.MSMH
		)
GROUP BY
		sv.MSSV, 
		sv.Ho, 
		sv.Ten
--

--27) Thống kê số lượng sinh viên tỉnh 'Long An' đang theo học ở các khoa, theo mẫu sau: 
-- Năm học, MSKhoa, TenKhoa, SoLuongSV

SELECT l.NienKhoa, k.MSKhoa, k.TenKhoa, count(sv.MSSV) AS N'Số lượng'
FROM Sinhvien AS sv
	 JOIN Tinh AS t ON t.MSTinh = sv.MSTinh
	 JOIN Lop AS l ON l.MSLop = sv.MSLop
	 JOIN Khoa AS k ON k.MSkhoa = l.MSKhoa
WHERE
	t.TenTinh = N'Long An'
GROUP BY 
	l.NienKhoa, 
	k.MSKhoa, 
	k.TenKhoa

-- III. Hàm & Thủ Tục
	
-- 28) Nhập vào MSSV, in ra bảng điểm của sinh viên đó theo mẫu sau (điểm in ra lấy điểm cao nhất trong các lần thi):
-- MSMH - Tên MH - Hệ Số - Điểm

CREATE PROCEDURE use_inBangDiem 
	@mssv char(7)
AS
BEGIN
	IF NOT EXISTS (SELECT MSSV FROM SinhVien WHERE MSSV = @mssv)
	BEGIN
		PRINT(N'Không tồn tại sinh viên đã cho')
		RETURN
	END
	SELECT BD.MSMH, MH.TenMH, MH.HeSo, MAX(BD.Diem) AS N'Điểm cao nhất'
	FROM BangDiem AS BD
	INNER JOIN MonHoc AS MH ON BD.MSMH = MH.MSMH
	WHERE BD.MSSV = @mssv
	GROUP BY BD.MSMH, MH.TenMH, MH.HeSo
END

exec use_inBangDiem '99TH001'

-- 29) Nhập vào MS Lớp, in ra bảng tổng kết của lớp đó, theo mẫu sau:
-- MSSV, Họ, Tên, ĐTB, Xếp loại

ALTER PROCEDURE  use_inBangTongKet
	@mslop char(4)
AS
BEGIN
	IF NOT EXISTS (SELECT MSLop FROM Lop WHERE MSLop = @mslop)
	BEGIN
		PRINT(N'Không tồn tại sinh viên đã cho')
		RETURN
	END
	SELECT SV.MSSV, SV.Ho, SV.Ten, sum((BD.diem * MH.HeSo))/sum(MH.HeSo) AS DTB,
		CASE 
            WHEN sum((BD.diem * MH.HeSo))/sum(MH.HeSo) >= 8 THEN N'Giỏi'
            WHEN sum((BD.diem * MH.HeSo))/sum(MH.HeSo) >= 6.5 THEN N'Khá'
            WHEN sum((BD.diem * MH.HeSo))/sum(MH.HeSo) >= 5 THEN N'Trung bình'
            ELSE N'Yếu'
		END AS XepLoai
	FROM BangDiem AS BD
	INNER JOIN SinhVien AS SV ON SV.MSSV = BD.MSSV
	INNER JOIN MonHoc AS MH ON MH.MSMH = BD.MSMH
	WHERE SV.MSLop = @mslop
	GROUP BY SV.MSSV, SV.Ho, SV.Ten
END

exec use_inBangTongKet '98VT'

-- IV. Cập nhật dữ liệu

-- 30) Tạo bảng SinhVienTinh trong đó chứa hồ sơ của các sinh viên (lấy từ table SinhVien) có quê quán không phải ở TPHCM.
-- Thêm thuộc tính HBONG (học bổng) cho table SinhVienTinh

create table SinhVienTinh
(
	MSSV		char(7) primary key,
	Ho			nvarchar(30) not null,
    Ten			nvarchar(30) not null,
	NgaySinh	datetime not null,
	MSTinh		char(2) not null,
	NgayNhapHoc	datetime not null,
	MSLop		char(4) not null,
	Phai        nvarchar(3),
	DiaChi		nvarchar(50),
	DienThoai   varchar(16),
	HBONG	    float
)
go

INSERT INTO  SinhVienTinh (MSSV, Ho, Ten, NgaySinh, MSTinh, NgayNhapHoc, MSLop, Phai, DiaChi,DienThoai)
SELECT MSSV, Ho, Ten, NgaySinh, MSTinh, NgayNhapHoc, MSLop, Phai, DiaChi,DienThoai
FROM SinhVien
WHERE MSTinh <> 02;

SELECT * FROM SinhVienTinh

-- 31) Cập nhật thuộc tính HBONG trong table SinhVienTinh 10000 cho tất cả các sinh viên.

UPDATE SinhVienTinh
SET HBONG = 10000

-- 32) Tăng HBONG lên 10% cho các sinh viên nữ.

UPDATE SinhVienTinh
SET HBONG = HBONG * 1.1
WHERE Phai = N'No';

-- 33) Xoá tất cả các sinh viên có quê quán ở Long An ra khỏi table SinhVienTinh

DELETE 
FROM SinhVienTinh
WHERE MSTinh = '04';

