import db from '../utils/db.js';

export default {
    async countByEmail(email){
        const sql = `select count(Bidder) as amount
                     from success_bid
                     where Bidder='${email}'`;
        const raw = await db.raw(sql);
        return raw;
    },

    async findPageByEmail(email, limit, offset) {
        const sql = `select w.*, p.ProName, u.Name as Seller, p.ProState
                     from success_bid w join product p
                                           on w.ProID = p.ProID
                                      join user u on p.Seller = u.Email
                     where Bidder = '${email}'
                     limit ${limit} offset ${offset}`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async evaluated(email,proid){
        const sql = `select count(*) as amount from
                        success_bid w join rating r
                        on w.ProID = r.ProID
                        and w.Bidder = r.Sender
                     where w.Bidder = '${email}' 
                       and w.ProID = ${proid}`;
        const raw = await db.raw(sql);
        return raw[0];
    }
}
