import db from '../utils/db.js';
import asyncErrors from 'express-async-errors'

export default {
    async countDown() {

    },
    async findAll() {
        const product = await db.select().from('product');
        return product;
    },

    async del(id) {
        return db('product').where('ProID', id).del();
    },

    async countProduct() {
        const list = await db('products').select().from('product').count({amount: 'ProID'});
        return list[0].amount;
    },

    async countCatID(id) {
        const sql = `select count(p.ProID) as amount
                     from product p
                              join
                          category c
                          on p.CatID = c.CatID
                     where c.CatID = ${id}`;
        const raw = await db.raw(sql);
        return raw;
    },

    async findAllLimit(limit, offset) {
        const product = await db.select().from('product').limit(limit).offset(offset);
        return product;
    },

    async findDescriptionProduct(proId) {
        const sql = `select d.*
                     from product as p,
                          description as d
                     where p.ProID = ${proId}
                       and p.ProID = d.ProID`;
        const raw = await db.raw(sql);
        return raw[0][0];
    },

    async findByCatID(catId, proId) {
        const sql = `select p.*, c.CatName, bc.BigCatName
                     from product as p,
                          category as c,
                          big_category as bc
                     where p.CatID = ${catId}
                       and p.ProID != ${proId}
                       and
                         c.CatID = p.CatID
                       and
                         bc.BigCatID = c.BigCat
                         limit 5
                     offset 0`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async findByProID(proId) {
        const sql = `select product.*, category.CatName, big_category.BigCatName
                     from product,
                          category,
                          big_category
                     where product.ProID = ${proId}
                       and product.CatID = category.CatID
                       and category.BigCat = big_category.BigCatID`;
        const raw = await db.raw(sql);
        return raw[0][0];
    },

    async countBigCatId(bigCatId) {
        const sql = `select count(p.ProID) as amount
                     from product p
                              join
                          (category c join big_category b
                              on c.BigCat = b.BigCatID)
                          on p.CatID = c.CatID
                     where BigCatID = ${bigCatId}`;
        const raw = await db.raw(sql);
        return raw;
    },

    async findPageByBigCatId(bigCatId, limit, offset) {
        const sql = `select p.*, b.BigCatName, c.CatName
                     from product p
                              join
                          (category c join big_category b
                              on c.BigCat = b.BigCatID)
                          on p.CatID = c.CatID
                     where BigCatID = ${bigCatId} limit ${limit}
                     offset ${offset}`;
        const raw = await db.raw(sql);
        return raw;
    },

    async findPageByCatID(catId, limit, offset) {
        const sql = `select p.*, c.CatName, bc.BigCatName
                     from product as p,
                          category as c,
                          big_category as bc
                     where p.CatID = ${catId}
                       and c.CatID = p.CatID
                       and bc.BigCatID = c.BigCat
                         limit ${limit}
                     offset ${offset}`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async isInWishList(proID, email) {
        const sql = `select *
                     from wish_list w
                     where ProID = ${proID}
                       and w.Bidder = '${email}'`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async findBidding (proID) {
        const sql = `select *
                     from bidding b
                     where ProID = ${proID}
                     order by b.Price DESC limit 0, 5`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async countBidding (proID) {
        const sql = `select count(ProID) as count
                     from bidding b
                     where ProID = ${proID}`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async sortByEndDate() {
        const sql = `select C.CatName,
                            L.BigCatName,
                            P.ProID,
                            P.ProName,
                            P.StartPrice,
                            U.Name as Seller,
                            P.SellPrice,
                            P.EndDate
                     from product as P,
                          user as U,
                          category as C,
                          big_category as L
                     where P.Seller = U.Email
                       and P.CatID = C.CatID
                       and C.BigCat = L.BigCatID
                     order by P.EndDate - P.UploadDate ASC limit 0, 4`;
        const raw = await db.raw(sql);
        return raw;
    },

    async sortByBid() {
        const sql = ` select C.CatName,
                             L.BigCatName,
                             P.ProID,
                             P.ProName,
                             P.StartPrice,
                             U.Name as Seller,
                             P.SellPrice,
                             P.EndDate
                      from product as P,
                           user as U,
                           category as C,
                           big_category as L
                      where P.Seller = U.Email
                        and P.ProID = 3
                        and P.CatID = C.CatID
                        and C.BigCat = L.BigCatID limit 0, 4`;
        const raw = await db.raw(sql);
        return raw;
    },

    async sortByPrice() {
        const sql = `select C.CatName,
                            L.BigCatName,
                            P.ProID,
                            P.ProName,
                            P.StartPrice,
                            U.Name as Seller,
                            P.SellPrice,
                            P.EndDate
                     from product as P,
                          user as U,
                          category as C,
                          big_category as L
                     where P.Seller = U.Email
                       and P.CatID = C.CatID
                       and C.BigCat = L.BigCatID
                     order by P.StartPrice DESC limit 0, 4`;
        const raw = await db.raw(sql);
        return raw;
    }
}
