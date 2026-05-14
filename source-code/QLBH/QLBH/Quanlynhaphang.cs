using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLBH
{
    public partial class Quanlynhaphang : Form
    {
        KetNoi kn = new KetNoi();
        DataTable dtCT;
        BindingSource bsPN = new BindingSource();
        public Quanlynhaphang()
        {
            InitializeComponent();
            KhoiTaoCT();
            LoadNhanVien();
            tabControl1.SelectedIndexChanged += tabControl1_SelectedIndexChanged;
        }
        void KhoiTaoCT()
        {
            dtCT = new DataTable();
            dtCT.Columns.Add("MaSP");
            dtCT.Columns.Add("SoLuong", typeof(int));
            dtCT.Columns.Add("DonGia", typeof(decimal));
            dtCT.Columns.Add("ThanhTien", typeof(decimal));

            dgvCTPN.DataSource = dtCT;  // tên DataGridView của bạn
            bindingNavigator1.BindingSource = null;
        }

        void LoadNhanVien()
        {
            DataTable dtNV = kn.LayDuLieu("SELECT MaNV FROM NHANVIEN");
            cboMaNV.DataSource = dtNV;
            cboMaNV.DisplayMember = "MaNV";
            cboMaNV.ValueMember = "MaNV";
        }
        void TinhTongTien()
        {
            decimal tong = 0;
            foreach (DataRow r in dtCT.Rows)
                tong += Convert.ToDecimal(r["ThanhTien"]);

            txtTongTien.Text = tong.ToString();
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Quanlynhaphang_Load(object sender, EventArgs e)
        {
            tabControl1.SelectedIndex = 0;   // mở tab lập phiếu
            dgvCTPN.DataSource = dtCT;       // chắc chắn dgvCTPN gắn đúng DataTable
            bindingNavigator1.BindingSource = null;
        }

        void LoadDanhSachPN()
        {
            string sql = @"SELECT MaPN, MaNV, NgayNhap, TongTien FROM PHIEUNHAP ORDER BY MaPN ASC";
            DataTable dt = kn.LayDuLieu(sql);
            bsPN.DataSource = dt;
            dgvPN.DataSource = bsPN;
            FormatNgayNhap();
        }
        private void FormatNgayNhap()
        {
            if (dgvPN.Columns["NgayNhap"] != null)
            {
                dgvPN.Columns["NgayNhap"].DefaultCellStyle.Format = "dd/MM/yyyy";
            }
        }


        private void btnTraCuu_Click(object sender, EventArgs e)
        {
            string mapn = txtMaPhieu.Text.Trim();
            string manv = txtMaNV.Text.Trim();

            string sql = @"SELECT MaPN, MaNV, NgayNhap, TongTien FROM PHIEUNHAP WHERE 1=1";
            if (!string.IsNullOrEmpty(mapn)) sql += $" AND MaPN LIKE '%{mapn}%'";
            if (!string.IsNullOrEmpty(manv)) sql += $" AND MaNV LIKE '%{manv}%'";

            DataTable dt = kn.LayDuLieu(sql);
            bsPN.DataSource = dt;
            dgvPN.DataSource = bsPN;
        }

        private void btnXoaPN_Click(object sender, EventArgs e)
        {
            if (dgvPN.CurrentRow == null) { MessageBox.Show("Chọn phiếu nhập để xoá!"); return; }

            string mapn = dgvPN.CurrentRow.Cells["MaPN"].Value.ToString();
            if (MessageBox.Show("Xoá phiếu nhập này?", "Xác nhận", MessageBoxButtons.YesNo) == DialogResult.No) return;

            kn.CapNhat($"DELETE FROM CT_PHIEUNHAP WHERE MaPN='{mapn}'");
            kn.CapNhat($"DELETE FROM PHIEUNHAP WHERE MaPN='{mapn}'");
            MessageBox.Show("Xoá thành công!");
            LoadDanhSachPN();
        }

        private void btnCapNhatPN_Click(object sender, EventArgs e)
        {
            if (dgvPN.CurrentRow == null) { MessageBox.Show("Chọn phiếu nhập để cập nhật!"); return; }

            string mapn = dgvPN.CurrentRow.Cells["MaPN"].Value.ToString();
            string manv = dgvPN.CurrentRow.Cells["MaNV"].Value.ToString();
            DateTime ngay = Convert.ToDateTime(dgvPN.CurrentRow.Cells["NgayNhap"].Value);

            string sql = $@"UPDATE PHIEUNHAP SET MaNV='{manv}', NgayNhap='{ngay:yyyy-MM-dd}' WHERE MaPN='{mapn}'";
            if (kn.CapNhat(sql)) MessageBox.Show("Cập nhật thành công!");
            else MessageBox.Show("Lỗi cập nhật!");

            LoadDanhSachPN();
        }

        private void btnLoadDanhSach_Click(object sender, EventArgs e)
        {
            if (tabControl1.SelectedTab != tabPage2) return;
            bsPN.RemoveFilter();
            LoadDanhSachPN();
        }
        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tabControl1.SelectedTab == tabPage2)
            {
                LoadDanhSachPN();
                dgvPN.DataSource = bsPN;
                bindingNavigator1.BindingSource = bsPN;
            }
            else if (tabControl1.SelectedTab == tabPage1)
            {
                bindingNavigator1.BindingSource = null; // không ảnh hưởng tab lập phiếu
            }
        }

        private void btnThoatPN_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnThoat_Click_1(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnThem_Click_1(object sender, EventArgs e)
        {
            string masp = txtMaSP.Text.Trim();
            if (string.IsNullOrEmpty(masp)) { MessageBox.Show("Nhập mã sản phẩm."); txtMaSP.Focus(); return; }

            if (!int.TryParse(txtSoLuong.Text.Trim(), out int sl) || sl <= 0)
            { MessageBox.Show("Số lượng không hợp lệ."); txtSoLuong.Focus(); return; }

            if (!decimal.TryParse(txtDonGia.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out decimal dongia) || dongia < 0)
            { MessageBox.Show("Đơn giá không hợp lệ."); txtDonGia.Focus(); return; }

            decimal thanhtien = sl * dongia;
            dtCT.Rows.Add(masp, sl, dongia, thanhtien);
            TinhTongTien();

            txtMaSP.Clear(); txtSoLuong.Clear(); txtDonGia.Clear(); txtMaSP.Focus();
        }

        private void btnXoa_Click_1(object sender, EventArgs e)
        {
            if (dgvCTPN.CurrentRow != null)
            {
                dgvCTPN.Rows.RemoveAt(dgvCTPN.CurrentRow.Index);
                TinhTongTien();
            }
        }

        private void btnLuu_Click_1(object sender, EventArgs e)
        {

            try
            {
                if (dtCT.Rows.Count == 0) { MessageBox.Show("Chưa có sản phẩm trong phiếu nhập!"); return; }

                string mapn = txtMaPN.Text.Trim();
                if (string.IsNullOrEmpty(mapn)) { MessageBox.Show("Nhập mã phiếu nhập!"); txtMaPN.Focus(); return; }

                string manv = cboMaNV.SelectedValue?.ToString() ?? "";
                if (string.IsNullOrEmpty(manv)) { MessageBox.Show("Chọn mã nhân viên!"); return; }

                string ngay = dtpNgayNhap.Value.ToString("yyyy-MM-dd");
                decimal tong = decimal.TryParse(txtTongTien.Text.Trim(), out decimal t) ? t : 0;

                // kiểm tra duplicate
                DataTable check = kn.LayDuLieu($"SELECT COUNT(*) AS C FROM PHIEUNHAP WHERE MaPN='{mapn}'");
                if (check.Rows.Count > 0 && Convert.ToInt32(check.Rows[0]["C"]) > 0)
                { MessageBox.Show("Mã phiếu nhập đã tồn tại."); return; }

                // 1. Insert PHIEUNHAP
                string sqlPN = $@"INSERT INTO PHIEUNHAP (MaPN, MaNV, NgayNhap, TongTien)
                                  VALUES ('{mapn}','{manv}','{ngay}',{tong})";
                if (!kn.CapNhat(sqlPN)) { MessageBox.Show("Lỗi khi lưu phiếu nhập!"); return; }

                // 2. Insert chi tiết
                foreach (DataRow r in dtCT.Rows)
                {
                    string masp = r["MaSP"].ToString();
                    int sl = Convert.ToInt32(r["SoLuong"]);
                    decimal dg = Convert.ToDecimal(r["DonGia"]);
                    decimal tt = Convert.ToDecimal(r["ThanhTien"]);

                    string sqlCT = $@"INSERT INTO CT_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGia, ThanhTien)
                                      VALUES ('{mapn}','{masp}',{sl},{dg},{tt})";
                    kn.CapNhat(sqlCT);
                }

                MessageBox.Show("Lưu phiếu nhập thành công!");
                dtCT.Rows.Clear(); TinhTongTien(); txtMaPN.Clear();
            }
            catch (Exception ex) { MessageBox.Show("Lỗi khi lưu phiếu nhập: " + ex.Message); }
        }
    }
}
