import db from '../utils/db.js';

export default {
    async countAllProducts() {
        const list = await db('sanpham').count({ amount: 'MaSanPham' });
        return list[0].amount
    },

    findAllPage(limit, offset) {
        const sql = `select C.TenDanhMuc as CatName, L.TenCapDanhMuc as CatLevel, P.MaSanPham as ProID, P.TenSanPham as ProName, P.GiaKhoiDiem as OriginPrice, U.HoTen as Seller, P.GiaMuaNgay as Price_BuyNow, P.NgayKetThuc as EndDate
                      from sanpham as P, users as U, danhmuc as C, capdanhmuc as L
                      where P.EmailNguoiBan = U.Email and
                            P.MaDanhMuc = C.MaDanhMuc and
                            C.CapDanhMuc = L.MaCapDanhMuc
                      limit ${limit} offset ${offset}`;
        const raw = db.raw(sql);
        return raw;
    },

    async countByCatID(CatID) {
        const list = await db('sanpham').where('MaDanhMuc', CatID).count({ amount: 'MaSanPham' });
        return list[0].amount;
    },

    findPageByCatID(CatID, limit, offset) {
        return db(`sanpham`).where(`MaDanhMuc`,CatID).limit(limit).offset(offset);
    }

}
