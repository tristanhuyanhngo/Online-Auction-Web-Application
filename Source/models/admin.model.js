import db from '../utils/db.js';

export default {
    async findAll(){
        const user = await db.select().from('user');
        return user;
    },

    async del(email){
        return db('user').where('Email',email).del();
    },

    async countUser(){
        const list = await db('user').select().from('user').count({amount : 'Email'} );
        return list[0].amount;
    },

    async findAllLimit(limit, offset){
        const user = await db.select().from('user').limit(limit).offset(offset);
        return user;
    },

    // async findDescriptionProduct(proId) {
    //     const sql = `select d.*
    //                  from product as p, description as d
    //                  where p.ProID = ${proId} and
    //                        p.ProID = d.ProID`;
    //     const raw = await db.raw(sql);
    //     return raw[0][0];
    // },
    //
    // async findByCatID(catId, proId) {
    //     const sql = `select p.*, c.CatName, bc.BigCatName
    //                  from product as p, category as c, big_category as bc
    //                  where p.CatID = ${catId} and
    //                        p.ProID != ${proId} and
    //                        c.CatID = p.CatID and
    //                        bc.BigCatID = c.BigCat
    //                  limit 5 offset 0`;
    //     const raw = await db.raw(sql);
    //     return raw[0];
    // },
    //
    // async findByProID(proId) {
    //     const sql = `select product.*, category.CatName, big_category.BigCatName
    //                  from product, category, big_category
    //                  where product.ProID = ${proId} and
    //                      product.CatID = category.CatID and
    //                      category.BigCat = big_category.BigCatID`;
    //     const raw = await db.raw(sql);
    //     return raw[0][0];
    // },
    //
    // async countBigCatId(bigCatId){
    //     const sql = `select count(p.ProID) as amount
    //                     from product p join
    //                          (category c join big_category b
    //                              on c.BigCat = b.BigCatID)
    //                          on p.CatID = c.CatID
    //                     where BigCatID=${bigCatId}`;
    //     const raw = await db.raw(sql);
    //     return raw;
    // },
    //
    // async findPageByBigCatId(bigCatId,limit,offset){
    //     const sql = `select p.*, b.BigCatName,c.CatName
    //                 from product p join
    //                 (category c join big_category b
    //                 on c.BigCat = b.BigCatID)
    //                 on p.CatID = c.CatID
    //                 where BigCatID=${bigCatId}
    //                 limit ${limit} offset ${offset}`;
    //     const raw = await db.raw(sql);
    //     return raw;
    // },
    //
    // async sortByEndDate() {
    //     const sql = `select C.CatName, L.BigCatName, P.ProID, P.ProName, P.StartPrice, U.Name as Seller, P.SellPrice, P.EndDate
    //                   from product as P, user as U, category as C, big_category as L
    //                   where P.Seller = U.Email and
    //                         P.CatID = C.CatID and
    //                         C.BigCat = L.BigCatID
    //                   order by P.EndDate - P.UploadDate ASC
    //                   limit 0, 4`;
    //     const raw = await db.raw(sql);
    //     return raw;
    // },
    //
    // async sortByBid() {
    //     const sql = ` select C.CatName, L.BigCatName, P.ProID, P.ProName, P.StartPrice, U.Name as Seller, P.SellPrice, P.EndDate
    //                   from product as P, user as U, category as C, big_category as L
    //                   where P.Seller = U.Email and
    //                         P.ProID = 3 and
    //                         P.CatID = C.CatID and
    //                         C.BigCat = L.BigCatID
    //                   limit 0, 4`;
    //     const raw = await db.raw(sql);
    //     return raw;
    // },
    //
    // async sortByPrice() {
    //     const sql = `select C.CatName, L.BigCatName, P.ProID, P.ProName, P.StartPrice, U.Name as Seller, P.SellPrice, P.EndDate
    //                  from product as P, user as U, category as C, big_category as L
    //                  where P.Seller = U.Email and
    //                      P.CatID = C.CatID and
    //                      C.BigCat = L.BigCatID
    //                  order by P.StartPrice DESC
    //                  limit 0, 4`;
    //     const raw = await db.raw(sql);
    //     return raw;
    // }
}
