--------------------THỦ TỤC VÀ HÀM----------------------

-- Tra cứu hợp đồng

CREATE PROCEDURE TraCuuHopDong
    @mahd CHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem mã hợp đồng có tồn tại hay không
    IF NOT EXISTS (SELECT * FROM Hop_dong WHERE mahd = @mahd)
    BEGIN
        PRINT 'Hợp đồng không tồn tại.';
        RETURN;
    END;

    SELECT hd.mahd, hd.ngay_bd, hd.ngay_kt, hd.mo_ta, hd.khuyen_mai, hd.thanh_toan,
           kh.makh, kh.ho_ten, kh.dia_chi, kh.sdt,
           ddh.madh, ddh.ngay_dat, ddh.dinh_ky, ddh.tong_gia,
           ctdh.masp, ctdh.so_luong,
           sp.ten_sp, sp.loai_sp, sp.so_seri_sx
    FROM Hop_dong hd
    INNER JOIN Khach_hang kh ON hd.makh = kh.makh
    INNER JOIN Don_dat_hang ddh ON hd.mahd = ddh.mahd
    INNER JOIN CTDH ctdh ON ddh.madh = ctdh.madh
    INNER JOIN San_pham sp ON ctdh.masp = sp.masp
    WHERE hd.mahd = @mahd;
END
GO
-- Tra cứu đơn đặt hàng

CREATE PROCEDURE TraCuuDonDatHang
    @madh char(5)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem đơn đặt hàng có tồn tại hay không
    IF NOT EXISTS (SELECT * FROM Don_dat_hang WHERE madh = @madh)
    BEGIN
        PRINT 'Đơn đặt hàng không tồn tại.';
        RETURN;
    END;

    -- Lấy thông tin về đơn đặt hàng
    SELECT *
    FROM Don_dat_hang
    WHERE madh = @madh;
END
GO

-- Tra cứu thông tin khách hàng

CREATE PROCEDURE TraCuuThongTinKhachHang
    @makh CHAR(4)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem mã khách hàng có tồn tại hay không
    IF NOT EXISTS (SELECT * FROM Khach_hang WHERE makh = @makh)
    BEGIN
        PRINT 'Khách hàng không tồn tại.';
        RETURN;
    END;

    -- Lấy thông tin về khách hàng
    SELECT *
    FROM Khach_hang
    WHERE makh = @makh;
END
GO
-- Tra cứu phiếu giao hàng

CREATE PROCEDURE TraCuuPhieuGiaoHang
    @mapg CHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem mã phiếu giao hàng có tồn tại hay không
    IF NOT EXISTS (SELECT * FROM Phieu_giao_hang WHERE mapg = @mapg)
    BEGIN
        PRINT 'Phiếu giao hàng không tồn tại.';
        RETURN;
    END;

    SELECT pg.mapg, pg.ngay_giao,
           ddh.madh, ddh.ngay_dat, ddh.dinh_ky, ddh.tong_gia,
           ctdh.masp, ctdh.so_luong,
           sp.ten_sp, sp.loai_sp, sp.so_seri_sx
    FROM Phieu_giao_hang pg
    INNER JOIN Don_dat_hang ddh ON pg.madh = ddh.madh
    INNER JOIN CTDH ctdh ON ddh.madh = ctdh.madh
    INNER JOIN San_pham sp ON ctdh.masp = sp.masp
    WHERE pg.mapg = @mapg;
END
GO

-------------------DỮ LIỆU----------------------------

-- Dữ liệu cho bảng Khach_hang
INSERT INTO Khach_hang (makh, ho_ten, dia_chi, sdt, loai_khach)
VALUES ('KH01', N'Nguyễn Văn A', N'123 Đường ABC', '0123456789', N'Khách lẻ'),
       ('KH02', N'MTV', N'456 Đường XYZ', '9876543210', N'Công ty'),
	   ('KH03', N'Trần Thị B', N'789 Đường DEF', '0123456780', N'Khách lẻ'),
       ('KH04', N'ABC Company', N'789 Đường XYZ', '0987654321', N'Công ty'),
       ('KH05', N'Phạm Văn C', N'321 Đường MNO', '0123456709', N'Khách lẻ');


-- Dữ liệu cho bảng Phieu_qua_tang
set dateformat ymd
INSERT INTO Phieu_qua_tang (mapqt, ngay_dk, ngay_nhan, trang_thai, makh)
VALUES ('PQT01', '2023-01-01', '2023-01-02', 1, 'KH01'),
       ('PQT02', '2023-02-01', '2023-02-02', 0, 'KH02');

-- Dữ liệu cho bảng Hop_dong
set dateformat ymd
INSERT INTO Hop_dong (mahd, ngay_bd, ngay_kt, mo_ta, khuyen_mai, thanh_toan, makh)
VALUES ('HD001', '2023-01-01', '2023-12-31', N'Mô tả 1', 10, N'Tiền mặt', 'KH01'),
       ('HD002', '2023-02-01', '2023-12-31', N'Mô tả 2', 15, N'Tín dụng', 'KH02');

-- Dữ liệu cho bảng Nhan_vien
set dateformat ymd
INSERT INTO Nhan_vien (manv, ho_ten, ngay_sinh, gioi_tinh, dia_chi, sdt, vi_tri)
VALUES ('NV001', N'Nguyễn Văn Nam', '1990-01-01', N'Nam', N'789 Đường XYZ', '0123456789', N'Nhân viên bán hàng'),
       ('NV002', N'Trần Thị Nữ', '1995-01-01', N'Nữ', N'456 Đường ABC', '9876543210', N'Nhân viên giao hàng');

-- Dữ liệu cho bảng Don_dat_hang 
set dateformat ymd
INSERT INTO Don_dat_hang (madh, ngay_dat, dinh_ky, tong_gia, manv, mahd)
VALUES ('DDH01', '2023-01-01', N'Hàng ngày', 1000000, 'NV001', 'HD001'),
       ('DDH02', '2023-02-01', N'Hàng tháng', 2000000, 'NV002', 'HD002');

-- Dữ liệu cho bảng San_pham
INSERT INTO San_pham (masp, ten_sp, loai_sp, so_seri_sx)
VALUES ('SP01', N'Sản phẩm 1', N'Loại 1', 'SERI001'),
       ('SP02', N'Sản phẩm 2', N'Loại 2', 'SERI002');

-- Dữ liệu cho bảng CT_khuyen_mai
set dateformat ymd
INSERT INTO CT_khuyen_mai (makm, ten_ct, tg_bd, tg_kt, dieu_kien)
VALUES ('CTKM01', N'Chương trình 1', '2023-01-01', '2023-02-01', N'Điều kiện 1'),
       ('CTKM02', N'Chương trình 2', '2023-02-01', '2023-03-01', N'Điều kiện 2');
GO

-- Dữ liệu cho bảng Qua_tang
INSERT INTO Qua_tang (maqt, ten_qua)
VALUES ('QT001', N'Quà tặng 1'),
       ('QT002', N'Quà tặng 2');

-- Dữ liệu cho bảng CTKM
INSERT INTO CTKM (makm, maqt, qua_muon_nhan)
VALUES ('CTKM01', 'QT001', N'Ti vi'),
       ('CTKM02', 'QT002', N'Tủ lạnh');

-- Dữ liệu cho bảng CTPQT
INSERT INTO CTPQT (so_luong, makm, maqt, mapqt)
VALUES (2, 'CTKM01', 'QT001', 'PQT01'),
       (1, 'CTKM02', 'QT002', 'PQT02');

-- Dữ liệu cho bảng CTDH
INSERT INTO CTDH (masp, madh, so_luong, hinh_thuc, chiet_khau)
VALUES ('SP01', 'DDH01', 2, N'Mua', 10),
       ('SP02', 'DDH02', 3, N'Thuê', 20);

-- Dữ liệu cho bảng Phieu_sua_chua
set dateformat ymd
INSERT INTO Phieu_sua_chua (maps, mo_ta, ngay_sua_chua, phi_sua_chua, manv)
VALUES ('PSC001', N'Mô tả 1', '2023-01-01', 100000, 'NV001'),
       ('PSC002', N'Mô tả 2', '2023-02-01', 200000, 'NV002');

-- Dữ liệu cho bảng CTSC
INSERT INTO CTSC (masp, madh, maps)
VALUES ('SP01', 'DDH01', 'PSC001'),
       ('SP02', 'DDH02', 'PSC002');

-- Dữ liệu cho bảng Phieu_giao_hang
set dateformat ymd
INSERT INTO Phieu_giao_hang (mapg, ngay_giao, manv, madh)
VALUES ('PGH01', '2023-04-20', 'NV001', 'DDH01'),
       ('PGH02', '2023-05-05', 'NV002', 'DDH02');

-- Dữ liệu cho bảng Phieu_thu
set dateformat ymd
INSERT INTO Phieu_thu (ma_phieu_thu, ngay_thu, tong, manv, mapg)
VALUES ('PT001', '2023-04-22', 500000, 'NV001', 'PGH01'),
       ('PT002', '2023-05-07', 800000, 'NV002', 'PGH02');
