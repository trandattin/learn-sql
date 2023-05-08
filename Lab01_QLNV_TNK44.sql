/* Học phần: Cơ sở dữ liệu
   Người thực hiện: ????
   MSSV: ????
   Lớp: TNK44
   Ngày bắt đầu: 03/03/2023
   Ngày kết thúc: ?????
*/	
----------ĐỊNH NGHĨA CƠ SỞ DỮ LIỆU----------------
CREATE DATABASE Lab01_QLNV -- lenh khai bao CSDL
go
use Lab01_QLNV
go
--lenh tao cac bang theo thứ tự đã xác định
create table ChiNhanh
(MSCN	char(2) primary key,		 --khai bao MSCN la khoa chinh cua ChiNhanh
TenCN	nvarchar(30) not null unique --khai bao TenCN không được để trống và không được nhập trùng
)
go
create table KyNang
(MSKN	char(2) primary key,
TenKN	nvarchar(30) not null
)
go
create table NhanVien
(
MANV char(4) primary key,
Ho	nvarchar(20) not null,
Ten nvarchar(10)	not null,
Ngaysinh	datetime,
NgayVaoLam	datetime,
MSCN	char(2)	references ChiNhanh(MSCN)--khai báo MSCN là khóa ngoại của bảng NhanVien
)
go
create table NhanVienKyNang
(
MANV char(4) references NhanVien(MANV),
MSKN char(2) references KyNang(MSKN),
MucDo	tinyint check(MucDo between 1 and 9)--check(MucDo>=1 and MucDo<=1)
primary key(MANV,MSKN)--Khai báo NhanVienKyNang có khóa chính gồm 2 thuộc tính (MaNV, MSKN)

)
-------------NHAP DU LIEU CHO CAC BANG-----------
--Nhập dữ liệu cho bảng Chi nhánh
insert into ChiNhanh values('01',N'Quận 1')
insert into ChiNhanh values('02',N'Quận 5')
insert into ChiNhanh values('03',N'Bình thạnh')
--xem bảng Chi nhanh
select * from ChiNhanh
--delete from ChiNhanh
--Nhap bang Kynang
insert into KyNang values('01',N'Word')
insert into KyNang values('02',N'Excel')
insert into KyNang values('03',N'Access')
insert into KyNang values('04',N'Power Point')
insert into KyNang values('05','SPSS')
--xem bảng KyNang
select * from KyNang
--Nhap bang NhanVien
set dateformat dmy --định dạng nhập dữ liệu ngày tháng theo kiểu ngày tháng năm
go
insert into NhanVien values('0001',N'Lê Văn',N'Minh','10/06/1960','02/05/1986','01')
insert into NhanVien values('0002',N'Nguyễn Thị',N'Mai','20/04/1970','04/07/2001','01')
insert into NhanVien values('0003',N'Lê Anh',N'Tuấn','25/06/1975','01/09/1982','02')
insert into NhanVien values('0004',N'Vương Tuấn',N'Vũ','25/03/1975','12/01/1986','02')
insert into NhanVien values('0005',N'Lý Anh',N'Hân','01/12/1980','15/05/2004','02')
insert into NhanVien values('0006',N'Phan Lê',N'Tuấn','04/06/1976','25/10/2002','03')
insert into NhanVien values('0007',N'Lê Tuấn',N'Tú','15/08/1975','15/08/2000','03')
--xem bang nhanvien
select * from NhanVien
--nhap bang nhanvienkynang
insert into NhanVienKyNang values('0001','01',2)
insert into NhanVienKyNang values('0001','02',1)
insert into NhanVienKyNang values('0002','01',2)
insert into NhanVienKyNang values('0002','03',2)
insert into NhanVienKyNang values('0003','02',1)
insert into NhanVienKyNang values('0003','03',2)
insert into NhanVienKyNang values('0004','01',5)
insert into NhanVienKyNang values('0004','02',4)
insert into NhanVienKyNang values('0004','03',1)
insert into NhanVienKyNang values('0005','02',4)
insert into NhanVienKyNang values('0005','04',4)
insert into NhanVienKyNang values('0006','05',4)
insert into NhanVienKyNang values('0006','02',4)
insert into NhanVienKyNang values('0006','03',2)
insert into NhanVienKyNang values('0007','03',4)
insert into NhanVienKyNang values('0007','04',3)
--xem bang NhanVienKyNang
select * from NhanVienKyNang
--Xem tất cả các quan hệ có trong CSDL
select * from ChiNhanh
select * from KyNang
select * from NhanVien
select * from NhanVienKyNang
-----------------------------------------------------------------------
------------------------------TRUY VẤN DỮ LIỆU---------------------
--q1: lập danh sách các nhân viên làm việc tại chi nhánh có mã số chi nhánh là '01'
Select	*
From	NhanVien
Where	MSCN='01'
--q2: lập danh sách các nhân viên sinh sau năm 1975
Select	*
From	NhanVien
Where	year(NgaySinh)>1975
--q3: lập danh sách các nhân viên ở chi nhánh '03' sinh sau năm 1975
Select	*
From	NhanVien
Where	mscn ='03' and year(NgaySinh)>1975
--q4: lập danh sách các nhân viên có họ 'Lê'
Select	*
From	NhanVien
Where	Ho = N'Lê'
---
Select	*
From	NhanVien
Where	Ho like N'Lê%'
--q5: Lập danh sách nhân viên bao gồm các thông tin: manv, ho, ten ,mscn, ngayvaolam
Select	manv, ho, ten ,mscn, ngayvaolam
From	NhanVien
--q6: cho biết các thông tin sau của nhân viên manv, hoten, năm sinh, mscn, số năm công tác
Select	manv, ho+' '+ten as HoTen, year(NgaySinh) as NamSinh, mscn, year(getdate())-year(ngayvaolam) as SoNamCT
From	NhanVien
--q7: cho biết các thông tin sau của nhân viên họ Lê làm việc tại chi nhánh '03': manv, hoten, năm sinh, mscn, số năm công tác
Select	manv, ho+' '+ten as HoTen, year(NgaySinh) as NamSinh, mscn, year(getdate())-year(ngayvaolam) as SoNamCT
From	NhanVien
where	mscn = '03' and Ho like N'Lê%'
--tich 2 quan hệ NhanVien, Chinhanh
Select	*
From	NhanVien, ChiNhanh
order by MANV
--Phép nối 2 quan hệ NhanVien, Chinhanh
Select	*
From	NhanVien, ChiNhanh
Where	NhanVien.MSCN = ChiNhanh.MSCN
--Q1c) Liệt kê các nhân viên (HoTen, TenKN, MucDo) của những nhân viên biết sử dụng ‘Word’
Select	Ho+' '+Ten as HoTen, TenKN, MucDo
From	NhanVien, NhanVienKyNang, KyNang
Where	NhanVien.MANV = NhanVienKyNang.MANV and NhanVienKyNang.MSKN = KyNang.MSKN
		and TenKN = 'Word'
--Q1d)  Liệt kê các kỹ năng (TenKN, MucDo) mà nhân viên ‘Lê Anh Tuấn’ biết sử dụng
Select	TenKN, MucDo
From	NhanVien, NhanVienKyNang, KyNang
Where	NhanVien.MANV = NhanVienKyNang.MANV and NhanVienKyNang.MSKN = KyNang.MSKN
		--and Ho = N'Lê Anh' and Ten = N'Tuấn'
		and Ho+' '+Ten = N'Lê Anh Tuấn'
--------------------Truy vấn gom nhóm------------
--Q3a) Với mỗi chi nhánh, hãy cho biết các thông tin sau TenCN, SoNV (số nhân viên của chi nhánh đó)
Select	A.MSCN,TenCN, count(MaNV) As SoNV
From	ChiNhanh A, NhanVien B
Where	A.MSCN = B.MSCN
Group by	A.MSCN, TenCN
--Q3b)  Với mỗi kỹ năng, hãy cho biết TenKN, SoNguoiDung (số nhân viên biết sử dụng kỹ năng đó). 
Select	TenKN, count(MaNV) as SoNguoiDung
From	NhanVienKyNang A, KyNang B
Where	A.MSKN = B.MSKN
Group by	TenKN
--Q3c)  Cho biết TenKN có từ 3 nhân viên trong công ty sử dụng trở lên. 
Select	TenKN, count(MaNV) as SoNguoiDung
From	NhanVienKyNang A, KyNang B
Where	A.MSKN = B.MSKN
Group by	TenKN
Having	count(MaNV)>=3
----------------------TRUY VẤN LỒNG NHAU------------------------
--Q2b) liệt kê các nhân viên (MANV, HoTen, TenCN) sử dụng được cả Word và Excel (Phép giao)
Select	B.MANV, Ho+' '+ Ten As HoTen, TenCN
From	ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
Where	A.MSCN = B.MSCN and B.MANV = C.MANV and C.MSKN = D.MSKN
		and TenKN = 'Excel' and B.MANV in (	Select	E.MANV
											From	NhanVienKyNang E, KyNang F
											Where	E.MSKN = F.MSKN and TenKN = 'Word')

--q8) Cho biết các nhân viên không sử dụng Access (Phép hiệu)
Select *
From	NhanVien
Where	MaNV not in (Select	A.MANV
					From	NhanVienKyNang A, KyNang B
					Where	A.MSKN = B.MSKN and TenKN = 'Access')

--Q2a) Liệt kê các nhân viên thành thạo 'Excel' nhất (Tìm Max)
--Cách 1: dùng hàm Max
Select	B.MANV, Ho+' '+ Ten As HoTen, A.MSCN,TenCN, TenKN, MucDo
From	ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
Where	A.MSCN = B.MSCN and B.MANV = C.MANV and C.MSKN = D.MSKN
		and TenKN = 'Excel' and C.MucDo = (	Select	Max(E.MucDo)
											From	NhanVienKyNang E, KyNang F
											Where	E.MSKN = F.MSKN and TenKN = 'Excel')
--Cách 2: Dùng so sánh với tập hợp
Select	B.MANV, Ho+' '+ Ten As HoTen, A.MSCN,TenCN, TenKN, MucDo
From	ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
Where	A.MSCN = B.MSCN and B.MANV = C.MANV and C.MSKN = D.MSKN
		and TenKN = 'Excel' and C.MucDo >=all (	Select	E.MucDo
											From	NhanVienKyNang E, KyNang F
											Where	E.MSKN = F.MSKN and TenKN = 'Excel')
--Q3d) Cho biết tên chi nhánh có nhiều nhân viên nhất (Tìm Max, dùng hàm gộp)
Select	A.MSCN,TenCN, count(MaNV) As SoNV
From	ChiNhanh A, NhanVien B
Where	A.MSCN = B.MSCN 
Group by	A.MSCN, TenCN
Having	count(maNV) >=all (select count(MaNV)
							From Nhanvien
							Group by MSCN)
--Q3e)	Cho biết tên chi nhánh có ít nhân viên nhất (Tìm Min, dùng hàm gộp)
Select	A.MSCN,TenCN, count(MaNV) As SoNV
From	ChiNhanh A, NhanVien B
Where	A.MSCN = B.MSCN 
Group by	A.MSCN, TenCN
Having	count(maNV) <=all (select count(MaNV)
							From Nhanvien
							Group by MSCN)
--Q3g) Cho biết HoTen, TenCN của nhân viên biết sử dụng nhiều kỹ năng nhất (Tìm Max, dùng hàm gộp)
Select	Ho+' '+ Ten as HoTen,TenCN, count(MSKN) As SoKN
From	ChiNhanh A, NhanVien B, NhanVienKyNang C
Where	A.MSCN = B.MSCN and B.MANV = C.MANV
Group by	Ho, Ten, TenCN
Having	count(MSKN) >=all (select count(MSKN)
							From NhanVienKyNang
							Group by MaNV)
--Q9) Cho biết nhân viên sử dụng được mọi kỹ năng (Phép chia)
--Cách 1: phát biểu thông qua phép đếm
Select	A.MaNV, Ho+' '+ Ten as HoTen,MSCN
From	NhanVien A, NhanVienKyNang B
Where	A.MANV = B.MANV
Group by	A.MANV, Ho, Ten, MSCN
Having	count(MSKN) = (select count(MSKN)
							From KyNang
						)
--Cách 2
Select	*
From	NhanVien A
Where	not exists (select * 
					From KyNang B
					Where not exists (	select * 
										from	NhanVienKyNang C
										where	C.MANV = A.MANV and C.MSKN = B.MSKN))
					
--Thêm dữ liệu để thử truy vấn
insert into NhanVienKyNang values('0004','04',5)
insert into NhanVienKyNang values('0004','05',5)
--xóa dữ liệu
--delete from NhanVienKyNang where manv = '0004' and mskn = '04'
--delete from NhanVienKyNang where manv = '0004' and mskn = '05'

--Q2d) Liệt kê các chi nhánh (MSCN, TenCN) mà mọi nhân viên trong chi nhánh đó đều biết ‘Word’. (Phép chia - truy vấn lồng tương)
Select	A.MSCN,TenCN, count(B.MaNV) as SoNVDungWord
From	ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
Where	A.MSCN = B.MSCN and B.MANV = C.MANV and C.MSKN = D.MSKN
		and TenKN = 'Word'
Group by A.MSCN,TenCN
Having	count(B.MaNV) = (	Select  count(MaNV)
							From	NhanVien E
							Where	E.MSCN = A.MSCN)
							
--Q2d) Với mỗi kỹ năng, liệt kê các nhân viên thành thạo nhất (Truy vấn lồng tương quan)
Select	TenKN, B.MANV, Ho+' '+ Ten As HoTen, A.MSCN,TenCN, MucDo
From	ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
Where	A.MSCN = B.MSCN and B.MANV = C.MANV and C.MSKN = D.MSKN
		and C.MucDo = (	Select	Max(E.MucDo)
						From	NhanVienKyNang E
						Where	E.MSKN = D.MSKN )
Order by TenKN, Ten, Ho

-- (1) Select <Danh sách thuộc tính đại diện nhóm>, hàm hộp
-- (1) From <danh sách các QUAN HỆ>
-- (2) where <điều kiện liên kết>, <điều kiện chọn bộ>
-- (3) Group by <Danh sách thuộc tính đại diện nhóm>
-- (4) Having <Điều kiện cho nhóm (count/sum)>
-- (5) Order by <Thuộc tính sắp xếp>

-- KỸ NANG TRUY VẤN DỮ LIỆU
-- B1: Đọc & Phân tích truy vấn:
--     + Các thông tin cần hiển thị trong kết quả truy vấn 
--	           + Có trực tiếp
--	           + Phân tích - Công thức | biểu thức?
--	   + Xác định các quan hệ cần sử dụng
--	   + Điều kiện kết bảng & điều kiện chọn
--     + Xác định loại truy vấn (chọn, chiếu, gom nhóm, lồng,...)

-- B2: Phát biểu truy vấn SQL và DSQH
-- B3: Thực hiện truy vấn và kiểm tra KQ
	-- + Nếu có lỗi -> sửa lỗi
	-- + Có kết quả -> rỗng và khác rỗng