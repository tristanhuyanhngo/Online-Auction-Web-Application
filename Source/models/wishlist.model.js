import db from '../utils/db.js';

export default {
    async countByEmail(email){
        const sql = `select count(Bidder) as amount
                     from wish_list
                     where Bidder='${email}'`;
        const raw = await db.raw(sql);
        return raw;
    },

    async delPro(id,email){
        return db('wish_list').where({
            ProID: id,
            Bidder: email
        }).del();
    },

    async findPageByEmail(email, limit, offset) {
        const sql = `select w.*, p.ProName, u.Name as Seller, p.ProState
                     from wish_list w join product p
                                           on w.ProID = p.ProID
                                      join user u on p.Seller = u.Email
                     where Bidder = '${email}'
                     limit ${limit} offset ${offset}`;
        const raw = await db.raw(sql);
        return raw[0];
    },
}
