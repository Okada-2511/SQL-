
--1. Xem thông tin khách hàng
create procedure sp_khachhang
as
select * 
from KhachHang

execute sp_khachhang
--2. Xem thông tin nhân viên
create procedure sp_nhanvien
as
select *
from NhanVien

execute sp_nhanvien
--3. Xem đơn giá của một mặt hàng
create procedure sp_dongiamathang
as
select MaMH,TenMH,DgBan
from MatHang

execute sp_dongiamathang
--4. Xem số lượng tồn của một mặt hàng
create procedure sp_mathang_soluongton
as
select MaMH,TenMH,SoLuongTon
from MatHang

execute sp_mathang_soluongton
--5. Cho biết danh sách 5 mặt hàng có số lượng tồn nhiều nhất
create procedure sp_mathang_sltontop5
as
select top 5 with ties MaMH,TenMH,SoLuongTon
from MatHang
order by SoLuongTon desc

execute sp_mathang_sltontop5
--6. Cho biết danh sách 3 hóa đơn có trị giá bán lớn nhất
create procedure sp_hoadon_top3
as
select top 3 with ties MaHD,sum(SLDat*DgBan) as Trigiaban
from CTDonHang
group by MaHD
order by Trigiaban desc


--7. Cho biết trị giá của mỗi hóa đơn
create procedure sp_mathang_trigia
as
select MaHD,sum(SLDat*MH.DgNhap) as TriGiaMua, sum(SLDat*CTDH.DgBan) as TriGiaBan
from CTDonHang AS CTDH
join MatHang MH
ON CTDH.MaMH = MH.MaMH
group by MaHD

execute sp_mathang_trigia
--8. Xem thông tin khách hàng với mã khách hàng do người dùng nhập
create procedure sp_ttkhachhang @MaKH nchar(6)
as
select *
from KhachHang
where @MaKH = MaKH

execute sp_ttkhachhang @MaKH = '120013'
--9. Xem đơn giá của một mặt hàng với mã mặt hàng do người dùng nhập
create procedure sp_dongia_mathang @MaMH nchar(6)
as
	select MaMH,TenMH,DgBan
	from MatHang
	where @MaMH=MaMH

	execute sp_dongia_mathang @MaMH = 'TT0002'
--10. Xem thông tin hóa đơn gồm có: mã hóa đơn, mã nhân viên, họ tên nhân viên, mã
--khách hàng, họ tên khách hàng, ngày hóa đơn với mã số khách hàng do người dùng
--yêu cầu.
create procedure sp_tthoadon @thang int,@nam int, @MaKH nchar(6)
as
	select DDH.MaHD,NV.MaNV,NV.HoNV + ' '+NV.TenNV as HoTenNV,
	kh.MaKH, KH.HoKH +' '+KH.TenKH as HoTenKH,
	DDH.NgayDH
	from KhachHang as KH
	join
	DonDatHang as DDH 
	on DDH.MaKH=KH.MaKH
	join NhanVien as NV
	on DDH.MaNV = NV.MaNV
	where  MONTH(NgayDH)=@thang and YEAR(NgayDH) = @nam and  DDH.MaKH = @MaKH

	execute sp_tthoadon @thang = 9, @nam = 2018 , @MaKH = '120012'
--11. Xem thông tin hóa đơn gồm có: mã hóa đơn, mã nhân viên, họ tên nhân viên, mã
--khách hàng, họ tên khách hàng, ngày hóa đơn với mã số nhân viên do người dùng yêu
--cầu.
create procedure sp_tthoadon_1 @MaNV nchar(6)  
as
	select DDH.MaHD,NV.MaNV,NV.HoNV + ' '+NV.TenNV as HoTenNV,
	kh.MaKH, KH.HoKH +' '+KH.TenKH as HoTenKH,
	DDH.NgayDH
	from DonDatHang as DDH
	join 
	KhachHang as KH on DDH.MaKH=KH.MaKH
	join
	NhanVien as NV on DDH.MaNV= NV.MaNV
	where @MaNV = DDH.MaNV

	execute sp_tthoadon_1 @MaNV = '120002'
--12. Xem thông tin hóa đơn gồm có: mã hóa đơn, mã nhân viên, họ tên nhân viên, mã
--khách hàng, họ tên khách hàng, ngày hóa đơn với mã số hóa đơn do người dùng yêu
--cầu.
create procedure sp_tthoadon2 @MaHD nchar(6) 
as
	select DDH.MaHD,NV.MaNV,NV.HoNV + ' '+NV.TenNV as HoTenNV,
	kh.MaKH, KH.HoKH +' '+KH.TenKH as HoTenKH,
	DDH.NgayDH
	from DonDatHang as DDH
	join 
	KhachHang as KH on DDH.MaKH=KH.MaKH
	join
	NhanVien as NV on DDH.MaNV= NV.MaNV
	where @MaHD = DDH.MaHD

	execute sp_tthoadon2 @MaHD='S00003'

--13. Xem thông tin hóa đơn gồm có: mã hóa đơn, mã nhân viên, họ tên nhân viên, mã
--khách hàng, họ tên khách hàng, ngày hóa đơn với ngày hóa đơn do người dùng yêu
--cầu.
create procedure sp_tthoadon_theongay @nam datetime,@thang datetime
as
	select DDH.MaHD,NV.MaNV,NV.HoNV + ' '+NV.TenNV as HoTenNV,
	kh.MaKH, KH.HoKH +' '+KH.TenKH as HoTenKH,
	DDH.NgayDH
	from DonDatHang as DDH
	join KhachHang as KH on DDH.MaKH=KH.MaKH
	join NhanVien as NV on DDH.MaNV=NV.MaNV
	where Month(NgayDH) = @thang and Year(NgayDH) = @nam

	execute sp_tthoadon_theongay @thang = 9 , @nam =2018
--14. Xem thông tin đơn hàng gồm mã hóa đơn, mã hàng, tên hàng, số lượng bán, đơn giá
--bán theo khoảng thời gian từ ngày đến ngày do người dùng yêu cầu.
create procedure sp_tthoadon_tungaydenngay @tungay int ,@denngay int
as
	select DDH.MaHD,CTDH.MaMH,MH.TenMH,CTDH.SLDat,CTDH.DgBan
	from DonDatHang as DDH
	join CTDonHang as CTDH on DDH.MaHD=CTDH.MaHD
	JOIN MatHang as MH on CTDH.MaMH = MH.MaMH
	where NgayDH>=@tungay and NgayDH <=@denngay

	execute sp_tthoadon_tungaydenngay @tungay = '2018-6-1', @denngay = '2018-12-1'
--15. Xem số lượng tồn của một mặt hàng, nếu số lượng tồn >=0 thì thông báo “còn hàng”,
--ngược lại thông báo “đã hết hàng”, với mã hàng do người dùng nhập
create procedure sp_ttsoluongton @MaMH nchar(6) , @soluongton int output
as
begin
	select @soluongton = SoLuongTon 
	from MatHang
	where MaMH = @MaMH
end

	declare @slt  int
	execute sp_ttsoluongton @MaMH = 'VP0004' , @soluongton = @slt output
	if(@slt>0) 
	print 'con hang' 
	else 
	print 'het hang'



---
create procedure sp_ttsoluongton1 @MaMH nchar(6) , @soluongton int output, @thongbao nvarchar(20) output
as
begin
	select @soluongton = SoLuongTon 
	from MatHang
	where MaMH =@MaMH

	if(@soluongton>0) 
		set @thongbao = 'con hang'
	else 
		set @thongbao = 'het hang'

end

	declare @slt int, @tb nvarchar(20)
	execute sp_ttsoluongton1 @MaMH = 'VP0004' , @soluongton = @slt output , @thongbao = @tb output
	select @tb 