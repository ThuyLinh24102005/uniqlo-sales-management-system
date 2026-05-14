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
    public partial class Quanlydoitra : Form
    {
        KetNoi kn = new KetNoi();
        DataTable dtCT; 
        BindingSource bsPT = new BindingSource();
        public Quanlydoitra()
        {
            InitializeComponent();
            KhoiTaoCT();
            LoadNhanVien();
            LoadHoaDon();
            LoadLoaiXuLy();
            tabControl1.SelectedIndexChanged += TabControl1_SelectedIndexChanged;
        }
        void KhoiTaoCT()
        {
            dtCT = new DataTable();
            dtCT.Columns.Add("MaSP");
            dtCT.Columns.Add("SoLuong", typeof(int));
            dtCT.Columns.Add("GhiChu");

            dgvCT.DataSource = dtCT;
            bindingNavigator1.BindingSource = null; // tab 1 không dùng BindingNavigator
        }
        void LoadNhanVien()
        {
            DataTable dtNV = kn.LayDuLieu("SELECT MaNV FROM NHANVIEN");
            cboMaNV.DataSource = dtNV;       
            cboMaNV.DisplayMember = "MaNV";
            cboMaNV.ValueMember = "MaNV";
        }
        void LoadHoaDon()
        {
            DataTable dtHD = kn.LayDuLieu("SELECT MaHD FROM HOADONBAN");
            cboMaHD.DataSource = dtHD;
            cboMaHD.DisplayMember = "MaHD";
            cboMaHD.ValueMember = "MaHD";
        }
        void LoadLoaiXuLy()
        {
            cboLoaiXuLy.Items.Clear();
            cboLoaiXuLy.Items.Add("Đổi hàng");
            cboLoaiXuLy.Items.Add("Trả tiền");
            cboLoaiXuLy.Items.Add("Bảo hành"); // tùy nghiệp vụ
            cboLoaiXuLy.SelectedIndex = 0; // mặc định chọn mục đầu tiên
        }
        private void Quanlydoitra_Load(object sender, EventArgs e)
        {

        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            string masp = txtMaSP.Text.Trim();
            if (string.IsNullOrEmpty(masp))
            {
                MessageBox.Show("Nhập mã sản phẩm.");
                return;
            }

            if (!int.TryParse(txtSoLuong.Text.Trim(), out int sl) || sl <= 0)
            {
                MessageBox.Show("Số lượng không hợp lệ.");
                return;
            }

            string ghichu = txtGhiChu.Text.Trim();
            dtCT.Rows.Add(masp, sl, ghichu);

            txtMaSP.Clear();
            txtSoLuong.Clear();
            txtGhiChu.Clear();
            txtMaSP.Focus();
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvCT.CurrentRow != null)
                dgvCT.Rows.RemoveAt(dgvCT.CurrentRow.Index);
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (dtCT.Rows.Count == 0)
            {
                MessageBox.Show("Chưa có sản phẩm trong phiếu đổi trả!");
                return;
            }

            string mapt = txtMaP.Text.Trim();
            if (string.IsNullOrEmpty(mapt))
            {
                MessageBox.Show("Nhập mã phiếu!");
                return;
            }

            string mahd = cboMaHD.SelectedValue?.ToString();
            string manv = cboMaNV.SelectedValue?.ToString();
            string ngay = dtpNgay.Value.ToString("yyyy-MM-dd");
            string loai = cboLoaiXuLy.Text.Trim();
            string lydo = txtLyDo.Text.Trim();

            // Kiểm tra trùng MaPhieu
            DataTable check = kn.LayDuLieu($"SELECT COUNT(*) AS C FROM PHIEUDOITRA WHERE MaPhieu='{mapt}'");
            if (check != null && check.Rows.Count > 0 && Convert.ToInt32(check.Rows[0]["C"]) > 0)
            {
                MessageBox.Show("Mã phiếu đã tồn tại!");
                return;
            }

            // Insert PHIEUDOITRA
            string sqlPT = $@"INSERT INTO PHIEUDOITRA (MaPhieu, MaHD, NgayDT, LoaiXuLy, LyDo, MaNV)
                              VALUES ('{mapt}', '{mahd}', '{ngay}', N'{loai}', N'{lydo}', '{manv}')";
            if (!kn.CapNhat(sqlPT))
            {
                MessageBox.Show("Lỗi khi lưu phiếu!");
                return;
            }

            // Insert chi tiết
            foreach (DataRow r in dtCT.Rows)
            {
                string masp = r["MaSP"].ToString();
                int sl = Convert.ToInt32(r["SoLuong"]);
                string ghichu = r["GhiChu"].ToString();

                string sqlCT = $@"INSERT INTO CT_PHIEUDOITRA (MaPhieu, MaSP, SoLuong, GhiChu)
                                  VALUES ('{mapt}', '{masp}', {sl}, N'{ghichu}')";
                kn.CapNhat(sqlCT);
            }

            MessageBox.Show("Lưu phiếu đổi trả thành công!");
            dtCT.Rows.Clear();
            txtMaPhieu.Clear();
        }
        void LoadDanhSachPT()
        {
            string sql = @"SELECT MaPhieu, MaHD, NgayDT, LoaiXuLy, LyDo, MaNV 
                           FROM PHIEUDOITRA ORDER BY MaPhieu ASC";
            DataTable dt = kn.LayDuLieu(sql);
            bsPT.DataSource = dt;
            dgvPT.DataSource = bsPT;
            bindingNavigator1.BindingSource = bsPT;
            FormatNgayDT();
        }
        private void FormatNgayDT()
        {
            if (dgvPT.Columns["NgayDT"] != null)
            {
                dgvPT.Columns["NgayDT"].DefaultCellStyle.Format = "dd/MM/yyyy";
            }
        }

        private void btnTraCuu_Click(object sender, EventArgs e)
        {
            string mapt = txtMaPhieu.Text.Trim();
            string mahd = txtMaHD.Text.Trim();     
            string manv = txtMaNV.Text.Trim();

            // Câu lệnh SQL cơ bản
            string sql = "SELECT MaPhieu, MaHD, NgayDT, LoaiXuLy, LyDo, MaNV FROM PHIEUDOITRA WHERE 1=1";

            // Thêm điều kiện tìm kiếm nếu người dùng nhập/ chọn
            if (!string.IsNullOrEmpty(mapt))
                sql += $" AND MaPhieu LIKE '%{mapt}%'";
            if (!string.IsNullOrEmpty(mahd))
                sql += $" AND MaHD LIKE '%{mahd}%'";
            if (!string.IsNullOrEmpty(manv))
                sql += $" AND MaNV LIKE '%{manv}%'";

            // Lấy dữ liệu
            DataTable dt = kn.LayDuLieu(sql);

            // Gán dữ liệu cho BindingSource và DataGridView
            bsPT.DataSource = dt;
            dgvPT.DataSource = bsPT;

        }

        private void btnXoaPN_Click(object sender, EventArgs e)
        {
            if (dgvPT.CurrentRow == null) return;

            string mapt = dgvPT.CurrentRow.Cells["MaPhieu"].Value.ToString();
            if (MessageBox.Show("Xóa phiếu này?", "Xác nhận", MessageBoxButtons.YesNo) == DialogResult.No)
                return;

            kn.CapNhat($"DELETE FROM CT_PHIEUDOITRA WHERE MaPhieu='{mapt}'");
            kn.CapNhat($"DELETE FROM PHIEUDOITRA WHERE MaPhieu='{mapt}'");

            LoadDanhSachPT();
        }

        private void btnCapNhatPN_Click(object sender, EventArgs e)
        {
            if (dgvPT.CurrentRow == null)
            {
                MessageBox.Show("Chọn phiếu để cập nhật!");
                return;
            }

            string mapt = dgvPT.CurrentRow.Cells["MaPhieu"].Value.ToString();
            string mahd = dgvPT.CurrentRow.Cells["MaHD"].Value.ToString();
            DateTime ngaydt = Convert.ToDateTime(dgvPT.CurrentRow.Cells["NgayDT"].Value);
            string loai = dgvPT.CurrentRow.Cells["LoaiXuLy"].Value.ToString();
            string lydo = dgvPT.CurrentRow.Cells["LyDo"].Value.ToString();
            string manv = dgvPT.CurrentRow.Cells["MaNV"].Value.ToString();

            string sql = $@"
        UPDATE PHIEUDOITRA
        SET MaHD='{mahd}',
            NgayDT='{ngaydt:dd-mm-yyyy}',
            LoaiXuLy=N'{loai}',
            LyDo=N'{lydo}',
            MaNV='{manv}'
        WHERE MaPhieu='{mapt}'";

            if (kn.CapNhat(sql))
                MessageBox.Show("Cập nhật thành công!");
            else
                MessageBox.Show("Lỗi cập nhật!");

            LoadDanhSachPT();
        }
        private void TabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tabControl1.SelectedTab == tabPage2) // tab danh sách
            {
                LoadDanhSachPT();
                dgvPT.DataSource = bsPT;
                bindingNavigator1.BindingSource = bsPT;
            }
            else // tab lập phiếu
            {
                bindingNavigator1.BindingSource = null;
                dgvCT.DataSource = dtCT;
            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnThoat1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnLoadDanhSach_Click(object sender, EventArgs e)
        {
            bsPT.RemoveFilter();
            LoadDanhSachPT();
        }
    }
}
