import db from '../utils/db.js';

export default {
    async updateProduct(entity) {
        const proid = entity.ProID;
        delete entity.ProID;
        return db('product').where('ProID', proid).update(entity);
    },

    async findAll() {
        const product = await db.select().from('product');
        return product;
    },

    async del(id) {
        await db('description').where('ProID', id).del();
        return db('product').where('ProID', id).del();
    },

    async delBySeller(id, seller) {
        await db('description').where('ProID', id).del();
        await db('product').where('Seller', seller).del();
    },

    async countProduct() {
        const list = await db('products').select().from('product').count({amount: 'ProID'});
        return list[0].amount;
    },

    async countProductBySeller(seller) {
        const list = await db('products').select().from('product').where('Seller', seller).count({amount: 'ProID'});
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

    async findBySellerLimit(seller,limit, offset) {
        const product = await db.select().from('product').where('Seller', seller).limit(limit).offset(offset);
        return product;
    },

    async findDescriptionProduct(proId) {
        const sql = `select d.Content
                     from product as p,
                          description as d
                     where p.ProID = ${proId}
                       and p.ProID = d.ProID`;
        const raw = await db.raw(sql);
        return raw[0];
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

    async findPageByBigCatId(bigCatId, limit, offset, type) {
        let sql;
        if (type == 1) {
            sql = `select p.*, b.BigCatName, c.CatName, u.Name as SellerName,t.Price as Price
                   from product p
                            join
                        (category c join big_category b
                            on c.BigCat = b.BigCatID)
                        on p.CatID = c.CatID
                            join user u on p.Seller = u.Email
                            left join
                        (select *, MAX(Price) as CurPrice
                         from bidding
                         group by ProID) as t on p.ProID = t.ProID
                               where BigCatID = ${bigCatId}
                                 and p.ProState = 1
                               order by p.EndDate
                         limit ${limit}
                     offset ${offset}`;
            const raw = await db.raw(sql);
            return raw[0];
        }
        sql = `select p.*, b.BigCatName, c.CatName, 
                        u.Name as SellerName, t.Price as Price
                     from product p
                              join
                          (category c join big_category b
                              on c.BigCat = b.BigCatID)
                          on p.CatID = c.CatID
                              join user u on p.Seller = u.Email
                              left join
                          (select *, MAX(Price) as CurPrice
                           from bidding
                           group by ProID) as t on p.ProID = t.ProID
                                 where BigCatID = ${bigCatId}
                                   and p.ProState = 1
                                 order by t.CurPrice
                         limit ${limit}
                     offset ${offset}`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async findPageByCatID(catId, limit, offset, type) {
        let sql;
        if (type == 1) {
            sql = `select p.*, b.BigCatName, c.CatName, u.Name as SellerName, t.Price as Price
                   from product p
                            join
                        (category c join big_category b
                            on c.BigCat = b.BigCatID)
                        on p.CatID = c.CatID
                            join user u on p.Seller = u.Email
                            left join
                        (select *, MAX(Price) as CurPrice
                         from bidding
                         group by ProID) as t on p.ProID = t.ProID
                   where p.CatID = ${catId}
                     and p.ProState = 1
                   order by p.EndDate
                         limit ${limit}
                     offset ${offset}`;
            const raw = await db.raw(sql);
            return raw[0];
        }
        sql = `select p.*, b.BigCatName, c.CatName, u.Name as SellerName, t.Price as Price
               from product p
                        join
                    (category c join big_category b
                        on c.BigCat = b.BigCatID)
                    on p.CatID = c.CatID
                        join user u on p.Seller = u.Email
                        left join
                    (select *, MAX(Price) as CurPrice
                     from bidding
                     group by ProID) as t on p.ProID = t.ProID
                       where p.CatID = ${catId}
                         and p.ProState = 1
                       order by t.CurPrice
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

    async findBidding(proID) {
        const sql = `select *
                     from bidding b
                     where ProID = ${proID}
                     order by b.Price DESC limit 0, 5`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async findBidDetails(proID) {
        const sql = `select ProID, Bidder, Time, u.Name, MAX (Price) as Price
                     from bidding b join user u
                     on b.Bidder = u.Email
                     group by ProID
                     having ProID = ${proID}`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async countBidding(proID) {
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
                            P.EndDate, u.Name as SellerName
                     from product as P,
                          user as U,
                          category as C,
                          big_category as L
                     where P.Seller = U.Email
                       and P.CatID = C.CatID
                       and C.BigCat = L.BigCatID
                       and P.EndDate - NOW() > 0
                     order by P.EndDate - NOW() ASC limit 0, 6`;
        const raw = await db.raw(sql);
        return raw[0];
    },

    async sortByBid() {
        const sql = `select C.CatName,
                            L.BigCatName,
                            P.ProID,
                            P.ProName,u.Name as SellerName,
                            P.StartPrice,
                            U.Name as Seller,
                            P.SellPrice,
                            P.EndDate,
                            B.ProID,
                            COUNT(P.ProID) AS sum
                     from product as P,
                         user as U,
                         category as C,
                         big_category as L,
                         bidding as B
                     where P.Seller = U.Email
                       and P.CatID = C.CatID
                       and C.BigCat = L.BigCatID
                       and P.EndDate - NOW()
                         > 0
                       and B.ProID = P.ProID
                     GROUP BY P.ProID
                     ORDER BY sum DESC limit 0, 6`;
        const raw = await db.raw(sql);
        return raw[0];    },

    async sortByPrice() {
        const sql = `select C.CatName,
                            L.BigCatName,
                            P.ProID,
                            P.ProName,
                            P.StartPrice,
                            U.Name as Seller,
                            P.SellPrice,
                            P.EndDate,
                            B.ProID,u.Name as SellerName,
                            MAX(B.Price) AS max
                     from product as P,
                         user as U,
                         category as C,
                         big_category as L,
                         bidding as B
                     where P.Seller = U.Email
                       and P.CatID = C.CatID
                       and C.BigCat = L.BigCatID
                       and P.EndDate - NOW()
                         > 0
                       and B.ProID = P.ProID
                     GROUP BY P.ProID
                     ORDER BY max DESC limit 0, 6`;
        const raw = await db.raw(sql);
        return raw[0];    },

    async findCatID(Cat) {
        const sql = `select CatID
                     from category c
                     where c.CatName = '${Cat}'`;
        const raw = await db.raw(sql);
        return raw[0][0].CatID;
    },
    async findIDProduct() {
        const ID = await db.max(`ProID`).from(`product`);
        return Object.values(ID[0])[0];
    },
    async addProduct(entity) {
        return db('product').insert(entity);
    },
    async addDescription(entity) {
        return db('description').insert(entity);
    },
    async countProductNotSoldBySeller(seller) {
        const sql = `select count(*) as number
                     from product p
                     where p.Seller = '${seller}' and
                           p.ProState = true`;
        const raw = await db.raw(sql);
        return raw[0][0].number;
    },
    async countProductSoldBySeller(seller) {
        const sql = `select count(*) as number
                     from product p
                     where p.Seller = '${seller}' and
                           p.ProState = false`;
        const raw = await db.raw(sql);
        return raw[0][0].number;
    },
    async findBySellerNotSoldLimit(seller,limit,offset) {
        const sql = `select *
                     from product p
                     where p.Seller = '${seller}' and
                           p.ProState = true
                     limit ${limit} offset ${offset}`;
        const raw = await db.raw(sql);
        return raw[0];
    },
    async findBySellerSoldLimit(seller,limit,offset) {
        const sql = `select *
                     from product p
                     where p.Seller = '${seller}' and
                           p.ProState = false
                     limit ${limit} offset ${offset}`;
        const raw = await db.raw(sql);
        return raw[0];
    }
}
