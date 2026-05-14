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
    public partial class Giaodienchinh : Form
    {
        public Giaodienchinh()
        {
            InitializeComponent();
        }
        private void mnuSanPham_Click_1(object sender, EventArgs e)
        {
            Quanlysanpham f = new Quanlysanpham();
            f.FormClosed += (s, args) => this.Show();
            this.Hide();
            f.Show();
        }

        private void mnuKhachHang_Click_1(object sender, EventArgs e)
        {
            Quanlykhachhang f = new Quanlykhachhang();
            f.FormClosed += (s, args) => this.Show();
            this.Hide();
            f.Show();
        }

        private void mnuNhanVien_Click_1(object sender, EventArgs e)
        {
            Quanlynhanvien f = new Quanlynhanvien();
            f.FormClosed += (s, args) => this.Show();
            this.Hide();
            f.Show();
        }

        private void mnuBanHang_Click_1(object sender, EventArgs e)
        {
            this.Hide();
            Quanlybanhang f = new Quanlybanhang();
            f.FormClosed += (s, args) => this.Show();
            f.Show();
        }

        private void mnudoitra_Click_1(object sender, EventArgs e)
        {
            Quanlydoitra f = new Quanlydoitra();
            f.FormClosed += (s, args) => this.Show();
            this.Hide();
            f.Show();
        }

        private void mnunhaphang_Click_1(object sender, EventArgs e)
        {
            Quanlynhaphang f = new Quanlynhaphang();
            f.FormClosed += (s, args) => this.Show();
            this.Hide();
            f.Show();
        }

        private void mnutonkho_Click_1(object sender, EventArgs e)
        {
            Quanlytonkho f = new Quanlytonkho();
            f.FormClosed += (s, args) => this.Show();
            this.Hide();
            f.Show();
        }

        private void mnudangxuat_Click(object sender, EventArgs e)
        {
            DangNhap f = new DangNhap();
            f.FormClosed += (s, args) => this.Show();
            this.Hide();
            f.Show();
        }
    }
}
