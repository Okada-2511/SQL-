
--1 Tạo thủ tục cập nhập tên loại hàng trong bảng LoaiHang với tham số mã loại hàng
--do người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi giao dịch
--có lỗi.
create procedure sp_update_loaihang(@MaLoaiHang nchar(5),@TenLoaiHang nvarchar(50))
as
	if exists (select *
				from LoaiHang
				where MaLoaiHang = @MaLoaiHang)
	begin transaction
		update LoaiHang
		set TenLoaiHang = @TenLoaiHang
		where MaLoaiHang = @MaLoaiHang
	commit transaction
	if @@error <> 0
		rollback transaction
--2. Tạo thủ tục xóa một loại hàng trong bảng LoaiHang với tham số mã loại hàng do
--người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi giao dịch có
--lỗi.
create procedure sp_delete_loaihang(@MaLoaiHang nchar(5))
as
	if exists (select *
				from LoaiHang
				where MaLoaiHang = @MaLoaiHang)
	begin transaction
		delete from LoaiHang
		where MaLoaiHang = @MaLoaiHang
	commit transaction
	if @@error <> 0
		rollback transaction
--3. Tạo thủ tục thêm một loại hàng trong bảng LoaiHang và xác định giao dịch hoàn
--thành hoặc quay lui khi giao dịch có lỗi.
create procedure sp_insert_loaihang(@MaLoaiHang nchar(5),@TenLoaiHang nvarchar(50))
as
	if not exists (select * 
					from LoaiHang 
					where MaLoaiHang = @MaLoaiHang )
	begin transaction
		insert into LoaiHang(MaLoaiHang,TenLoaiHang)
		values(@MaLoaiHang,@TenLoaiHang)
	commit transaction
	if @@error <> 0 
		rollback transaction
--4. Tạo thủ tục cập nhập thông tin hàng hóa trong bảng MatHang với tham số mã mặt
--hàng do người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi giao
--dịch có lỗi.
create procedure sp_updaate_mathang(@MaMatHang nchar(6),@TenMH nvarchar(150),@DVT nvarchar(20),
					@SoLuongTon int,@DGiaNhap float,@DGiaBan float)
as
begin
	declare @Err int
	if exists (select *
				from MatHang
				where MaMH = @MaMatHang )
	begin transaction
		update MatHang
		set TenMH = @TenMH,
			DonViTinh = @DVT,
			SoLuongTon = @SoLuongTon,
			DgNhap = @DGiaNhap,
			DgBan = @DGiaBan
		where MaMH = @MaMatHang
	set @Err = @@ERROR 
	if @Err <> 0 
		rollback transaction
	else
		commit transaction
end
--5. Tạo thủ tục xóa một hàng hóa trong bảng MatHang với tham số mã mặt hàng do
--người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi giao dịch có
--lỗi.
create procedure sp_delete_mathang(@MaMH nchar(6))
as
begin
	declare @Err int
	if exists (select * 
				from MatHang
				where MaMH = @MaMH)
	begin transaction
		delete from MatHang
		where MaMH = @MaMH
	set @Err = @@ERROR
	if @Err <> 0 
		rollback transaction
	else
		commit transaction
end
--6. Tạo thủ tục thêm một hàng hóa trong bảng MatHang và xác định giao dịch hoàn
--thành hoặc quay lui khi giao dịch có lỗi.
create procedure sp_insert_mathang(@MaMH nchar(6),@TenMH nvarchar(150),@DVT nvarchar(20),
					@SLT int, @DGiaNhap float, @DGiaBan float, @MaLoaiHang nchar(5))
as
	if not exists (select *
					from MatHang
					where MaMH = @MaMH)
	begin transaction
		insert into MatHang(MaMH,TenMH,DonViTinh,SoLuongTon,DgNhap,DgBan,MaLoaiHang)
		values (@MaMH,@TenMH,@DVT,@SLT,@DGiaNhap,@DGiaBan,@MaLoaiHang)
	commit transaction
	if @@error <> 0 
		rollback transaction
--7. Tạo thủ tục cập nhập thông tin nhân viên trong bảng NhanVien với tham số mã nhân
--viên do người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi giao
--dịch có lỗi.
create procedure sp_update_nhanvien(@MaNV nchar(6),@HoNV nvarchar(100),@TenNV nvarchar(30),
					@NgaySinh datetime,@GioiTinh nvarchar(20),@DiaChi nvarchar(150),
					@DienThoai nvarchar(30), @Email nvarchar(50))
as
begin
	declare @Err int
	if exists (select * from NhanVien where MaNV = @MaNV)
	begin transaction
		update NhanVien
		set HoNV = @HoNV,TenNV = @TenNV,@NgaySinh = @NgaySinh, GioiTinh = @GioiTinh,
			DiaChi = @DiaChi,DienThoai = @DienThoai, Email = @Email
		where MaNV = @MaNV
	set @Err = @@ERROR
	if @Err <> 0 
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION
end
create procedure sp_update1_nhanvien(@MaNV nchar(6),
					@NgaySinh datetime)
as
	if exists (select * from NhanVien where MaNV = @MaNV)
	begin transaction
		update NhanVien
		set NgaySinh = @NgaySinh
		where MaNV = @MaNV
	commit transaction
	if @@ERROR <> 0
		 rollback transaction

execute sp_update1_nhanvien '120001','2005-1-2'
--8. Tạo thủ tục xóa một nhân viên trong bảng NhanVien với tham số mã nhân viên do
--người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi giao dịch có
--lỗi.
create procedure sp_delete_nhanvie1n(@MaNV nchar(6))
as
begin
	declare @Err int
	if exists (select * from NhanVien where MaNV =@MaNV)
	begin transaction
		delete from NhanVien
		where MaNV =@MaNV
	set @Err = @@ERROR
	if @Err <> 0
		rollback transaction
	ELSE
		COMMIT TRANSACTION
END
--9. Tạo thủ tục thêm một nhân viên trong bảng NhanVien và xác định giao dịch hoàn
--thành hoặc quay lui khi giao dịch có lỗi.
create procedure sp_insert_nhanvien(@MaNV nchar(6),@HoNV nvarchar(100),@TenNV nvarchar(30),
					@NgaySinh datetime,@GioiTinh nvarchar(20),@DiaChi nvarchar(150),
					@DienThoai nvarchar(30), @Email nvarchar(50))
as
	if not exists (select * from NhanVien where MaNV = @MaNV)
	begin transaction
		insert into NhanVien(MaNV,HoNV,TenNV,NgaySinh,GioiTinh,DiaChi,DienThoai,Email)
		values (@MaNV,@HoNV,@TenNV,@NgaySinh,@GioiTinh,@DiaChi,@DienThoai,@Email)
	commit transaction
	if @@error <>0 
		rollback transaction

--10.Tạo thủ tục cập nhập thông tin khách hàng trong bảng KhachHang với tham số mã
--khách hàng do người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi
--giao dịch có lỗi.
create procedure sp_update_khachang(@MaKH nchar(6),@HoKH nvarchar(100),@TenKH nvarchar(30),@Phai nvarchar(20),
									@DiaChi nvarchar(150),@DienThoai nvarchar(30),@Email nvarchar(50))
as
begin
	declare @Err int
	if exists (select * from KhachHang
				where MaKH = @MaKH )
	begin transaction
		update KhachHang
		set HoKH = @HoKH, TenKH = @TenKH , Phai = @Phai,DiaChi =@DiaChi,DienThoai= @DienThoai, Email = @Email
		where MaKH = @MaKH
	set @Err = @@error
	if @Err<> 0
		rollback transaction
	else
		commit transaction
end
	

--11.Tạo thủ tục xóa một khách hàng trong bảng KhachHang với tham số mã khách hàng
--do người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi giao dịch
--có lỗi.
create procedure sp_delel_khachhang(@MaKH nchar(6))
as
begin
	declare @Err int
	if exists (select * 
				from KhachHang
				where MaKH = @MaKH)
begin
	begin transaction
		delete from KhachHang
		where MaKH =@MaKH
	set @Err = @@ERROR 
	if @Err <> 0 
	rollback transaction
	else 
	commit transaction
end
end

--12.Tạo thủ tục thêm một khách hàng trong bảng KhachHang và xác định giao dịch
--hoàn thành hoặc quay lui khi giao dịch có lỗi.
create procedure sp_insert_khachang(@MaKH nchar(6),@HoKH nvarchar(100),@TenKH nvarchar(30),@Phai nvarchar(20),
									@DiaChi nvarchar(150),@DienThoai nvarchar(30),@Email nvarchar(50))
as
begin
declare @Err int
	if not exists ( select * 
					from KhachHang
					where MaKH = @MaKH)
begin
	begin transaction
	insert into KhachHang(MaKH,HoKH,TenKH,Phai,DiaChi,DienThoai,Email)
	values (@MaKH,@HoKH,@TenKH,@Phai,@DiaChi,@DienThoai,@Email)
	set @Err = @@ERROR
	if @Err <> 0 
		rollback transaction
	else 
		commit transaction
end
	else 
		print(N'K co Ma KH')
end
--13.Tạo thủ tục cập nhập thông tin đơn đặt hàng trong bảng DonDatHang với tham số
--mã hóa đơn do người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi
--giao dịch có lỗi.
create procedure sp_update_dondathang(@MaHD nchar(6),@NgayHD datetime2,@PTTT nvarchar(100),@NgayDKNH datetime2)
as
begin 
	if exists (select * 
				from DonDatHang
				where MaHD = @MaHD)
	declare @Err int
	begin transaction
		update DonDatHang
		set NgayDH = @NgayHD,
			PTTT =@PTTT,
			NgayDKNH =@NgayDKNH
		where MaHD = @MaHD
	set @Err = @@error
	if @Err <> 0 
		rollback transaction
	else
		commit transaction
end

--14.Tạo thủ tục xóa một đơn đặt hàng trong bảng DonDatHang với tham số mã hóa đơn
--do người dùng nhập và xác định giao dịch hoàn thành hoặc quay lui khi giao dịch
--có lỗi.
create  procedure sp_deletll_DonDatHang(@MaHD nchar(6))
as
begin
	declare @Err int
	if exists (select * from DonDatHang 
				where MaHD = @MaHD)
	begin
		begin transaction
			delete from DonDatHang
			where MaHD = @MaHD
		set @Err = @@ERROR
		if @Err <> 0
			rollback transaction
		else
		commit transaction
	end
	else
		print(N'Don Dat Hang Khong Ton Tai')
end


--15.Tạo thủ tục thêm một đơn đặt hàng trong bảng DonDatHang và xác định giao dịch
--hoàn thành hoặc quay lui khi giao dịch có lỗi.
create procedure sp_insert_dondathang(@MaHD nchar(6),@MaKH nchar(6), @MaNV nchar(6), @NgayDH datetime2, @PTTT nvarchar(100), @NgayDKNH datetime2)
as
begin
	declare @Err int
	if not exists ( select * from DonDatHang
					where MaHD =@MaHD)
	begin
		begin transaction
			insert into DonDatHang(MaHD,MaKH,MaNV,NgayDH,PTTT,NgayDKNH)
			values(@MaHD,@MaKH,@MaNV,@NgayDH,@PTTT,@NgayDKNH)
			set @Err = @@error
		if @Err <> 0 
			rollback transaction
		else
			commit transaction
	end
	else
		print(N'Da ton tai don dat hang')
end
	
--16.Tạo thủ tục cập nhập thông tin chi tiết đơn hàng trong bảng CTDonHang với tham
--số mã hóa đơn và mã mặt hàng do người dùng nhập và xác định giao dịch hoàn
--thành hoặc quay lui khi giao dịch có lỗi.
create procedure sp_update_ctdonhang(@MaHD nchar(6),@MaMH nchar(6),@SLDat int,@DGiaBan float)
as
begin
	declare @Err int
	if exists (select *
				from CTDonHang
				where MaHD = @MaHD and MaMH =@MaMH)
	begin
		begin transaction
			update CTDonHang
			set SLDat = @SLDat, DgBan = @DGiaBan
			where MaHD = @MaHD and MaMH =@MaMH
		set @Err = @@ERROR
		if @Err <> 0
			ROLLBACK TRANSACTION
		ELSE 
			commit transaction
	end
	else
		print(N'Khong ton tai CT Don Dat Hang nay')
end
--17.Tạo thủ tục xóa một chi tiết đơn hàng trong bảng CTDonHang với tham số mã hóa
--đơn và mã mặt hàng do người dùng nhập và xác định giao dịch hoàn thành hoặc
--quay lui khi giao dịch có lỗi.
create procedure sp_delete_CTDonHang (@MaHD nchar(6), @MaMH nchar(6))
as
begin
	declare @Err int
	if exists (select * 
				from CTDonHang
				where MaHD = @MaHD AND MaMH = @MaMH )
	begin
		begin transaction
		delete from CTDonHang 
		where MaHD = @MaHD AND MaMH = @MaMH

		set @Err = @@ERROR
		IF @Err<> 0
			rollback transaction
		else
			commit transaction
	end
	else
		print (N'CTDon Hang k ton tai')
end

--18.Tạo thủ tục thêm một chi tiết đơn hàng trong bảng CTDonHang và xác định giao
--dịch hoàn thành hoặc quay lui khi giao dịch có lỗi.
create procedure sp_insert_CTDonHang(@MaHD nchar(6),@MaMH nchar(6),@SLDat int,@DGiaBan float)
as
begin
	declare @Err int
	if not exists (select * from CTDonHang where MaHD = @MaHD and MaMH = @MaMH)
	begin
		begin transaction
			insert into CTDonHang(MaHD,MaMH,SLDat,DgBan)
			values(@MaHD,@MaMH,@SLDat,@DGiaBan)
			
		set @Err = @@error
		if @Err <> 0 
			rollback transaction
		else
			commit transaction
	end
	else
		print (N'Da ton tai chi tiet don hang nay')
end