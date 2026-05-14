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
    public partial class Quanlynhanvien : Form
    {
        BindingSource bsNV = new BindingSource();
        BindingSource bsTK = new BindingSource();
        KetNoi kn = new KetNoi();
        public Quanlynhanvien()
        {
            InitializeComponent();
        }
        private void btnTaoTaiKhoan_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtMaNV.Text))
            {
                MessageBox.Show("Vui lòng chọn nhân viên!");
                return;
            }
            txtMaNV_TK.Text = txtMaNV.Text;
            tabControl1.SelectedTab = tabPage2;
        }
        private void Quanlynhanvien_Load(object sender, EventArgs e)
        {
            LoadNhanVien();
            LoadTaiKhoan();
            bindingNavigator1.BindingSource = bsNV;
            tabControl1.SelectedIndexChanged += tabControl1_SelectedIndexChanged;
            cboQuyenhan.Items.AddRange(new string[] { "Quản lý", "Nhân Viên" });
        }
        private void LoadNhanVien()
        {
            DataTable dtNV = kn.LayDuLieu("SELECT * FROM NHANVIEN");

            bsNV.DataSource = null;       // reset trước
            bsNV.DataSource = dtNV;

            dgvNhanVien.DataSource = bsNV;
            bindingNavigator1.BindingSource = bsNV;

            dgvNhanVien.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }
        private void LoadTaiKhoan()
        {
            DataTable dtTK = kn.LayDuLieu("SELECT * FROM TAIKHOAN");

            bsTK.DataSource = null;       // reset trước
            bsTK.DataSource = dtTK;

            dgvTaiKhoan.DataSource = bsTK;
            bindingNavigator1.BindingSource = bsTK;

            dgvTaiKhoan.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }
        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tabControl1.SelectedTab == tabPage1) // Tab Nhân viên
            {
                bindingNavigator1.BindingSource = bsNV;
            }
            else if (tabControl1.SelectedTab == tabPage2) // Tab Tài khoản
            {
                bindingNavigator1.BindingSource = bsTK;
            }
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            string sql =
        $"INSERT INTO NHANVIEN VALUES('{txtMaNV.Text}', N'{txtTenNV.Text}', " +
        $"N'{txtChucVu.Text}', '{txtSDT.Text}', '{txtEmail.Text}')";

            kn.CapNhat(sql);
            LoadNhanVien();
            ClearNV();
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvNhanVien.CurrentRow == null) return;

            int r = dgvNhanVien.CurrentRow.Index;
            string ma = dgvNhanVien.Rows[r].Cells["MaNV"].Value.ToString();

            kn.CapNhat($"DELETE FROM NHANVIEN WHERE MaNV='{ma}'");
            LoadNhanVien();
        }

        private void btnCapNhat_Click(object sender, EventArgs e)
        {
            if (dgvNhanVien.CurrentRow == null) return;

            int r = dgvNhanVien.CurrentRow.Index;

            string ma = dgvNhanVien.Rows[r].Cells["MaNV"].Value.ToString();
            string ten = dgvNhanVien.Rows[r].Cells["HoTen"].Value.ToString();
            string chucvu = dgvNhanVien.Rows[r].Cells["ChucVu"].Value.ToString();
            string sdt = dgvNhanVien.Rows[r].Cells["SDT"].Value.ToString();
            string email = dgvNhanVien.Rows[r].Cells["Email"].Value.ToString();

            string sql = $@"
        UPDATE NHANVIEN SET 
            HoTen = N'{ten}',
            ChucVu = N'{chucvu}',
            SDT = '{sdt}',
            Email = '{email}'
        WHERE MaNV = '{ma}'";

            kn.CapNhat(sql);
            LoadNhanVien();
        }
        void ClearNV()
        {
            txtMaNV.Clear();
            txtTenNV.Clear();
            txtChucVu.Clear();
            txtSDT.Clear();
            txtEmail.Clear();
        }

        private void btnThemTK_Click(object sender, EventArgs e)
        {
            string sql =
            $@"INSERT INTO TAIKHOAN (MaTK, MaNV, TenDangNhap, MatKhau, QuyenHan)
                VALUES('{txtMaTK.Text}', '{txtMaNV_TK.Text}', 
                    '{txtTenDN.Text}', '{txtMK.Text}', N'{cboQuyenhan.Text}')";

            kn.CapNhat(sql);
            LoadTaiKhoan();
            ClearTK();
        }

        private void btnCapNhatTK_Click(object sender, EventArgs e)
        {
            if (dgvTaiKhoan.CurrentRow == null) return;

            int r = dgvTaiKhoan.CurrentRow.Index;

            string maTK = dgvTaiKhoan.Rows[r].Cells["MaTK"].Value.ToString();
            string tenDN = dgvTaiKhoan.Rows[r].Cells["TenDangNhap"].Value.ToString();
            string matKhau = dgvTaiKhoan.Rows[r].Cells["MatKhau"].Value.ToString();
            string quyenHan = dgvTaiKhoan.Rows[r].Cells["QuyenHan"].Value.ToString();

            string sql = $@"UPDATE TAIKHOAN SET TenDangNhap = '{tenDN}',MatKhau = '{matKhau}',QuyenHan = N'{quyenHan}'
            WHERE MaTK = '{maTK}'";

            kn.CapNhat(sql);
            LoadTaiKhoan();
        }

        private void btnXoaTK_Click(object sender, EventArgs e)
        {
            if (dgvTaiKhoan.CurrentRow == null) return;

            int r = dgvTaiKhoan.CurrentRow.Index;
            string matk = dgvTaiKhoan.Rows[r].Cells["MaTK"].Value.ToString();

            kn.CapNhat($"DELETE FROM TAIKHOAN WHERE MaTK = '{matk}'");
            LoadTaiKhoan();
        }
        void ClearTK()
        {
            txtTenDN.Clear();
            txtMK.Clear();
            cboQuyenhan.SelectedIndex = -1;
        }
        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnThoatTK_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnTraCuu_Click(object sender, EventArgs e)
        {
            string ma = txtMaNV.Text.Trim();
            string ten = txtTenNV.Text.Trim();

            string sql = "SELECT * FROM NHANVIEN WHERE 1=1";
            if (!string.IsNullOrEmpty(ma))
                sql += $" AND MaNV LIKE '%{ma}%'";
            if (!string.IsNullOrEmpty(ten))
                sql += $" AND HoTen LIKE N'%{ten}%'";

            bsNV.DataSource = kn.LayDuLieu(sql);
            dgvNhanVien.DataSource = bsNV;
        }

        private void btnLoadDanhSach_Click(object sender, EventArgs e)
        {
            bsNV.RemoveFilter();
            LoadNhanVien();
        }

        private void btnTraCuuTK_Click(object sender, EventArgs e)
        {
            string matk = txtMaTK.Text.Trim();
            string manv = txtMaNV_TK.Text.Trim();
            string user = txtTenDN.Text.Trim();

            string sql = "SELECT * FROM TAIKHOAN WHERE 1=1";
            if (!string.IsNullOrEmpty(manv))
                sql += $" AND MaNV LIKE '%{manv}%'";
            if (!string.IsNullOrEmpty(matk))
                sql += $" AND MaTK LIKE '%{matk}%'";
            if (!string.IsNullOrEmpty(user))
                sql += $" AND TenDangNhap LIKE '%{user}%'";

            bsTK.DataSource = kn.LayDuLieu(sql);
            dgvTaiKhoan.DataSource = bsTK;
        }

        private void btnLoadTK_Click(object sender, EventArgs e)
        {
            bsTK.RemoveFilter();
            LoadTaiKhoan();
        }
    }
}
