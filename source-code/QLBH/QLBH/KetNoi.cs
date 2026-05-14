using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace QLBH
{
    internal class KetNoi
    {
        // Chuỗi kết nối
        private string strConn = @"Data Source=DESKTOP-UK1EURL;Initial Catalog=QLBHUNIQLO;Integrated Security=True";

        // Lấy dữ liệu (SELECT)
        public DataTable LayDuLieu(string sql)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi lấy dữ liệu: " + ex.Message);
                return null;
            }
        }

        // Cập nhật dữ liệu (INSERT, UPDATE, DELETE)
        public bool CapNhat(string sql)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.ExecuteNonQuery();
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi cập nhật dữ liệu: " + ex.Message);
                return false;
            }
        }
    }
}
