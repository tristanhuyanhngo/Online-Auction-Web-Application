import db from '../utils/db.js';

export default {
    async countCatId(catId){
        const list = await db('product').where('CatID', catId).count({amount : 'ProID'} );
        return list[0].amount;
    },

    async findPageByBigCatId(bigCatId,limit,offset){
        const sql = `select p.*, b.BigCatName,c.CatName
                    from product p join
                    (category c join big_category b
                    on c.BigCat = b.BigCatID)
                    on p.CatID = c.CatID
                    where BigCatID=${bigCatId}
                    limit ${limit} offset ${offset}`;
        const raw = await db.raw(sql);
        return raw;
    },

    async sortByEndDate() {
        const sql = `select C.CatName as CatName, L.BigCatName as BigCatName, P.ProID as ProID, P.ProName as ProName, P.StartPrice 
        as OriginPrice, U.Name as Seller, P.SellPrice as Price_BuyNow, P.EndDate as EndDate
                      from product as P, user as U, category as C, big_category as L
                      where P.Seller = U.Email and
                            P.CatID = C.CatID and
                            C.BigCat = L.BigCatID
                      order by P.EndDate - P.UploadDate ASC
                      limit 0, 4`;
        const raw = await db.raw(sql);
        return raw;
    },

    async sortByBid() {
        const sql = ` select C.CatName as CatName, L.BigCatName as BigCatName, P.ProID as ProID, P.ProName as ProName, P.StartPrice as OriginPrice, U.Name as Seller, P.SellPrice as Price_BuyNow, P.EndDate as EndDate
                      from product as P, user as U, category as C, big_category as L
                      where P.Seller = U.Email and
                            P.ProID = 3 and
                            P.CatID = C.CatID and
                            C.BigCat = L.BigCatID
                      limit 0, 4`;
        const raw = await db.raw(sql);
        return raw;
    },

    async sortByPrice() {
        const sql = `select C.CatName as CatName, L.BigCatName as BigCatName, P.ProID as ProID, P.ProName as ProName, P.StartPrice as OriginPrice, U.Name as Seller, P.SellPrice as Price_BuyNow, P.EndDate as EndDate
                     from product as P, user as U, category as C, big_category as L
                     where P.Seller = U.Email and
                         P.CatID = C.CatID and
                         C.BigCat = L.BigCatID
                     order by P.StartPrice DESC
                     limit 0, 4`;
        const raw = await db.raw(sql);
        return raw;
    }
}
