/* Học phần: Cơ sở dữ liệu
   Người thực hiện: Trần Đạt Tín
   MSSV: 2011345
   Lớp: TNK44
   Ngày bắt đầu: 15/02/2023
   Ngày kết thúc: 09/05/2023
*/	

--1) Xác định thứ tự tạo và cập nhật dữ liệu của cơ sở dữ liệu
--2) Phát biểu các ràng buộc toàn vẹn loại liên bộ (khoá chính, duy nhất,...)
-- và ràng buộc toàn vẹn tham chiếu (khoá ngoại)
--3) Chọn kiểu dữ liệu phù hợp và khai báo cấu trúc cơ sở dữ liệu với tên Lab06_QLHocVien
create database Lab06_QLHocVien

go

use Lab06_QLHocVien

go
create table CaHoc
(Ca			tinyint primary key,
GioBatDau	Datetime,
GioKetThuc	Datetime
)
go
create table GiaoVien
(MSGV		char(4) primary key,
HoGV		nvarchar(20),
TenGV		nvarchar(10),
DienThoai	varchar(11)
)
go
create table Lop
(MaLop	char(4) primary key,
TenLop	nvarchar(30),
NgayKG	Datetime,
HocPhi	int,
Ca		tinyint references CaHoc(Ca),
SoTiet	int,
SoHV	int,
MSGV	char(4) references GiaoVien(MSGV)
)
go
create table HocVien
(MSHV		char(6) primary key,
Ho			nvarchar(20),
Ten			nvarchar(10),
NgaySinh	Datetime,
Phai		nvarchar(4),
MaLop		char(4) references Lop(MaLop)
)
go
create table HocPhi
(
SoBL	char(4) primary key,
MSHV	char(6) references HocVien(MSHV),
NgayThu Datetime,
SoTien	int,
NoiDung	nvarchar(50),
NguoiThu nvarchar(30)
)
go
-------------------
select * from CaHoc
select * from GiaoVien
select * from Lop
select * from HocVien
select * from HocPhi

------------------CÀI ĐẶT RÀNG BUỘC TOÀN VẸN----------------
/*4a) Giờ kết thúc của một ca học không được trước giờ bắt đầu ca học đó 
(RBTV liên thuộc tính)*/
CREATE TRIGGER tr_CaHoc_ins_upd_GioBD_GioKT
ON CAHOC  FOR INSERT, UPDATE
AS
IF  UPDATE(GioBatDau) OR UPDATE (GioKetThuc)
	     IF EXISTS(SELECT * FROM inserted i where i.GioKetThuc<i.GioBatDau)	
	      begin
	    	 raiserror (N'Giờ kết thúc ca học không thể nhỏ hơn giờ bắt đầu',15,1)
		     rollback tran
	      end
go	

-- 4b): Số học viên của 1 lớp không quá 30 và đúng bằng số học viên thuộc lớp đó. 
-- (Ràng buộc toàn vẹn do thuộc tính tổng hợp)

-- Cho bảng Lop 

CREATE TRIGGER trg_Lop_ins_upd
ON Lop FOR INSERT, UPDATE
AS
if Update(MaLop) or Update(SoHV)
Begin
	IF EXISTS(SELECT * FROM inserted i WHERE i.SOHV>30) 
	BEGIN
		RAISERROR (N'Số học viên của một lớp không quá 30',15,1)
		ROLLBACK TRAN 
	END
	IF EXISTS(SELECT * FROM inserted l 
	              WHERE l.SOHV <> (SELECT count(MSHV) 
									FROM HocVien 
									WHERE HocVien.Malop = l.Malop))
	BEGIN
		RAISERROR (N'Số học viên của một lớp không bằng số lượng học viên tại lớp đó',15,1)
		ROLLBACK TRAN 
	END
END
	
GO
-- Thử nghiệm 
select * from Lop
--
Set dateformat dmy
go
insert into Lop values('P002',N'Photoshop','1/11/2018',250000,1,100,0,'G004')
update Lop set SoHV = 5 where MaLop = 'P001'

-- Cho bảng HocVien

CREATE TRIGGER trg_HocVien_Ins_Upd 
ON HocVien AFTER INSERT, UPDATE
AS
if Update(MaLop)
BEGIN
    DECLARE @MaLop CHAR(4)

    SELECT @MaLop = i.MaLop
    FROM inserted i

    IF EXISTS (
        SELECT MaLop
        FROM HocVien
        WHERE MaLop = @MaLop
        GROUP BY MaLop
        HAVING COUNT(*) > 2 -- Sửa thành 2 để kiểm tra
        )
    BEGIN
        RAISERROR('Số lượng học viên của lớp đã đạt tối đa 30.', 15, 1)
        ROLLBACK
    END
END
-- Thử nghiệm 
select * from HocVien
--
Set dateformat dmy
go
insert into HocVien values('A07504',N'Trần Đạt',N'Tín','21/11/2000',N'Nam','A075')
update HocVien set MaLop = 'A075' where MSHV = 'E11403'

-- 4c) Tổng số tiền tiền thu của một học viên không vượt quá học phí của lớp mà học viên đó đăng ký học
-- Ràng buộc toàn vẹn liên thuộc tính - liên quan hệ

-- Bảng học phí
CREATE TRIGGER trg_CheckHocPhiHocVien
ON HocPhi
FOR INSERT, UPDATE
AS
if Update(MSHV) or UPDATE(SOTIEN)
BEGIN
    DECLARE @MaLop CHAR(4), @MSHV CHAR(6), @SoTienThu INT, @SoTienHocPhi INT
    
    SELECT @MaLop = HocVien.MaLop, @MSHV = i.MSHV, @SoTienThu = i.SoTien
    FROM inserted i
	INNER JOIN HocVien ON i.MSHV = HocVien.MSHV
    
    SELECT @SoTienHocPhi = Lop.HocPhi
    FROM Lop
    INNER JOIN HocVien ON Lop.MaLop = HocVien.MaLop
    WHERE HocVien.MSHV = @MSHV AND Lop.MaLop = @MaLop
    
    IF (@SoTienThu > @SoTienHocPhi)
    BEGIN
        RAISERROR('Tổng số tiền tiền thu của học viên vượt quá học phí của lớp mà học viên đó đăng ký học.', 15, 1)
        ROLLBACK TRANSACTION
    END
END
-- Thử nghiệm 
select * from HocPhi
select * from Lop
--
Set dateformat dmy
go
insert into HocPhi values('0008','W12301','21/02/2023',200000,'NopTien',N'Nhi')
update HocVien set MaLop = 'A075' where MSHV = 'E11403'

-- Bảng học vien
CREATE TRIGGER trg_CheckHocVien
ON HocVien
AFTER UPDATE
AS
IF UPDATE(MSHV) OR UPDATE(MaLop)
BEGIN
    DECLARE @MaLop CHAR(4), @MSHV CHAR(6), @SoTienHocPhi INT
    
    SELECT @MaLop = i.MaLop, @MSHV = i.MSHV
    FROM inserted i
    
    SELECT @SoTienHocPhi = Lop.HocPhi
    FROM Lop
    WHERE MaLop = @MaLop
    
    IF EXISTS (	SELECT *
				FROM HocPhi
				WHERE SoTien > @SoTienHocPhi AND MSHV = @MSHV)
	BEGIN
        RAISERROR('Tổng số tiền tiền thu của học viên vượt quá học phí của lớp mà học viên đó đăng ký học.', 15, 1)
        ROLLBACK TRANSACTION
    END
END

-- Thử nghiệm 
select * from HocVien
--
update HocVien set MaLop = 'W123' where MSHV = 'A07501'

-- Bảng Lớp
CREATE TRIGGER trg_CheckLop
ON Lop
AFTER UPDATE
AS
IF UPDATE(MaLop) OR UPDATE(HocPhi)
BEGIN
    DECLARE @MaLop CHAR(4), @MSHV CHAR(6), @SoTienHocPhi INT
    
    SELECT @MaLop = i.MaLop, @SoTienHocPhi = i.HocPhi
    FROM inserted i

     IF EXISTS (SELECT *
				FROM HocVien
				INNER JOIN HocPhi ON HocPhi.MSHV = HocVien.MSHV
				WHERE MaLop = @MaLop AND HocPhi.SoTien > @SoTienHocPhi)
	BEGIN
        RAISERROR('Tổng số tiền tiền thu của học viên vượt quá học phí của lớp mà học viên đó đăng ký học.', 15, 1)
        ROLLBACK TRANSACTION
    END
END

-- Thử nghiệm 
select * from Lop
--
update Lop set HocPhi = 1000 where MaLop = 'E114'


--5) Tạo các thủ tục (Stored Procedure) sau:
-- 5a) Thêm dữ liệu vào các bảng (đảm bảo các ràng buộc toàn vẹn liên quan)
CREATE PROC usp_ThemCaHoc
	@ca tinyint, 
	@giobd Datetime, 
	@giokt Datetime
As
	If exists(select * from CaHoc where Ca = @ca) --kiểm tra có trùng khóa chính (Ca) 
		print N'Đã có ca học ' +@ca+ N' trong CSDL!'
	Else
		begin
			insert into CaHoc values(@ca, @giobd, @giokt)
			print N'Thêm ca học thành công.'
		end
go

--goi thuc hien thu tuc usp_ThemCaHoc---
exec usp_ThemCaHoc 1,'7:30','10:45'
exec usp_ThemCaHoc 2,'13:30','16:45'
exec usp_ThemCaHoc 3,'17:30','20:45'

select * from CaHoc

--5a) Thêm giáo viên

CREATE PROC usp_ThemGiaoVien
	@msgv char(4), @hogv nvarchar(20), @Tengv nvarchar(10),@dienthoai varchar(11)
As
	If exists(select * from GiaoVien where MSGV = @msgv) --kiểm tra có trùng khóa chính (MSGV) 
		print N'Đã có giáo viên có mã số ' +@msgv+ N' trong CSDL!'
	Else
		begin
			insert into GiaoVien values(@msgv, @hogv, @Tengv, @dienthoai)
			print N'Thêm giáo viên thành công.'
		end
go

--goi thuc hien thu tuc usp_ThemGiaoVien---
exec usp_ThemGiaoVien 'G001',N'Lê Hoàng',N'Anh', '858936'
exec usp_ThemGiaoVien 'G002',N'Nguyễn Ngọc',N'Lan', '845623'
exec usp_ThemGiaoVien 'G003',N'Trần Minh',N'Hùng', '823456'
exec usp_ThemGiaoVien 'G004',N'Võ Thanh',N'Trung', '841256'

--5a) Thêm lớp học
create PROC usp_ThemLopHoc
@malop char(4), @Tenlop nvarchar(20), 
@NgayKG datetime,@HocPhi int, @Ca tinyint, @sotiet int, @sohv int, 
@msgv char(4)
As
	If exists(select * from CaHoc where Ca = @Ca) and exists(select * from GiaoVien where MSGV=@msgv)--kiểm tra các RBTV khóa ngoại
	  Begin
		if exists(select * from Lop where MaLop = @malop) --kiểm tra có trùng khóa chính của quan hệ Lop 
			print N'Đã có lớp '+ @MaLop +' trong CSDL!'
		else	
			begin
				insert into Lop values(@malop, @Tenlop, @NgayKG, @HocPhi, @Ca, @sotiet, @sohv, @msgv)
				print N'Thêm lớp học thành công.'
			end
	  End
	Else -- Bị vi phạm ràng buộc khóa ngoại
		if not exists(select * from CaHoc where Ca = @Ca)
				print N'Không có ca học '+@Ca+' trong CSDL.'
		else	print N'Không có giáo viên '+@msgv+' trong CSDL.'
go


--goi thuc hien thu tuc usp_ThemLopHoc---
set dateformat dmy
go
exec usp_ThemLopHoc 'A075',N'Access 2-4-6','18/12/2008', 150000,3,60,3,'G003'
exec usp_ThemLopHoc 'E114',N'Excel 3-5-7','02/01/2008', 120000,1,45,3,'G003'
exec usp_ThemLopHoc 'A115',N'Excel 2-4-6','22/01/2008', 120000,3,45,0,'G001'
exec usp_ThemLopHoc 'W123',N'Word 2-4-6','18/02/2008', 100000,3,30,1,'G001'
exec usp_ThemLopHoc 'W124',N'Word 3-5-7','01/03/2008', 100000,1,30,0,'G002'
exec usp_ThemLopHoc 'W125',N'Word 3-5-7','01/03/2008', 100000,1,30,0,'G002'
----------------------

--5a) Thêm học viên
create PROC usp_ThemHocVien
@MSHV char(6), @Ho nvarchar(20), @Ten nvarchar(10),
@NgaySinh Datetime, @Phai	nvarchar(4),@MaLop char(4)
As
	If exists(select * from Lop where MaLop = @MaLop) --kiểm tra có RBTV khóa ngoại
	  Begin
		if exists(select * from HocVien where MSHV = @MSHV) --kiểm tra có trùng khóa chính (MAHV) 
			print N'Đã có mã số học viên này trong CSDL!'
		else
			begin
				insert into HocVien values(@MSHV,@Ho, @Ten,@NgaySinh,@Phai,@MaLop)
				print N'Thêm học viên thành công.'
			end
	  End
	Else
		print N'Lớp '+ @MaLop + N' không tồn tại trong CSDL nên không thể thêm học viên vào lớp này!'


		
go
----goi thuc hien thu tuc usp_ThemHocVien-------
set dateformat dmy
go
exec usp_ThemHocVien 'A07501',N'Lê Văn', N'Minh', '10/06/1988',N'Nam', 'A075'
exec usp_ThemHocVien 'A07502',N'Nguyễn Thị', N'Mai', '20/04/1988',N'Nữ', 'A075'
exec usp_ThemHocVien 'A07503',N'Lê Ngọc', N'Tuấn', '10/06/1984',N'Nam', 'A075'
exec usp_ThemHocVien 'E11401',N'Vương Tuấn', N'Vũ', '25/03/1979',N'Nam', 'E114'
exec usp_ThemHocVien 'E11402',N'Lý Ngọc', N'Hân', '01/12/1985',N'Nữ', 'E114'
exec usp_ThemHocVien 'E11403',N'Trần Mai', N'Linh', '04/06/1980',N'Nữ', 'E114'
exec usp_ThemHocVien 'W12301',N'Nguyễn Ngọc', N'Tuyết', '12/05/1986',N'Nữ', 'W123'
----------------------------

-- 5a) Thêm học phí
create PROC usp_ThemHocPhi
@SoBL char(4),
@MSHV char(6),
@NgayThu Datetime,
@SoTien	int,
@NoiDung nvarchar(50),
@NguoiThu nvarchar(30)
As
	If exists(select * from HocVien where MSHV = @MSHV) --kiểm tra có RBTV khóa ngoại
	  Begin
		if exists(select * from HocPhi where SoBL = @SoBL) --kiểm tra có trùng khóa(SoBL) 
			print N'Đã có số biên lai học phí này trong CSDL!'
		else
		 begin
			insert into HocPhi values(@SoBL,@MSHV,@NgayThu, @SoTien, @NoiDung,@NguoiThu)
			print N'Thêm biên lai học phí thành công.'
		 end
	  End
	Else
		print N'Học viên '+ @MSHV + N' không tồn tại trong CSDL nên không thể thêm biên lai học phí của học viên này!'
go
----goi thuc hien thu tuc usp_ThemHocPhi-------
set dateformat dmy
go
exec usp_ThemHocPhi '0001','A07501','16/12/2008',150000,'HP Access 2-4-6', N'Lan'
exec usp_ThemHocPhi '0002','A07502','16/12/2008',100000,'HP Access 2-4-6', N'Lan'
exec usp_ThemHocPhi '0003','A07503','18/12/2008',150000,'HP Access 2-4-6', N'Vân'
exec usp_ThemHocPhi '0002','A07504','15/01/2009',50000,'HP Access 2-4-6', N'Vân'
exec usp_ThemHocPhi '0004','E11401','02/01/2008',120000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi '0005','E11402','02/01/2008',120000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi '0006','E11403','02/01/2008',80000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi '0007','W12301','18/02/2008',100000,'HP Word 2-4-6', N'Lan'

--5b) Cập nhật thông tin của một học viên cho trước

DROP PROCEDURE IF EXISTS use_SuaThongTinHV;
CREATE PROCEDURE use_SuaThongTinHV
	@MSHV	  char(4),
	@Ho		  nvarchar(20),
	@Ten      nvarchar(10),
	@NgaySinh Datetime,
	@Phai     nvarchar(4),
	@MaLop    char(4) 

AS
BEGIN
	If exists(select * from Lop where MaLop = @MaLop) --kiểm tra có RBTV khóa ngoại
	  Begin
		if exists(select * from HocVien where MSHV = @MSHV) --kiểm tra có trùng khóa chính (MAHV) 
			begin
				UPDATE HocVien
				SET Ho = @Ho,Ten = @Ten,NgaySinh = @NgaySinh,Phai = @Phai 
				WHERE MSHV = @MSHV;
				print N'Sửa học viên thành công.'
			end
		else
			print N'Không có mã số học viên này trong CSDL!'
	   End
	Else
		print N'Lớp '+ @MaLop + N' không tồn tại trong CSDL nên không thể Sửa học viên vào lớp này!'
END

set dateformat dmy
GO
EXEC use_SuaThongTinHV '0001', 'Lê Văn', 'Nam', '10/06/1988', 'Nam', 'A075';
select * from HocVien

--5c) Xoá một học viên cho trước

CREATE PROCEDURE use_XoaHocVien
	@MSHV	char(4)
AS
BEGIN
	IF EXISTS (SELECT * FROM HOCPHI WHERE MSHV = @MSHV)
		PRINT N'KHÔNG XOÁ ĐƯỢC VÌ CÓ THÔNG TIN LIÊN QUAN ĐẾN HỌC PHÍ'
	ELSE
		BEGIN
		IF EXISTS (SELECT * FROM HOCVIEN WHERE MSHV = @MSHV)
			DELETE FROM HocVien WHERE MSHV = @MSHV;
		ELSE
			PRINT N'KHÔNG TỒN TẠI HỌC VIÊN CẦN XOÁ'
		END
END

EXEC use_XoaHocVien '0008';
SELECT * FROM HocVien

--5d) Cập nhật thông tin của một lớp học cho trước
--DROP PROCEDURE IF EXISTS use_SuaThongTinLopHoc;
CREATE PROCEDURE use_SuaThongTinLopHoc
	@MaLop	  char(4),
	@TenLop   nvarchar(30),
	@NgayKG   Datetime,
	@HocPhi	  int,
	@Ca       tinyint,
	@SoTiet   int, 
	@SoHV     int, 
	@MSGV     char(4) 
AS
BEGIN
	If exists(select * from Lop where MSGV = @MSGV) --kiểm tra có RBTV khóa ngoại
	  Begin
		if exists(select * from HocVien where MaLop = @MaLop) --kiểm tra có trùng khóa chính (MAHV) 
			begin
				UPDATE Lop SET  TenLop = @TenLop, NgayKG = @NgayKG, HocPhi = @HocPhi, Ca = @Ca, SoTiet = @SoTiet, SoHV = @SoHV WHERE MaLop = @MaLop;
				print N'Sửa lớp thành công.'
			end
		else
			print N'Không có mã số lớp này trong CSDL!'
	   End
	Else
		print N'Giáo Viên với mã số '+ @MSGV + N' không tồn tại trong CSDL nên không thể sửa lớp học này!'
END

set dateformat dmy
GO
EXEC use_SuaThongTinLopHoc 'A075', 'Access 2-4-5', '18-12-2008', 150000,3,60,3,G003;
SELECT * FROM Lop

--5e) Xoá một lớp học cho trước nếu lớp học không có học viên
--DROP PROCEDURE IF EXISTS use_XoaLopHocKhongHocVien;
CREATE PROCEDURE use_XoaLopHocKhongHocVien
	@MaLop	char(4)
AS
BEGIN
	IF EXISTS (SELECT * FROM HocVien WHERE MaLop = @MaLop)
		PRINT N'LỚP HỌC CÓ HỌC VIÊN NÊN KHÔNG THỂ XOÁ'
	ELSE
		BEGIN
			IF EXISTS (SELECT * FROM Lop WHERE MaLop = @MaLop)
				DELETE FROM Lop WHERE MaLop = @MaLop;
			ELSE
				PRINT N'KHÔNG TỒN TẠI LỚP HỌC CẦN XOÁ'
		END
END

EXEC use_XoaLopHoc 'W125';
SELECT * FROM Lop

-- 4f) Lập danh sách học viên của một lớp cho trước.

CREATE PROCEDURE use_LapDanhSachHocVien
	@MaLop char(4)
AS
BEGIN
	SELECT hv.MSHV, hv.Ho, hv.Ten, hv.NgaySinh, hv.Phai, hv.MaLop
	FROM HocVien AS hv 
	INNER JOIN Lop AS l ON l.MaLop = hv.MaLop
	WHERE l.MaLop = @MaLop
END

EXEC use_LapDanhSachHocVien 'A075';
SELECT * FROM Lop

-- 4g) Lập danh sách học viên chưa đóng đủ học phí của một lớp học cho trước

CREATE PROCEDURE use_LapDanhSachHocVienChuaDongHocPhi
	@MaLop char(4)
AS
BEGIN
	SELECT hv.MSHV, hv.Ho, hv.Ten, hv.NgaySinh, hv.Phai, hv.MaLop, SUM(hp.SoTien) AS N'Số Tiền đã đóng', l.HocPhi
	FROM HocVien AS hv 
	INNER JOIN Lop AS l ON l.MaLop = hv.MaLop
	LEFT JOIN HocPhi AS hp ON hp.MSHV = hv.MSHV
	WHERE l.MaLop = @MaLop
	GROUP BY hv.MSHV, hv.Ho, hv.Ten, hv.NgaySinh, hv.Phai, hv.MaLop, l.HocPhi
	HAVING SUM(hp.SoTien) < l.HocPhi OR SUM(hp.SoTien) IS NULL
END

EXEC use_LapDanhSachHocVienChuaDongHocPhi 'E114';
SELECT * FROM Lop
SELECT * FROM HocPhi
SELECT * FROM HocVien

-- 6) Cài đặt các hàm (Function) sau:

-- 6a) Viết hàm tính tổng số học phí thu được của một lớp khi biết mã lớp.
CREATE FUNCTION TinhTongHocPhiMotLopVoiMaLop (@MaLop char(4))
RETURNS int	
AS
BEGIN
	DECLARE @sum int = 0
	
	SELECT @sum = sum(hp.SoTien) 
	FROM HocVien AS hv 
	INNER JOIN HocPhi AS hp ON hp.MSHV = hv.MSHV
	WHERE hv.MaLop = @MaLop
   
	RETURN @sum
END

SELECT DBO.TinhTongHocPhiMotLopVoiMaLop('E114');

-- 6b) Tính tổng số học phí thu được trong một khoảng thời gian cho trước.
CREATE FUNCTION TinhTongHocPhiTheoThoiGian (@nbd datetime, @nkt datetime)
RETURNS int
AS
BEGIN
	DECLARE @sum int = 0

	SELECT @sum = sum(hp.SoTien)
	FROM HocPhi AS hp
	WHERE hp.NgayThu BETWEEN @nbd AND @nkt

	RETURN @sum
END

set dateformat dmy
SELECT DBO.TinhTongHocPhiTheoThoiGian('21/01/2008','01/04/2008') AS 'Tổng học phí';

-- 6c) Cho biết một học viên cho trước đã nộp đủ học phí hay chưa

CREATE FUNCTION NopHocPhiChua (@MaHV char(4)) 
RETURNS int
AS
BEGIN
	DECLARE @money int = 0
	DECLARE @flag int = 0

	SELECT @money = l.HocPhi
	FROM Lop AS l
	INNER JOIN HocVien AS hv ON hv.MaLop = l.MaLop
	WHERE hv.MSHV = @MaHV 

	IF  EXISTS (SELECT HocPhi.SoTien FROM HocPhi WHERE HocPhi.MSHV = @MaHV AND HocPhi.SoTien >= @money)
		SET @flag = 1
	ELSE 
		SET @flag = 0

	RETURN @flag
END

SELECT DBO.NopHocPhiChua('E11403') AS 'Đã đóng học phí';

-- 6d) Hàm sinh mã số học viên theo quy tắc mã số học viên 
-- gồm mã lớp của học viên kết hợp với số thứ tự của học viên trong lớp đó

ALTER FUNCTION SinhMaHV(@MaLop char(4))
RETURNS char(6)
AS
BEGIN
	DECLARE @MaxMaHV char(6)
	DECLARE @NewMaHV varchar(6)
	DECLARE @stt	int 
	DECLARE @i	int	
	DECLARE @sokyso	int

	IF exists(SELECT * FROM HocVien)---Nếu bảng giáo viên có dữ liệu
		BEGIN
			--Lấy mã sinh viên lớn nhất hiện có
			SELECT @MaxMaHV = max(hv.MSHV) 
			FROM HocVien as hv
			WHERE hv.MaLop = @MaLop

			--Trích phần ký số của mã lớn nhất và chuyển thành số 
			SET @stt=convert(int, right(@MaxMaHV,2)) + 1 --Số thứ tự của học viên mới
		END
	ELSE--Nếu bảng học viên lớp đó đang rỗng
		SET @stt= 1 -- Số thứ tự của giáo viên trong trường hợp chưa có gv nào trong CSDL
	--Kiểm tra và bổ sung chữ số 0 để đủ 2 ký số trong mã gv.
	SET @sokyso = len(convert(varchar(3), @stt))
	SET @NewMaHV = @MaLop
	SET @i = 0
	WHILE @i < 2 - @sokyso
	BEGIN
		SET @NewMaHV = @NewMaHV + '0'
		SET @i = @i + 1
	END	
	SET @NewMaHV = @NewMaHV + convert(varchar(3), @stt)

	RETURN @NewMaHV	
END

select * from HocVien
print dbo.SinhMaHV('A075')


/*
-------------------------------------------------------------------------------
--------------------VÍ DỤ HÀM SINH MÃ & CÁCH SỬ DỤNG----------------
/*1. Viết hàm sinh mã cho giáo viên mới theo quy tắc lấy mã lớn nhất hiện có 
sau đó tăng thêm 1 đơn vị*/
create function SinhMaGV() returns char(4)
As
Begin
	declare @MaxMaGV char(4)
	declare @NewMaGV varchar(4)
	declare @stt	int
	declare @i	int	
	declare @sokyso	int

	if exists(select * from GiaoVien)---Nếu bảng giáo viên có dữ liệu
	 begin
		--Lấy mã giáo viên lớn nhất hiện có
		select @MaxMaGV = max(MSGV) 
		from GiaoVien

		--Trích phần ký số của mã lớn nhất và chuyển thành số 
		set @stt=convert(int, right(@MaxMaGV,3)) + 1 --Số thứ tự của giáo viên mới
	 end
	else--Nếu bảng giáo viên đang rỗng (nghĩa là chưa có giáo viên nào được lưu trữ trong CSDL.
	 set @stt= 1 -- Số thứ tự của giáo viên trong trường hợp chưa có gv nào trong CSDL
	
	--Kiểm tra và bổ sung chữ số 0 để đủ 3 ký số trong mã gv.
	set @sokyso = len(convert(varchar(3), @stt))
	set @NewMaGV='G'
	set @i = 0
	while @i < 3 - @sokyso
		begin
			set @NewMaGV = @NewMaGV + '0'
			set @i = @i + 1
		end	
	set @NewMaGV = @NewMaGV + convert(varchar(3), @stt)

return @NewMaGV	
End
--Thử hàm sinh mã
select * from GiaoVien
print dbo.SinhMaGV()
----2. Thủ  tục thêm giáo viên với mã giáo viên được sinh tự động----
CREATE PROC usp_ThemGiaoVien2
@hogv nvarchar(20), @tengv nvarchar(10), @dthoai varchar(10)
As
	declare @Magv char(4)
	
 if not exists(select * from GiaoVien 
				where HoGV = @hogv and TenGV = @tengv and DienThoai = @dthoai)
	Begin
		
		--sinh mã cho giáo viên mới
		set @Magv = dbo.SinhMaGV()
		insert into GiaoVien values(@Magv, @hogv, @tengv,@dthoai)
		print N'Đã thêm giáo viên thành công'
	End
else
	print N'Đã có giáo viên ' + @hogv +' ' + @tengv + ' trong CSDL'
Go
---Sử dụng thủ tục thêm giáo viên
exec usp_ThemGiaoVien2 N'Trần Ngọc Bảo', N'Hân', '0123456789'
exec usp_ThemGiaoVien2 N'Vũ Minh', N'Triết', '0123456788'
select * from GiaoVien


