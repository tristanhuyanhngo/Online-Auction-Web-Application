import db from '../utils/db.js';

export default {
    findAll() {
        return db('sanpham');
    },

    findByCatId(catId) {
        return db('sanpham').where('MaDanhMuc', catId);
    },

    async findById(id) {
        const list = await db('sanpham').where('MaSanPham', id);
        if (list.length === 0)
            return null;
        return list[0];
    },

    async sortByPrice() {
        const list = await db('sanpham').join('users','sanpham.EmailNguoiBan','=','users.Email')
            .orderBy('sanpham.GiaKhoiDiem', 'desc').select('sanpham.MaSanPham, sanpham.TenSanPham, sanpham.GiaKhoiDiem, users.HoTen');
        if (list.length === 0) {
            return null;
        }
        return list[5];
    }
}
