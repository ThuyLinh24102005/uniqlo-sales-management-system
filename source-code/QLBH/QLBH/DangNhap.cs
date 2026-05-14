using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLBH
{
    public partial class DangNhap : Form
    {
        public DangNhap()
        {
            InitializeComponent();
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có chắc chắn thoát?", "Xác nhận",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void btnDangNhap_Click(object sender, EventArgs e)
        {
            string username = txtTenDangNhap.Text.Trim();
            string password = txtMatKhau.Text.Trim();
            string role = "";

            if (rdoNhanVien.Checked)
                role = "nhanvien";
            else if (rdoQuanLy.Checked)
                role = "quanly";

            if (username == "" || password == "")
            {
                MessageBox.Show("Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!", "Thông báo");
                return;
            }

            if (role == "")
            {
                MessageBox.Show("Vui lòng chọn quyền đăng nhập!", "Thông báo");
                return;
            }

            if (username == "nv002" && password == "123" && role == "quanly")
            {
                MessageBox.Show("Đăng nhập quản lý thành công!");
                new Giaodienchinh().Show();
                this.Hide();
            }
            else if (username == "nv001" && password == "123" && role == "nhanvien")
            {
                MessageBox.Show("Đăng nhập nhân viên thành công!");
                new Giaodienchinh().Show();
                this.Hide();
            }
            else
            {
                MessageBox.Show("Sai thông tin đăng nhập!", "Lỗi");
            }
        }

        private void DangNhap_Load(object sender, EventArgs e)
        {

        }
    }
}
