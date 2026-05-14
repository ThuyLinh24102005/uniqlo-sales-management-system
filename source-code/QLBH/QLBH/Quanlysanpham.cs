using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLBH
{
    public partial class Quanlysanpham : Form
    {
        KetNoi kn = new KetNoi();
        BindingSource bs = new BindingSource();
        DataTable dt;
        public Quanlysanpham()
        {
            InitializeComponent();
        }

        private void Quanlysanpham_Load(object sender, EventArgs e)
        {
            LoadSanPham();
        }
        private void LoadSanPham()
        {
            dt = kn.LayDuLieu("SELECT * FROM SANPHAM");

            bs.DataSource = null;       // reset trước
            bs.DataSource = dt;

            dgvSanPham.DataSource = bs;
            bindingNavigator1.BindingSource = bs;

            dgvSanPham.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void btnLoadDanhSach_Click(object sender, EventArgs e)
        {
            bs.RemoveFilter();
            LoadSanPham();
        }

        private void btnTraCuu_Click(object sender, EventArgs e)
        {
            string key = txtNhap.Text.Trim();

            if (rdoMaSP.Checked)
                bs.Filter = $"MaSP LIKE '%{key}%'";
            else if (rdoTenSP.Checked)
                bs.Filter = $"TenSP LIKE '%{key}%'";

            txtNhap.Clear();
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            try
            {
                int r = dgvSanPham.CurrentRow.Index;
                string ma = dgvSanPham.Rows[r].Cells["MaSP"].Value.ToString();
                string maloai = dgvSanPham.Rows[r].Cells["MaLoai"].Value.ToString();
                string mancc = dgvSanPham.Rows[r].Cells["MaNCC"].Value.ToString();
                string ten = dgvSanPham.Rows[r].Cells["TenSP"].Value.ToString();
                string size = dgvSanPham.Rows[r].Cells["Size"].Value.ToString();
                string mau = dgvSanPham.Rows[r].Cells["Mau"].Value.ToString();
                string giaban = dgvSanPham.Rows[r].Cells["GiaBan"].Value.ToString();

                string sql = $"INSERT INTO SANPHAM (MaSP, MaLoai, MaNCC, TenSP, Size, Mau, GiaBan) " +
                             $"VALUES('{ma}', '{maloai}', '{mancc}', N'{ten}', N'{size}', N'{mau}', {giaban})";
                kn.CapNhat(sql);

                LoadSanPham();
            }
            catch
            {
                MessageBox.Show("Hãy nhập dữ liệu đầy đủ vào dòng mới trên bảng trước khi thêm!");
            }
        }

        private void btnCapNhat_Click(object sender, EventArgs e)
        {
            try
            {
                int r = dgvSanPham.CurrentRow.Index;
                string ma = dgvSanPham.Rows[r].Cells["MaSP"].Value.ToString();
                string maloai = dgvSanPham.Rows[r].Cells["MaLoai"].Value.ToString();
                string mancc = dgvSanPham.Rows[r].Cells["MaNCC"].Value.ToString();
                string ten = dgvSanPham.Rows[r].Cells["TenSP"].Value.ToString();
                string size = dgvSanPham.Rows[r].Cells["Size"].Value.ToString();
                string mau = dgvSanPham.Rows[r].Cells["Mau"].Value.ToString();
                string giaban = dgvSanPham.Rows[r].Cells["GiaBan"].Value.ToString();

                string sql = $"UPDATE SANPHAM SET MaLoai='{maloai}', MaNCC='{mancc}', TenSP=N'{ten}', " +
                             $"Size=N'{size}', Mau=N'{mau}', GiaBan={giaban} WHERE MaSP='{ma}'";
                kn.CapNhat(sql);

                LoadSanPham();
            }
            catch
            {
                MessageBox.Show("Có lỗi khi cập nhật sản phẩm!");
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            try
            {
                int r = dgvSanPham.CurrentRow.Index;
                string ma = dgvSanPham.Rows[r].Cells["MaSP"].Value.ToString();

                string sql = $"DELETE FROM SANPHAM WHERE MaSP='{ma}'";
                kn.CapNhat(sql);

                LoadSanPham();
            }
            catch
            {
                MessageBox.Show("Có lỗi khi xóa sản phẩm!");
            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void mnutonkho_Click(object sender, EventArgs e)
        {
            Quanlytonkho frmTonKho = new Quanlytonkho();
            frmTonKho.Show();
        }

        private void mnubanhang_Click(object sender, EventArgs e)
        {
            Quanlybanhang frmBanHang = new Quanlybanhang();
            frmBanHang.Show();
        }

        private void mnunhaphang_Click(object sender, EventArgs e)
        {
            Quanlynhaphang frmNhapHang = new Quanlynhaphang();
            frmNhapHang.Show();
        }
    }
}
