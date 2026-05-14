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
    public partial class Quanlybanhang : Form
    {
        public Quanlybanhang()
        {
            InitializeComponent();
            KhoiTaoCT();
            LoadNhanVien();
            LoadKhachHang();
            LoadKhuyenMai();
            LoadHinhThucThanhToan();
            tabControl1.SelectedIndexChanged += TabControl1_SelectedIndexChanged;
        }
        KetNoi kn = new KetNoi();
        DataTable dtCT;
        BindingSource bsHD = new BindingSource();
        void KhoiTaoCT()
        {
            dtCT = new DataTable();
            dtCT.Columns.Add("MaSP");
            dtCT.Columns.Add("SoLuong", typeof(int));
            dtCT.Columns.Add("DonGia", typeof(decimal));
            dtCT.Columns.Add("ThanhTien", typeof(decimal));

            dgvCTHD.DataSource = dtCT;
            bindingNavigator1.BindingSource = null;
        }
        void LoadNhanVien()
        {
            DataTable dt = kn.LayDuLieu("SELECT MaNV FROM NHANVIEN");
            cboMaNV.DataSource = dt;
            cboMaNV.DisplayMember = "MaNV";
            cboMaNV.ValueMember = "MaNV";
        }
        void LoadKhachHang()
        {
            DataTable dt = kn.LayDuLieu("SELECT MaKH FROM KHACHHANG");
            cboMaKH.DataSource = dt;
            cboMaKH.DisplayMember = "MaKH";
            cboMaKH.ValueMember = "MaKH";
        }
        void LoadKhuyenMai()
        {
            DataTable dt = kn.LayDuLieu("SELECT MaKM FROM KHUYENMAI");
            cboMaKM.DataSource = dt;
            cboMaKM.DisplayMember = "MaKM";
            cboMaKM.ValueMember = "MaKM";
        }
        void LoadHinhThucThanhToan()
        {
            cboHinhThucTT.Items.Clear();

            cboHinhThucTT.Items.Add("Tiền mặt");
            cboHinhThucTT.Items.Add("Chuyển khoản");
            cboHinhThucTT.Items.Add("Thẻ ngân hàng");
            cboHinhThucTT.Items.Add("Ví điện tử");
            cboHinhThucTT.Items.Add("COD");

            cboHinhThucTT.SelectedIndex = 0;   // chọn mặc định
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            string masp = txtMaSP.Text.Trim();
            if (masp == "")
            {
                MessageBox.Show("Nhập mã sản phẩm!");
                return;
            }

            if (!int.TryParse(txtSoLuong.Text.Trim(), out int sl) || sl <= 0)
            {
                MessageBox.Show("Số lượng không hợp lệ!");
                return;
            }

            if (!decimal.TryParse(txtDonGia.Text.Trim(), out decimal gia) || gia <= 0)
            {
                MessageBox.Show("Đơn giá không hợp lệ!");
                return;
            }

            decimal thanhTien = sl * gia;

            dtCT.Rows.Add(masp, sl, gia, thanhTien);
            TinhTongTien();

            txtMaSP.Clear();
            txtSoLuong.Clear();
            txtDonGia.Clear();
        }
        void TinhTongTien()
        {
            decimal tong = 0;
            foreach (DataRow r in dtCT.Rows)
                tong += Convert.ToDecimal(r["ThanhTien"]);

            txtTongTien.Text = tong.ToString();
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvCTHD.CurrentRow != null)
            {
                dgvCTHD.Rows.RemoveAt(dgvCTHD.CurrentRow.Index);
                TinhTongTien();
            }
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                if (dtCT.Rows.Count == 0)
                {
                    MessageBox.Show("Chưa có sản phẩm!");
                    return;
                }

                string mahd = txtMaHDon.Text.Trim();
                if (mahd == "") { MessageBox.Show("Nhập mã hóa đơn!"); return; }

                string manv = cboMaNV.SelectedValue.ToString();
                string makh = cboMaKH.SelectedValue.ToString();
                string makm = cboMaKM.SelectedValue?.ToString() ?? "";
                string ht = cboHinhThucTT.Text.Trim();
                string ngay = dtpNgayBan.Value.ToString("yyyy-MM-dd");
                decimal tong = decimal.TryParse(txtTongTien.Text, out decimal t) ? t : 0;

                // Kiểm tra trùng hóa đơn
                DataTable check = kn.LayDuLieu($"SELECT COUNT(*) AS C FROM HOADONBAN WHERE MaHD='{mahd}'");
                if (Convert.ToInt32(check.Rows[0]["C"]) > 0)
                {
                    MessageBox.Show("Mã hóa đơn đã tồn tại!");
                    return;
                }

                // Insert HOADONBAN
                string sqlHD = $@"
            INSERT INTO HOADONBAN (MaHD, MaNV, MaKH, MaKM, NgayBan, TongTien, HinhThucTT)
            VALUES ('{mahd}','{manv}','{makh}','{makm}','{ngay}',{tong},N'{ht}')";

                if (!kn.CapNhat(sqlHD))
                {
                    MessageBox.Show("Lỗi khi lưu hóa đơn!");
                    return;
                }

                // Insert chi tiết
                foreach (DataRow r in dtCT.Rows)
                {
                    string masp = r["MaSP"].ToString();
                    int sl = (int)r["SoLuong"];
                    decimal gia = (decimal)r["DonGia"];
                    decimal tt = (decimal)r["ThanhTien"];

                    string sqlCT = $@"
                INSERT INTO CT_HOADONBAN (MaHD, MaSP, SoLuong, DonGia, ThanhTien)
                VALUES ('{mahd}','{masp}',{sl},{gia},{tt})";

                    kn.CapNhat(sqlCT);
                }

                MessageBox.Show("Lưu hóa đơn thành công!");
                dtCT.Rows.Clear();
                txtMaKH_TK.Clear();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message);
            }
        }
        void LoadDanhSachHD()
        {
            string sql = @"SELECT MaHD, MaNV, MaKH, MaKM, NgayBan, TongTien, HinhThucTT
                   FROM HOADONBAN ORDER BY MaHD ASC";

            DataTable dt = kn.LayDuLieu(sql);
            bsHD.DataSource = dt;
            dgvHD.DataSource = bsHD;
            bindingNavigator1.BindingSource = bsHD;
        }

        private void btnTraCuu_Click(object sender, EventArgs e)
        {
            string mahd = txtMaHD_TK.Text.Trim();
            string makh = txtMaKH_TK.Text.Trim();
            string manv = txtMaNV_TK.Text.Trim();

            string sql = "SELECT * FROM HOADONBAN WHERE 1=1";

            if (mahd != "") sql += $" AND MaHD LIKE '%{mahd}%'";
            if (makh != "") sql += $" AND MaKH LIKE '%{makh}%'";
            if (manv != "") sql += $" AND MaNV LIKE '%{manv}%'";

            DataTable dt = kn.LayDuLieu(sql);
            bsHD.DataSource = dt;
            dgvHD.DataSource = bsHD;
        }

        private void btnLoadDanhSach_Click(object sender, EventArgs e)
        {
            bsHD.RemoveFilter();
            LoadDanhSachHD();
        }

        private void btnXoaHD_Click(object sender, EventArgs e)
        {
            if (dgvHD.CurrentRow == null) return;

            string mahd = dgvHD.CurrentRow.Cells["MaHD"].Value.ToString();

            if (MessageBox.Show("Xóa hóa đơn này?", "Xác nhận", MessageBoxButtons.YesNo) == DialogResult.No)
                return;

            kn.CapNhat($"DELETE FROM CT_HOADONBAN WHERE MaHD='{mahd}'");
            kn.CapNhat($"DELETE FROM HOADONBAN WHERE MaHD='{mahd}'");

            LoadDanhSachHD();
        }

        private void btnCapNhatHD_Click(object sender, EventArgs e)
        {
            if (dgvHD.CurrentRow == null) return;

            string mahd = dgvHD.CurrentRow.Cells["MaHD"].Value.ToString();
            string manv = dgvHD.CurrentRow.Cells["MaNV"].Value.ToString();
            string makh = dgvHD.CurrentRow.Cells["MaKH"].Value.ToString();
            string makm = dgvHD.CurrentRow.Cells["MaKM"].Value.ToString();
            DateTime ngay = Convert.ToDateTime(dgvHD.CurrentRow.Cells["NgayBan"].Value);
            string ht = dgvHD.CurrentRow.Cells["HinhThucTT"].Value.ToString();

            string sql = $@"
        UPDATE HOADONBAN
        SET MaNV='{manv}', MaKH='{makh}', MaKM='{makm}',
            NgayBan='{ngay:yyyy-MM-dd}', HinhThucTT=N'{ht}'
        WHERE MaHD='{mahd}'";

            if (kn.CapNhat(sql)) MessageBox.Show("Cập nhật thành công!");
            else MessageBox.Show("Lỗi cập nhật!");

            LoadDanhSachHD();
        }
        private void TabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tabControl1.SelectedTab == tabPage2)
            {
                LoadDanhSachHD();
                bindingNavigator1.BindingSource = bsHD;
            }
            else
            {
                bindingNavigator1.BindingSource = null;
                dgvCTHD.DataSource = dtCT;
            }
        }

        private void btnThoat1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Quanlybanhang_Load(object sender, EventArgs e)
        {

        }
    }
}
