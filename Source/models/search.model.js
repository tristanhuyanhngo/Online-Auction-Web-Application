import db from '../utils/db.js';

export default {
    async countAllProducts() {
        const list = await db('product').count({ amount: 'ProID' });
        return list[0].amount
    },

    findAllPage(limit, offset) {
        const sql = `select C.CatName as CatName, L.BigCatName as CatLevel, P.ProID as ProID, P.ProName as ProName, P.StartPrice as OriginPrice, 
        U.Name as Seller, P.SellPrice as Price_BuyNow, P.EndDate as EndDate
                      from product as P, user as U, category as C, big_category as L
                      where P.Seller = U.Email and
                            P.CatID = C.CatID and
                            C.BigCat = L.BigCatID
                      limit ${limit} offset ${offset}`;
        const raw = db.raw(sql);
        return raw;
    },

    async countByCatID(CatID) {
        const list = await db('product').where('CatID', CatID).count({ amount: 'ProID' });
        return list[0].amount;
    },

    findPageByCatID(CatID, limit, offset) {
        return db(`product`).where(`CatID`,CatID).limit(limit).offset(offset);
    }
}