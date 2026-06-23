--1. Tạo hàm cho biết số lượng đơn đặt hàng với tham số truyền vào là mã nhân viên 
create function f_sldondathangtheonv(@MaNV nchar(6))
returns int
as
	begin
		Declare @SLDH int
		select @SLDH = count(MaHD) 
		from DonDatHang
		where MaNV = @MaNV
		return @SLDH
	end


--2. Tạo hàm xem danh sách các mặt hàng theo loại hàng (trả về dạng bảng) 
create function f_dsmathangtheoloaihang(@MaLH nchar(5))
returns table
as
	
	return
		(select * 
		from MatHang
		where MaLoaiHang = @MaLH)


--3. Tạo hàm tính lãi cho từng mặt hàng (giá bán – giá mua)* số lượng đặt cho từng mặt 
--hàng  
create function f_tinhlaitheomathang()
returns table
as
	return
		(
		select MH.TenMH,MH.DgNhap,CTDH.DgBan,
		SUM(CTDH.SLDat) as TongSoLuongDat,
		--(CTDH.DgBan - MH.DgNhap) * SUM(CTDH.SLDat) as TienLai
		sum((CTDH.DgBan - MH.DgNhap) * CTDH.SLDat) as TienLai
		from CTDonHang as CTDH 
		JOIN MatHang as MH on CTDH.MaMH = MH.MaMH
		group by MH.TenMH,MH.DgNhap,CTDH.DgBan
		)

---


--4. Tạo hàm tính lãi cho từng mặt hàng (giá bán – giá mua)* số lượng đặt cho từng mặt 
--hàng, với mã mặt hàng là tham số truyền vào. 
create function f_tinhlaicothamso(@MaMatHang nchar(6))
returns table
as
	return
	(
		select Sum(CTDH.SLDat) as TongSoLuongDat,
		(CTDH.DgBan - MH.DgNhap) * SUM(CTDH.SLDat) as TienLai
		from CTDonHang as CTDH 
		JOIN MatHang as MH
		on CTDH.MaMH = MH.MaMH
		where CTDH.MaMH = @MaMatHang
		group by CTDH.DgBan , MH.DgNhap
	)

--5. Tạo hàm cho biết số lượng đơn đặt hàng theo từng nhân viên (gồm thông tin Mã 
--nhân viên, Họ tên nhân viên, Số lượng đơn đặt hàng) 
create function f_slddhtheonhanvien()
returns table
as
	return
	(
		select NV.MaNV,NV.HoNV +' '+NV.TenNV as HoTen, COUNT(DDH.MaHD) AS SoLuongDonDatHang
		from NhanVien as NV 
		JOIN DonDatHang as DDH
		ON NV.MaNV = DDH.MaNV
		group by NV.MaNV,NV.HoNV,NV.TenNV
	)


--6. Tạo hàm cho biết số lượng đơn đặt hàng theo từng khách hàng (gồm thông tin Mã 
--khách hàng, Họ tên khách hàng, Số lượng đơn đặt hàng) 
create function f_sldondathangtheokhachhang()
returns table
as
	return
	(
		select KH.MaKH , KH.HoKH +' '+KH.TenKH as HoTen, COUNT(DDH.MaHD) as SLDH
		from KhachHang as KH
		JOIN DonDatHang AS DDH on KH.MaKH = DDH.MaKH
		Group by  KH.MaKH , KH.HoKH,KH.TenKH
	)


--7. Tạo hàm cho biết số lượng đơn đặt hàng với tham số truyền vào là mã khách hàng 
create function f_slddhtheo_kh_cothamso(@MaKhachHang nchar(6))
returns int
as
	begin
	declare @SLDDH int
	select @SLDDH = COUNT(DDH.MaHD) 
	from KhachHang as KH
		JOIN DonDatHang AS DDH on KH.MaKH = DDH.MaKH
	where DDH.MaKH = @MaKhachHang
	return @SLDDH 
	end

	
--8. Tạo hàm cho biết số lượng tồn theo từng mặt hàng (gồm thông tin Mã mặt hàng, 
--Tên mặt hàng, Số lượng tồn) 
create function f_soLuongTonTheoTUNGmathang()
returns table
as
	return
	(
		select MaMH,TenMH,SoLuongTon
		from MatHang
	)
select * from f_soLuongTonTheoTUNGmathang()
--9. Tạo hàm cho biết số lượng tồn với tham số truyền vào là mã mặt hàng 
create function f_soluongtontheomh_cothamso(@MaMH nchar(6))
returns int
as
	begin
	declare @SLT int
	select @SLT = SoLuongTon 
	from MatHang
	where MaMH = @MaMH
	return @SLT
	end


--10. Tạo hàm cho biết tổng số lượng tồn theo từng loại hàng (gồm thông tin Mã loại 
--hàng, Tên loại hàng, Tổng số lượng tồn) 
create function f_soluongtontheoloaihang()
returns table
as
	return
	(
		select LH.MaLoaiHang,LH.TenLoaiHang, SUM (MH.SoLuongTon) as TongSoLuongTon
		from MatHang as MH
		JOIN LoaiHang as LH on MH.MaLoaiHang = LH.MaLoaiHang
		group by LH.MaLoaiHang,LH.TenLoaiHang
	)

select * from f_soluongtontheoloaihang()
--11. Tạo hàm cho biết tổng số lượng tồn với tham số truyền vào là mã loại hàng 
create function f_tongsoluongton_cothamso(@MaLH nchar(5))
returns int
as
	begin
		declare @TSLT int
		select @TSLT = SUM(MH.SoLuongTon)
		from MatHang as MH
		JOIN LoaiHang as LH on MH.MaLoaiHang = LH.MaLoaiHang
		where MH.MaLoaiHang = @MaLH
		return @TSLT
	end
select dbo.f_tongsoluongton_cothamso('GS')
--12. Tạo hàm cho biết tổng số lượng hàng trong từng hóa đơn (gồm thông tin Mã hóa 
--đơn, Họ tên nhân viên, Họ tên khách hàng, Tổng số lượng) 
create function f_tongsoluonghangtheotunghoadon()
returns table
as
	return
	(
		select DDH.MaHD, NV.HoNV +' '+NV.TenNV as HoTeNV, KH.HoKH +' '+KH.TenKH as HoTenKH,
		sum(CTDH.SLDat) as TongSoLuong
		from KhachHang as KH
		JOIN DonDatHang as DDH on KH.MaKH = DDH.MaKH
		JOIN NhanVien as NV on DDH.MaNV = NV.MaNV
		JOIN CTDonHang as CTDH on DDH.MaHD = CTDH.MaHD
		group by DDH.MaHD, NV.HoNV,NV.TenNV,KH.HoKH ,KH.TenKH
	)
select * from f_tongsoluonghangtheotunghoadon()
--13. Tạo hàm cho biết tổng số lượng hàng trong hóa đơn với tham số truyền vào là mã 
--hóa đơn 
create function f_tonsodh_cothamso(@MaHD nchar(6))
returns int
as
	begin
	declare @TSLH int
	select @TSLH = SUM(SLDat) 
	From CTDonHang
	where MaHD = @MaHD
	return @TSLH 	
	end
select dbo. f_tonsodh_cothamso('S00001')
--14. Tạo hàm cho biết trong từng hóa đơn có bao nhiêu mặt hàng (gồm thông tin Mã hóa 
--đơn, Họ tên nhân viên, Họ tên khách hàng, Tổng số mặt hàng) 
create function f_hoadoncobnmathang()
returns table
as
	return
	(
		select MaHD,COUNT(MaMH) AS TongSoMatHang
		from CTDonHang
		group by MaHD
	)

--15. Tạo hàm cho biết trong từng hóa đơn có bao nhiêu mặt hàng với tham số truyền vào 
--là mã hóa đơn
create function f_hoadoncobnmathang_cothamso(@MaHoaDon nchar(6))
returns int
as
	begin
	declare @TongSoMatHang int
	select @TongSoMatHang = count (MaMH) 
	from CTDonHang
	where MaHD = @MaHoaDon
	return @TongSoMatHang 
	end

select dbo.f_hoadoncobnmathang_cothamso('S00004')