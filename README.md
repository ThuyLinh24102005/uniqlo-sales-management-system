# Hệ thống quản lý bán hàng thời trang UNIQLO

## Giới thiệu dự án

Dự án xây dựng hệ thống quản lý bán hàng thời trang bằng C# WinForms và SQL Server.

Hệ thống hỗ trợ:
- Quản lý sản phẩm
- Quản lý khách hàng
- Quản lý hóa đơn và bán hàng
- Quản lý nhập hàng
- Quản lý tồn kho
- Quản lý nhân viên
- Quản lý đổi trả hàng hóa 
- Thống kê doanh thu

Ngoài các chức năng CRUD cơ bản, hệ thống tập trung tối ưu cơ sở dữ liệu bằng:
- Phân quyền người dùng
- Index tối ưu truy vấn
- View tổng hợp dữ liệu
- Stored Procedure xử lý nghiệp vụ
- Trigger kiểm tra và ghi log hệ thống

---

# Công nghệ sử dụng

- C#
- WinForms
- SQL Server
- SSMS
- Visual Studio 2022

---

# Chức năng nổi bật

## Phân quyền hệ thống
- Phân quyền Nhân viên bán hàng và Quản lý cửa hàng
- Tách quyền đọc/ghi dữ liệu
- Giới hạn truy cập các bảng quan trọng

## Tối ưu truy vấn với Index
- Clustered Index
- Non-clustered Index
- Filtered Index
- Covering Index
- Unique Index

## View
- View sản phẩm công khai
- View thống kê doanh thu
- View bảo mật bằng WITH ENCRYPTION
- View WITH CHECK OPTION

## Stored Procedure
- Thêm / xóa / cập nhật sản phẩm
- Tìm kiếm nhân viên
- Thống kê doanh thu khách hàng
- Kiểm tra dữ liệu hợp lệ

## Trigger
- Ghi log INSERT / UPDATE / DELETE
- Kiểm tra logic nghiệp vụ
- Kiểm tra tồn kho trước bán hàng
- Ghi log DDL
- Ngăn chặn xóa bảng quan trọng

---

# 📂 Cấu trúc thư mục

```bash
📦 uniqlo-sales-management-system
 ┣ 📂 database
 ┣ 📂 source-code
 ┣ 📂 ui-screenshots
 ┣ 📂 diagrams
 ┣ 📄 README.md
```

---

# Hình ảnh hệ thống

## Màn hình đăng nhập
<img width="712" height="435" alt="UI_Dangnhap" src="https://github.com/user-attachments/assets/7aebf9b1-87c4-477a-a91e-e6006b8989ae" />

## Màn hình chính
<img width="1085" height="688" alt="UI_Giaodienchinh" src="https://github.com/user-attachments/assets/8a4af449-ac81-4607-91c6-8642a705ec1c" />

## Quản lý sản phẩm
<img width="872" height="567" alt="UI_Sanpham" src="https://github.com/user-attachments/assets/d8a3df4d-d0c2-45fc-819c-2e2f1fda0377" />

## Quản lý khách hàng
<img width="915" height="658" alt="UI_Khachhang" src="https://github.com/user-attachments/assets/fb989a29-dc55-4fc0-aa5a-bd6baf39323f" />

## Quản lý nhập kho sản phẩm
<img width="922" height="724" alt="UI_Phieunhap" src="https://github.com/user-attachments/assets/12febc88-9ec1-452b-ba37-6153c0f2f7f9" />

---

# Vai trò thực hiện

Database Designer / System Analyst

- Thiết kế cơ sở dữ liệu
- Xây dựng SQL scripts
- Thiết kế giao diện WinForms
- Tối ưu và kiểm soát dữ liệu

