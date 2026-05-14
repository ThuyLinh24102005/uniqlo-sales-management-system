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
    public partial class Quanlytonkho : Form
    {
        public Quanlytonkho()
        {
            InitializeComponent();
        }
        KetNoi kn = new KetNoi();      
        BindingSource bs = new BindingSource();
        DataTable dt = new DataTable();
        private void Quanlytonkho_Load(object sender, EventArgs e)
        {
            LoadNhatKyTonKho();
        }
        void LoadNhatKyTonKho()
        {
            dt = kn.LayDuLieu("SELECT * FROM NHATKYTOKHO");
            bs.DataSource = dt;

            dgvTonKho.DataSource = bs;
            bindingNavigator1.BindingSource = bs;
        }

        private void btnLoadDanhSach_Click(object sender, EventArgs e)
        {
            bs.RemoveFilter();
            LoadNhatKyTonKho();
        }

        private void btnTraCuu_Click(object sender, EventArgs e)
        {
            string ma = txtMaTonKho.Text.Trim();

            if (ma == "")
            {
                MessageBox.Show("Nhập mã nhật ký tồn kho!");
                return;
            }

            dt = kn.LayDuLieu(
                $"SELECT * FROM NHATKYTOKHO WHERE MaNK LIKE '%{ma}%'"
            );

            bs.DataSource = dt;
            dgvTonKho.DataSource = bs;
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvTonKho.CurrentRow == null) return;

            string ma = dgvTonKho.CurrentRow.Cells["MaNK"].Value.ToString();

            DialogResult dr = MessageBox.Show(
                "Xóa dòng này?",
                "Xác nhận",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Warning
            );

            if (dr == DialogResult.No) return;

            kn.CapNhat($"DELETE FROM NHATKYTOKHO WHERE MaNK = '{ma}'");
            LoadNhatKyTonKho();
        }

        private void btnCapNhat_Click(object sender, EventArgs e)
        {
            if (dgvTonKho.CurrentRow == null) return;

            var r = dgvTonKho.CurrentRow;

            string maNK = r.Cells["MaNK"].Value.ToString();
            string ngayGhi = Convert.ToDateTime(r.Cells["NgayGhi"].Value).ToString("yyyy-MM-dd");
            string loai = r.Cells["Loaiphatsinh"].Value.ToString();
            int slThayDoi = int.Parse(r.Cells["Soluongthaydoi"].Value.ToString());
            int tonSau = int.Parse(r.Cells["TonSau"].Value.ToString());
            string ghiChu = r.Cells["GhiChu"].Value.ToString();

            string sql = $@"
        UPDATE NHATKYTOKHO SET
            NgayGhi = '{ngayGhi}',
            Loaiphatsinh = N'{loai}',
            Soluongthaydoi = {slThayDoi},
            TonSau = {tonSau},
            GhiChu = N'{ghiChu}'
        WHERE MaNK = '{maNK}'
    ";

            kn.CapNhat(sql);
            LoadNhatKyTonKho();
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
