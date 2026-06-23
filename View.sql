--1. Tạo view vwHangTon với các thông tin: mã hàng, tên hàng, số lượng tồn
 create view vwHangTon
 as
 select MaMH,TenMH,SoLuongTon
 from MatHang
--2. Tạo view vwVanPhongPham với các thông tin: mã hàng, tên hàng, số lượng tồn,
--đơn giá nhập, tên loại hàng của các mặt hàng loại văn phòng phẩm
create view vwVanPhongPham
as
select MaMH, TenMH, SoLuongTon,
		DgNhap,
		TenLoaiHang
from MatHang as MH
join LoaiHang as LH
on MH.MaLoaiHang = LH.MaLoaiHang
WHERE LH.TenLoaiHang = N'Văn phòng phẩm';
--3. Tạo view vwHopBut với các thông tin: mã hàng, tên hàng, số lượng tồn, đơn giá
--nhập của các mặt hàng là hộp bút
create view vwHopBut 
as
select	MaMH,
		TenMH,
		SoLuongTon,
		DgNhap
from MatHang
where TenMH like N'Hộp bút%'
--4. Tạo view vwVPPgiabehon50 với các thông tin: mã hàng, tên hàng, số lượng tồn,
--đơn giá nhập, tên loại hàng của các mặt hàng loại văn phòng phẩm có giá bán dưới
--50000

create view vwVPPgiabehon50 
as
select MaMH,TenMH,SoLuongTon,DgNhap,TenLoaiHang
from MatHang as MH
		JOIN
	 LoaiHang as LH
	 ON MH.MaLoaiHang=LH.MaLoaiHang
where DgBan < 50000 and TenLoaiHang like N'Văn phòng phẩm'
--5. Tạo view vwTonTren400 với các thông tin: mã hàng, tên hàng, số lượng tồn, đơn
--giá nhập của các mặt hàng là có số lượng tồn trên 400
create view vwTonTren400
as
select MaMH,TenMH,SoLuongTon,DgNhap 
from MatHang
where SoLuongTon > 400
--6. Tạo view vwVPPSTK với các thông tin: mã hàng, tên hàng, số lượng tồn, đơn giá
--nhập, tên loại hàng của các mặt hàng loại văn phòng phẩm hoặc sách tham khảo
create view vwVPPSTK
as
select MaMH,TenMH,SoLuongTon,DgNhap,TenLoaiHang
from MatHang as MH
	Join 
	LoaiHang as LH
	on MH.MaLoaiHang = LH.MaLoaiHang
where LH.TenLoaiHang IN (N'Văn phòng phẩm', N'Sách tham khảo');
--7. Tạo view vwVPPSTK400 với các thông tin: mã hàng, tên hàng, số lượng tồn, đơn
--giá nhập, tên loại hàng của các mặt hàng loại văn phòng phẩm hoặc sách tham khảo
--có số số lượng tồn từ 400 trở lên
CREATE view vwVPPSTK400
as
select MaMH,TenMH,SoLuongTon,DgNhap,TenLoaiHang
from MatHang as MH
	Join 
	LoaiHang as LH
	on MH.MaLoaiHang = LH.MaLoaiHang
where LH.TenLoaiHang IN (N'Văn phòng phẩm', N'Sách tham khảo') and SoLuongTon > 400
--8. Tạo view vwKhachHangNu với các thông tin: mã khách hàng, họ, tên khách hàng,
--địa chỉ, điện thoại

create view vwKhachHangNu
as
select MaKH, HoKH, TenKH, DiaChi, DienThoai
from KhachHang
where Phai = N'Nữ'

--9. Tạo view vwNhanVienNu với các thông tin: mã nhân viên, họ, tên nhân viên, tuổi
--nhân viên
create view vwNhanVienNu
as
select MaNV,HoNV, TenNV, year(getdate()) - year(NgaySinh) as Tuoi
from NhanVien
where GioiTinh = N'Nữ'
--10. Tạo view vwDsHoaDon với các thông tin: Mã hóa đơn, mã khách hàng và ngày lập
--hóa đơn
create view vwDsHoaDon 
as
select MaHD,MaKH,NgayDH
from DonDatHang
--11. Tạo view vwThongTinHoaDon với các thông tin: mã hóa đơn, họ, tên nhân viên,
--ngày lập hóa đơn.
create view vwThongTinHoaDon
as
select MaHD, HoNV,TenNV,NgayDH
from DonDatHang as DDH
	JOIN
	NhanVien as NV
	ON DDH.MaNV = NV.MaNV

--12. Tạo view vwHoaDonTTTienMat với các thông tin: mã hóa đơn, họ và tên khách
--hàng, họ và tên nhân viên, ngày lập hóa đơn của những hóa đơn thanh toán bằng
--tiền mặt.
create view vwHoaDonTTTienMat
as
select MaHD, HoKH +' '+TenKH AS HoTenKH, HoNV +' '+ TenNV AS HoTenNV,
		NgayDH AS NgayLapHD
from DonDatHang as DDH
		join
		KhachHang as KH
		ON DDH.MaKH = KH.MaKH
		join NhanVien as NV
		ON DDH.MaNV = NV.MaNV
where PTTT = N'tiền mặt'
--13. Tạo view vwThongTinHoadon918 với các thông tin: Mã hóa đơn, họ và tên nhân
--viên của các hóa đơn tháng 9 năm 2018
create view vwThongTinHoadon918
as
select MaHD, HoNV+' '+TenNV as HoTenNV
from DonDatHang as DDH
	JOIN
	NhanVien as NV
	ON DDH.MaNV = NV.MaNV
WHERE year(NgayDH) =2018 and month(NgayDH) = 9
--14. Tạo view vwTriGiaHoaDon với các thông tin: Mã hóa đơn, mã khách hàng, mã
--nhân viên, Tổng tiền hóa đơn.
create view vwTriGiaHoaDon
as
select CTDH.MaHD, KH.MaKH,NV.MaNV,
		sum(CTDH.SLDat*CTDH.DgBan) as TongTienHoaDon
FROM DonDatHang AS DDH
JOIN CTDonHang AS CTDH
  ON DDH.MaHD = CTDH.MaHD
JOIN KhachHang AS KH
  ON DDH.MaKH = KH.MaKH
JOIN NhanVien AS NV
  ON DDH.MaNV = NV.MaNV
group by CTDH.MaHD, KH.MaKH,NV.MaNV

--15. Tạo view vwTonVanPhongPham cho biết tổng số lượng tồn của loại hàng văn
--phòng phẩm với thông tin: tổng số lượng tồn
create view vwTonVanPhongPham
as
select sum(SoLuongTon) as TongSoLuongTon
from MatHang MH
	JOIN 
	LoaiHang as LH
	ON MH.MaLoaiHang = LH.MaLoaiHang
where TenLoaiHang = N'Văn phòng phẩm'
--16. Tạo view vwSoLuongTon cho biết tổng số lượng tồn của từng loại hàng với các
--thông tin: tên loại hàng, số lượng tồn
create view vwSoLuongTon 
as 
select TenLoaiHang, sum(SoLuongTon) as TongSoLuongTon
from MatHang MH
	JOIN 
	LoaiHang as LH
	ON MH.MaLoaiHang = LH.MaLoaiHang
group by LH.TenLoaiHang
--17. Tạo view vwSoLuongTonLonNhat cho biết loại hàng nào có tổng số lượng tồn lớn
--nhất với các thông tin: tên loại hàng, số lượng tồn
create view vwSoLuongTonLonNhat
as 
select top 1 with ties TenLoaiHang, sum(SoLuongTon) as TongSoLuongTon
from MatHang MH
	JOIN 
	LoaiHang as LH
	ON MH.MaLoaiHang = LH.MaLoaiHang
group by LH.TenLoaiHang
order by TongSoLuongTon DESC
--18. Tạo view vwSLHoaDonTTTienMat để xem tổng số lượng đơn đặt hàng thanh toán
--bằng tiền mặt với thông tin: Tổng số đơn hàng
create view vwSLHoaDonTTTienMat
as
select count(MaHD) as TongSoDonHang
from DonDatHang
where PTTT = N'tiền mặt'

--19. Tạo view vwSLNhanVien với thông tin: Giới tính, số lượng nhân viên
create view vwSLNhanVien
as
select GioiTinh , Count(MaNV) as SoLuongNhanVien
from NhanVien
group by GioiTinh
--20. Tạo view vwSLNhanVienNu với thông tin: Tổng số lượng nhân viên nữ
create view vwSLNhanVien
as
select GioiTinh , Count(MaNV) as SoLuongNhanVien
from NhanVien
where GioiTinh = N'Nữ'
group by GioiTinh

--21. Xóa view vwHangTon
drop view vwHangTon

