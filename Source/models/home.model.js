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
        const sql = `select C.tendanhmuc as CatName, P.MaSanPham as ProID, P.TenSanPham as ProName, P.GiaKhoiDiem as Price, U.HoTen as Seller, P.NgayKetThuc as EndDate
                     from sanpham as P, users as U, danhmuc as C
                     where P.EmailNguoiBan = U.Email and
                         P.MaDanhMuc = C.MaDanhMuc
                     order by GiaKhoiDiem DESC
                         limit 0, 4`;
        const raw = await db.raw(sql);
        return raw;
    }
}
