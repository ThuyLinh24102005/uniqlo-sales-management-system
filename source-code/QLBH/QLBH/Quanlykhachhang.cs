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
    public partial class Quanlykhachhang : Form
    {
        DataTable dt;
        BindingSource bs = new BindingSource();
        KetNoi kn = new KetNoi();
        public Quanlykhachhang()
        {
            InitializeComponent();
        }

        private void Quanlykhachhang_Load(object sender, EventArgs e)
        {
            LoadKhachHang();
            LoadComboBoxHangTV();
            txtTongTien.Enabled = false;
        }
        private void LoadKhachHang()
        {
            try
            {
                dgvKhachHang.EndEdit();
                bs.EndEdit();

                dt = kn.LayDuLieu("SELECT * FROM KHACHHANG");
                if (dt == null)
                {
                    MessageBox.Show("Không có dữ liệu trong bảng KHACHHANG!");
                    return;
                }

                bs.DataSource = null;  // reset binding
                bs.DataSource = dt;

                dgvKhachHang.DataSource = bs;
                bindingNavigator1.BindingSource = bs;
                dgvKhachHang.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi load dữ liệu: " + ex.Message);
            }
        }

        private void btnLoadDanhSach_Click(object sender, EventArgs e)
        {
            bs.RemoveFilter();
            LoadKhachHang();
        }
        private void LoadComboBoxHangTV()
        {
            cboHTV.Items.Clear();
            cboHTV.Items.AddRange(new string[] {"Đồng", "Bạc", "Vàng", "Bạch kim" });
            cboHTV.DropDownStyle = ComboBoxStyle.DropDownList;
            cboHTV.SelectedIndex = -1; 
        }
        private void btnTraCuu_Click(object sender, EventArgs e)
        {
            string ma = txtMaKH.Text.Trim();
            string ten = txtTenKH.Text.Trim();

            string sql = "SELECT * FROM KHACHHANG WHERE 1=1";
            if (!string.IsNullOrEmpty(ma))
                sql += $" AND MaKH LIKE '%{ma}%'";
            if (!string.IsNullOrEmpty(ten))
                sql += $" AND HoTen LIKE N'%{ten}%'";

            dt = kn.LayDuLieu(sql);
            bs.DataSource = dt;
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            try
            {
                string ma = txtMaKH.Text.Trim();
                string ten = txtTenKH.Text.Trim();
                string sdt = txtSDT.Text.Trim();
                string email = txtEmail.Text.Trim();
                string hangTV = cboHTV.Text.Trim();

                if (string.IsNullOrEmpty(ma) || string.IsNullOrEmpty(ten))
                {
                    MessageBox.Show("Mã khách hàng và tên không được để trống!");
                    return;
                }
                string sql = $"INSERT INTO KHACHHANG(MaKH, HoTen, SDT, Email, TongChiTieu, HangThanhVien) " +
                             $"VALUES('{ma}', N'{ten}', '{sdt}', '{email}', 0, N'{hangTV}')";
                kn.CapNhat(sql);

                LoadKhachHang();
                MessageBox.Show("Thêm khách hàng thành công!");
                txtMaKH.Text = "";
                txtTenKH.Text = "";
                txtSDT.Text = "";
                txtEmail.Text = "";
                cboHTV.SelectedIndex = -1; // reset ComboBox
                txtMaKH.Focus();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi thêm khách hàng: " + ex.Message);
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            try
            {
                if (dgvKhachHang.CurrentRow == null)
                {
                    MessageBox.Show("Vui lòng chọn khách hàng cần xóa!");
                    return;
                }

                // Lấy MaKH từ dòng hiện tại
                string ma = dgvKhachHang.CurrentRow.Cells["MaKH"].Value.ToString();

                string sql = $"DELETE FROM KHACHHANG WHERE MaKH='{ma}'";
                kn.CapNhat(sql);

                LoadKhachHang();
                MessageBox.Show("Xóa khách hàng thành công!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi xóa khách hàng: " + ex.Message);
            }
        }

        private void btnCapNhat_Click(object sender, EventArgs e)
        {
            try
            {
                if (dgvKhachHang.CurrentRow == null)
                {
                    MessageBox.Show("Vui lòng chọn khách hàng cần cập nhật!");
                    return;
                }

                // Lấy dữ liệu từ dòng hiện tại
                string ma = dgvKhachHang.CurrentRow.Cells["MaKH"].Value.ToString();
                string ten = dgvKhachHang.CurrentRow.Cells["HoTen"].Value.ToString();
                string sdt = dgvKhachHang.CurrentRow.Cells["SDT"].Value.ToString();
                string email = dgvKhachHang.CurrentRow.Cells["Email"].Value.ToString();
                string hangTV = dgvKhachHang.CurrentRow.Cells["HangThanhVien"].Value.ToString();

                string sql = @"UPDATE KHACHHANG SET 
                        HoTen = N'" + ten + @"',
                        SDT = '" + sdt + @"',
                        Email = '" + email + @"',
                        HangThanhVien = N'" + hangTV + @"'
                       WHERE MaKH = '" + ma + "'";

                kn.CapNhat(sql);

                LoadKhachHang();
                MessageBox.Show("Cập nhật khách hàng thành công!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi cập nhật khách hàng: " + ex.Message);
            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
