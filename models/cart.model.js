import db from '../utils/db.js';

export default {
    async countByEmail(email) {
        const sql = `select count(*) as amount
                     FROM (
                              SELECT max(Time) as amount
                              from bidding
                              where Bidder = '${email}'
                              group by ProID
                          ) as new_table`;
        const raw = await db.raw(sql);
        return raw;
    },

    async findPageByEmail(email, limit, offset) {
        const sql = `select c.*, p.ProName, p.CurrentWinner,ct.CatName, b.BigCatName, p.SellPrice,
                            u.Name as Seller,u.Email as SellerMail, p.ProState, p.SellPrice, Max(c.Time) as MaxTime,
                            p.CurrentWinner='${email}' as SelfWin, (
                                SELECT nb.Price
                                FROM bidding as nb
                                WHERE nb.ProID=p.ProID
                                  AND time = (
                             SELECT max(time)
                             FROM bidding new_b
                             WHERE new_b.ProID=nb.ProID
                             )
                             ) as CurrentPrice

                     from bidding c
                         join product p
                     on c.ProID = p.ProID
                         join user u on p.Seller = u.Email
                         join category ct
                         on p.CatID = ct.CatID
                         join big_category b
                         on ct.BigCat = b.BigCatID
                     where Bidder = '${email}'
                     group by c.ProID
                     ORDER BY SelfWin DESC
                     limit ${limit}
                     offset ${offset}`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async checkout(entity){
        await db('success_bid').insert(entity);
        await db('product').where('ProID',entity.ProID).update({
            ProState: 0,
            CurrentWinner: entity.Bidder
        })
        await db('bidding').where('ProID',entity.ProID).del();
    },

    async findProductToCheckout(email) {
        const sql = `select c.*, p.*, u.Name as Seller, u.Email as SellerMail
                     from bidding c
                              join product p
                                   on c.ProID = p.ProID
                              join user u on p.Seller = u.Email
                     where Bidder = '${email}'
                       and p.ProState = 1`;
        const raw = await db.raw(sql);
        return raw[0];
    },
}
