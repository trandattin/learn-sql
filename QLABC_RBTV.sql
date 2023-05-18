-----------CÀI ĐẶT RBTV-----------------

---------RBTV miền giá trị-----------

--RB1

ALTER TABLE Khach_hang
ADD CONSTRAINT CK_LoaiKhach CHECK (loai_khach IN (N'Khách lẻ', N'Công ty'));

--RB2

ALTER TABLE Phieu_qua_tang
ADD CONSTRAINT CHK_Phieu_qua_tang_trang_thai CHECK (trang_thai IN (0, 1));

--RB3

ALTER TABLE Hop_dong
ADD CONSTRAINT CHK_Hop_dong_khuyen_mai CHECK (khuyen_mai BETWEEN 0 AND 100);

--RB4

ALTER TABLE Nhan_vien
ADD CONSTRAINT CHK_Nhan_vien_gioi_tinh CHECK (gioi_tinh IN (N'Nam', N'Nữ'));

--RB5

ALTER TABLE Don_dat_hang
ADD CONSTRAINT CHK_Don_dat_hang_tong_gia CHECK (tong_gia >= 0);

--RB6

ALTER TABLE CTPQT
ADD CONSTRAINT CHK_CTPQT_so_luong CHECK (so_luong >= 0);

--RB7

ALTER TABLE CTDH
ADD CONSTRAINT CHK_CTDH_so_luong CHECK (so_luong > 0);


--RB8

ALTER TABLE CTDH
ADD CONSTRAINT CK_hinh_thuc CHECK (hinh_thuc IN (N'Mua', N'Thuê'));	

--RB9

ALTER TABLE CTDH
ADD CONSTRAINT CHK_CTDH_chiet_khau CHECK (chiet_khau >= 0 AND chiet_khau <= 100);

--RB10

ALTER TABLE Phieu_thu
ADD CONSTRAINT CHK_Phieu_thu_tong CHECK (tong >= 0);

---------RBTV liên thộc tính-----------

--RB27

CREATE TRIGGER tr_CTKhuyenMai_ins_upd_TGBD_TGKT
ON CT_khuyen_mai  FOR INSERT, UPDATE
AS
IF  UPDATE(tg_bd) OR UPDATE (tg_kt)
	     IF EXISTS(SELECT * FROM inserted i WHERE i.tg_kt < i.tg_bd)	
	      BEGIN
	    	 RAISERROR (N'Thời gian kết thúc chương trình khuyến mãi không thể trước thời gian bắt đầu',15,1)
		     ROLLBACK TRAN
	      END
GO	

--RB28

CREATE TRIGGER tr_Phieuquatang_ins_upd_TGBD_TGKT
ON Phieu_qua_tang FOR INSERT, UPDATE
AS
IF  UPDATE(ngay_dk) OR UPDATE (ngay_nhan)
	     IF EXISTS(SELECT * FROM inserted i WHERE i.ngay_nhan < i.ngay_dk)	
	      BEGIN
	    	 RAISERROR (N'Thời gian nhận quà tặng không thể bắt đầu trước ngày đăng ký phiếu quà tặng',15,1)
		     ROLLBACK TRAN
	      END
GO	

--RB29

CREATE TRIGGER tr_Hopdong_ins_upd_BD_KT
ON Hop_dong FOR INSERT, UPDATE
AS
IF  UPDATE(ngay_bd) OR UPDATE (ngay_kt)
	     IF EXISTS(SELECT * FROM inserted i WHERE i.ngay_kt <= i.ngay_bd)	
	      BEGIN
	    	 RAISERROR (N'Thời gian kết thúc hợp đồng không thể bắt đầu trước thời gian kí hợp đồng',15,1)
		     ROLLBACK TRAN
	      END
GO	

--------RBTV liên bộ - liên quan hệ --------------

--RB46

CREATE TRIGGER tr_Hopdong_ins_upd_makh
ON Hop_dong FOR INSERT, UPDATE
AS
IF UPDATE(makh)
	IF NOT EXISTS(SELECT * FROM inserted l
					   WHERE l.makh IN (SELECT makh FROM Khach_hang))
	BEGIN
		RAISERROR (N'Mỗi hợp đồng phải liên quan đến một khách hàng', 15, 1);
		ROLLBACK TRANSACTION;
	END;
GO

CREATE TRIGGER tr_Khachhang_ins_upd_makh
ON Khach_hang FOR DELETE, UPDATE
AS
IF UPDATE(makh)
	IF EXISTS(SELECT * FROM deleted AS d WHERE EXISTS (SELECT * FROM Hop_dong WHERE makh = d.makh))
	BEGIN
		RAISERROR (N'Mỗi hợp đồng phải liên quan đến một khách hàng', 15, 1);
		ROLLBACK TRANSACTION;
	END;
GO

--RB47

CREATE TRIGGER tr_DonDatHang_ins_upd_mahd_ngay_giao
ON Don_dat_hang FOR INSERT, UPDATE
AS
IF UPDATE(madh) OR UPDATE(ngay_dat)
	IF EXISTS(SELECT * FROM inserted l 
	              WHERE l.ngay_dat > (SELECT Phieu_giao_hang.ngay_giao
									FROM Phieu_giao_hang 
									WHERE Phieu_giao_hang.madh = l.madh))
	BEGIN
		RAISERROR (N'Ngày giao đơn hàng phải sau hoặc bằng ngày đặt đơn hàng', 15, 1);
		ROLLBACK TRANSACTION;
	END;
GO

CREATE TRIGGER tr_PhieuGiaoHang_upd_madh_ngay_giao
ON Phieu_giao_hang FOR UPDATE
AS
BEGIN
    IF UPDATE(madh) OR UPDATE(ngay_giao)
    BEGIN
        IF EXISTS(
            SELECT * FROM inserted i
            WHERE EXISTS(
                SELECT * FROM Don_dat_hang d
                WHERE d.madh = i.madh
                AND d.ngay_dat > i.ngay_giao
            )
        )
        BEGIN
            RAISERROR ('Ngày giao đơn hàng phải sau hoặc bằng ngày đặt đơn hàng', 16, 1);
            ROLLBACK TRANSACTION;
        END;
    END;
END
GO

--RB48

CREATE TRIGGER tr_PhieuQuaTang_ins_upd_mapqt_ngay_nhan
ON Phieu_qua_tang
FOR INSERT, UPDATE
AS
IF UPDATE(mapqt) OR UPDATE(ngay_nhan)
BEGIN
	IF EXISTS (
        SELECT * FROM inserted AS i
        INNER JOIN CTPQT ct ON i.mapqt = ct.mapqt
		INNER JOIN CTKM  ct2 ON ct.maqt = ct2.maqt AND ct.makm = ct2.makm
		INNER JOIN CT_khuyen_mai  ct3 ON ct3.makm = ct2.makm
        WHERE i.ngay_nhan > ct3.tg_kt
    )
    BEGIN
        RAISERROR (N'Ngày nhận quà tặng phải trước ngày kết thúc chương trình khuyến mãi', 15, 1);
        ROLLBACK TRANSACTION;
    END;
END;

CREATE TRIGGER tr_CTPQT_upd_maqt_makm_mapqt
ON CTPQT
FOR UPDATE
AS
IF UPDATE(maqt) OR UPDATE(makm) OR UPDATE(mapqt)
BEGIN
	IF EXISTS (
        SELECT * FROM inserted AS i
        INNER JOIN Phieu_qua_tang AS p ON i.mapqt = p.mapqt
		INNER JOIN CTKM ct ON ct.maqt = i.maqt AND ct.makm = i.makm
		INNER JOIN CT_khuyen_mai ct2 ON ct2.makm = ct.makm
        WHERE p.ngay_nhan > ct2.tg_kt
    )
    BEGIN
        RAISERROR (N'Ngày nhận quà tặng phải trước ngày kết thúc chương trình khuyến mãi', 15, 1);
        ROLLBACK TRANSACTION;
    END;
END;

CREATE TRIGGER tr_CTKM_upd_maqt_makm
ON CTKM
FOR UPDATE
AS
IF UPDATE(maqt) OR UPDATE(makm)
BEGIN
	IF EXISTS (
        SELECT * FROM inserted AS i
		INNER JOIN CTPQT ct ON ct.maqt = i.maqt AND ct.makm = i.makm
        INNER JOIN Phieu_qua_tang AS p ON ct.mapqt = p.mapqt
		INNER JOIN CT_khuyen_mai  ct2 ON i.makm = ct.makm
        WHERE p.ngay_nhan > ct2.tg_kt
    )
    BEGIN
        RAISERROR (N'Ngày nhận quà tặng phải trước ngày kết thúc chương trình khuyến mãi', 15, 1);
        ROLLBACK TRANSACTION;
    END;
END;

CREATE TRIGGER tr_CTKhuyenmai_upd_del_tgkt_makm
ON CT_khuyen_mai
FOR UPDATE
AS
IF UPDATE(tg_kt) OR UPDATE(makm)
BEGIN
	IF EXISTS (
        SELECT * FROM inserted AS i
		INNER JOIN CTKM ct ON i.makm = ct.makm
		INNER JOIN CTPQT ct2 ON ct2.maqt = ct.maqt AND ct.makm = ct2.makm
        INNER JOIN Phieu_qua_tang AS p ON p.mapqt = ct2.mapqt
        WHERE p.ngay_nhan > i.tg_kt
    )
    BEGIN
        RAISERROR (N'Ngày nhận quà tặng phải trước ngày kết thúc chương trình khuyến mãi', 15, 1);
        ROLLBACK TRANSACTION;
    END;
END;

--RB49

CREATE TRIGGER tr_Hopdong_ins_upd_mahd_ngay_bd
ON Hop_dong FOR INSERT, UPDATE
AS
IF UPDATE(mahd) OR UPDATE(ngay_bd)
	IF EXISTS(SELECT * FROM inserted l 
	              WHERE l.ngay_bd > (SELECT Don_dat_hang.ngay_dat
									FROM Don_dat_hang 
									WHERE Don_dat_hang.mahd = l.mahd))
	BEGIN
		RAISERROR (N'Ngày kí hợp đồng phải trước hoặc bằng ngày đặt đơn hàng', 15, 1);
		ROLLBACK TRANSACTION;
	END;
GO

CREATE TRIGGER tr_Don_dat_hang_upd_mahd_ngay_dat
ON Don_dat_hang FOR UPDATE
AS
BEGIN
    IF UPDATE(mahd) OR UPDATE(ngay_dat)
    BEGIN
        IF EXISTS(
            SELECT * FROM inserted i
            WHERE EXISTS(
                SELECT * FROM Hop_dong AS h
                WHERE h.mahd = i.mahd
                AND h.ngay_bd > i.ngay_dat
            )
        )
        BEGIN
            RAISERROR ('Ngày kí hợp đồng phải trước hoặc bằng ngày đặt đơn hàng', 16, 1);
            ROLLBACK TRANSACTION;
        END;
    END;
END
GO

--RB50

CREATE TRIGGER tr_Phieugiaohang_ins_upd_mapg_ngay_giao
ON Phieu_giao_hang FOR INSERT, UPDATE
AS
IF UPDATE(mapg) OR UPDATE(ngay_giao)
	IF EXISTS(SELECT * FROM inserted l 
	              WHERE l.ngay_giao > (SELECT Phieu_thu.ngay_thu
									FROM Phieu_thu 
									WHERE Phieu_thu.mapg = l.mapg))
	BEGIN
		RAISERROR (N'Ngày thu tiền phải sau ngày giao hàng', 15, 1);
		ROLLBACK TRANSACTION;
	END;
GO


CREATE TRIGGER tr_Phieu_thu_upd_mapg_ngay_thu
ON Phieu_thu FOR UPDATE
AS
BEGIN
    IF UPDATE(mapg) OR UPDATE(ngay_thu)
    BEGIN
        IF EXISTS(
            SELECT * FROM inserted i
            WHERE EXISTS(
                SELECT * FROM Phieu_giao_hang p
                WHERE p.mapg = i.mapg
                AND p.ngay_giao > i.ngay_thu
            )
        )
        BEGIN
            RAISERROR ('Ngày thu tiền phải sau ngày giao hàng', 16, 1);
            ROLLBACK TRANSACTION;
        END;
    END;
END
GO
