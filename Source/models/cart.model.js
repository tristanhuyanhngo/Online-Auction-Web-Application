import db from '../utils/db.js';

export default {
    async countByEmail(email){
        const sql = `select count(Bidder) as amount
                     from cart
                     where Bidder='${email}'`;
        const raw = await db.raw(sql);
        return raw;
    },

    async delPro(id,email){
        return db('cart').where({
            ProID: id,
            Bidder: email
        }).del();
    },

    async add(entity){
        return db('cart').insert(entity);
    },

    async findPageByEmail(email, limit, offset) {
        const sql = `select c.*, p.ProName, ct.CatName, b.BigCatName, u.Name as Seller, p.ProState, p.SellPrice
                     from cart c join product p
                                      on c.ProID = p.ProID
                                 join user u on p.Seller = u.Email
                                 join category ct
                                      on p.CatID = ct.CatID
                                 join big_category b
                                      on ct.BigCat = b.BigCatID

                     where Bidder = '${email}'
                     limit ${limit} offset ${offset}`;
        const raw = await db.raw(sql);
        return raw[0];
    },
}
