--Thực hiện tạo các trigger theo yêu cầu như sau:
--1. Số lượng tồn của hàng hóa phải lớn hơn hoặc bằng 0
create trigger tg_soluongton
on MatHang
for insert,update
as
if exists (select * from inserted where inserted.SoLuongTon<0)
	begin
		print('So luong ton phai lon hon hoac bang 0')
		rollback tran
	end
--2. Số lượng đặt hàng phải nhỏ hơn hoặc bằng số lượng tồn
create trigger tg_SoLuongDat
on CTDonHang
for insert,update
as
if exists (select * from inserted join MatHang on inserted.MaMH = MatHang.MaMH
			where inserted.SLDat > MatHang.SoLuongTon)
	begin
		print (N'Số lượng đặt hàng phải nhỏ hơn hoặc bằng số lượng tồn')
		rollback tran
	end
--
 Insert Into CTDonHang values ('S00010','VP0004',200, 70000)

--3. Tự động cập nhật lại số lượng tồn của một mặt hàng trong bảng MatHang khi mặt
--hàng đó được bán ra
create trigger tg_capnhatslton
on CTDonHang
for insert
as 
	begin
		update MatHang
		set SoLuongTon = SoLuongTon - inserted.SLDat
		from inserted join MatHang on inserted.MaMH = MatHang.MaMH
	end

--4. Ngày dự kiến nhận hàng phải lớn hơn hoặc bằng ngày đặt hàng
create trigger tg_NgayDKNDLonHonNgayDH
on DonDatHang
for insert,update
as
if exists (select * from inserted 
			where inserted.NgayDKNH < inserted.NgayDH)
	begin
		print(N'Ngày dự kiến nhận hàng phải lớn hơn hoặc bằng ngày đặt hàng')
		rollback tran
	end
--5. Trong bảng MatHang, đơn giá nhập phải < đơn giá bán
create trigger tg_dongianhaplonhongiaban
on MatHang
for insert,update 
as 
if exists (select * from inserted where inserted.DgNhap >= inserted.DgBan)
	begin
		print(N'đơn giá nhập phải < đơn giá bán')
		rollback tran
	end
--6. Giới tính nhân viên có giá trị Nam hoặc Nữ
create trigger tg_gioitinhnhanvien
on NhanVien
for insert,update
as
if exists (select * from inserted where inserted.GioiTinh not in ('Nam',N'Nữ'))
	begin
		print(N'Giới tính nhân viên phai có giá trị Nam hoặc Nữ')
		rollback tran
	end
--7. Giới tính khách hàng có giá trị Nam hoặc Nữ
create trigger tg_gioitinhkhachhang
ON KhachHang
for insert,update
as
if exists (select * from inserted where inserted.Phai not in ('Nam',N'Nữ'))
	begin
		print(N'Giới tính khách hàng phai có giá trị Nam hoặc Nữ')
		rollback tran
	end
--8. Ngày đặt hàng phải nhỏ hơn hoặc bằng ngày hiện hành
create trigger tg_ngaydhnhohonngayhienhanh
on DonDatHang
for insert,update
as
if exists (select * from inserted where inserted.NgayDH > CAST(GETDATE()))
	begin
		print(N'Ngày đặt hàng phải nhỏ hơn hoặc bằng ngày hiện hành')
		rollback tran
	end