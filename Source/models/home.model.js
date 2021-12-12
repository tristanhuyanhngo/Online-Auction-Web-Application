import db from '../utils/db.js';

export default {
    // findAll() {
    //     return db('sanpham');
    // },
    //
    // findByCatId(catId) {
    //     return db('sanpham').where('MaDanhMuc', catId);
    // },
    //
    // async findById(id) {
    //     const list = await db('sanpham').where('MaSanPham', id);
    //     if (list.length === 0)
    //         return null;
    //     return list[0];
    // },
    async sortByPrice() {
        const sql = `select C.TenDanhMuc as CatName, L.TenCapDanhMuc as CatLevel, P.MaSanPham as ProID, P.TenSanPham as ProName, P.GiaKhoiDiem as OriginPrice, U.HoTen as Seller, P.GiaMuaNgay as Price_BuyNow, P.NgayKetThuc as EndDate
                     from sanpham as P, users as U, danhmuc as C, capdanhmuc as L
                     where P.EmailNguoiBan = U.Email and
                         P.MaDanhMuc = C.MaDanhMuc and
                         C.CapDanhMuc = L.MaCapDanhMuc
                     order by P.GiaKhoiDiem DESC
                     limit 0, 4;`;
        const raw = await db.raw(sql);
        return raw;
    },
    async sortByEndDate() {
        const sql = ` select *
                      from sanpham
                      order by sanpham.NgayKetThuc - sanpham.NgayDangSanPham ASC
                      limit 0, 5;`;
        const raw = await db.raw(sql);
        return raw;
    }
}
