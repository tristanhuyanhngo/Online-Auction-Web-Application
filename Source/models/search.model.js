import db from '../utils/db.js';

export default {
    async findAll() {
        const sql = ` select C.TenDanhMuc as CatName, L.TenCapDanhMuc as CatLevel, P.MaSanPham as ProID, P.TenSanPham as ProName, P.GiaKhoiDiem as OriginPrice, U.HoTen as Seller, P.GiaMuaNgay as Price_BuyNow, P.NgayKetThuc as EndDate
                      from sanpham as P, users as U, danhmuc as C, capdanhmuc as L
                      where P.EmailNguoiBan = U.Email and
                            P.MaDanhMuc = C.MaDanhMuc and
                            C.CapDanhMuc = L.MaCapDanhMuc `;
        const raw = await db.raw(sql);
        return raw;
    }
}
