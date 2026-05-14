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
    public partial class BaoCao : Form
    {
        public BaoCao()
        {
            InitializeComponent();

            // ComboBox chọn loại báo cáo
            cbLoaiBaoCao.Items.Add("Hóa đơn bán hàng");
            cbLoaiBaoCao.Items.Add("Phiếu nhập hàng");
            cbLoaiBaoCao.Items.Add("Nhật ký tồn kho");
            cbLoaiBaoCao.SelectedIndex = 0;

            // Gắn BindingSource vào DataGridView
            dgvBaoCao.DataSource = bsBaoCao;

            // BindingNavigator gắn với BindingSource
            bindingNavigator1.BindingSource = bsBaoCao;
        }
        KetNoi kn = new KetNoi();
        BindingSource bsBaoCao = new BindingSource();
        private void BaoCao_Load(object sender, EventArgs e)
        {

        }

        private void btnXem_Click(object sender, EventArgs e)
        {
            string sql = "";

            switch (cbLoaiBaoCao.SelectedItem.ToString())
            {
                case "Hóa đơn bán hàng":
                    sql = @"SELECT MaHD AS [Mã Hóa Đơn],
                                   MaNV AS [Mã Nhân Viên],
                                   MaKH AS [Mã Khách Hàng],
                                   NgayBan AS [Ngày Bán],
                                   TongTien AS [Tổng Tiền],
                                   HinhThucTT AS [Hình Thức Thanh Toán]
                            FROM HOADONBAN
                            ORDER BY MaHD ASC";
                    break;
                case "Phiếu nhập hàng":
                    sql = @"SELECT MaPN AS [Mã Phiếu Nhập],
                                   MaNV AS [Mã Nhân Viên],
                                   NgayNhap AS [Ngày Nhập],
                                   TongTien AS [Tổng Tiền]
                            FROM PHIEUNHAP
                            ORDER BY MaPN ASC";
                    break;
                case "Nhật ký tồn kho":
                    sql = @"SELECT MaNK AS [Mã Nhật Ký],
                                   NgayGhi AS [Ngày Ghi],
                                   LoaiPhatSinh AS [Loại Phát Sinh],
                                   SoLuongThayDoi AS [Số Lượng Thay Đổi],
                                   TonSau AS [Tồn Sau],
                                   MaSP AS [Mã Sản Phẩm]
                            FROM NHATKYTOKHO
                            ORDER BY MaNK ASC";
                    break;
            }

            DataTable dt = kn.LayDuLieu(sql);
            if (dt != null)
            {
                bsBaoCao.DataSource = dt;  // Gán vào BindingSource
            }
        }
    }
}
