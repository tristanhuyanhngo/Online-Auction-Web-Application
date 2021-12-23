import db from '../utils/db.js';

export default {
    async findBigCategoryName(bigCatID) {
        const sql = `select BC.BigCatName
                     from big_category as BC
                     where BC.BigCatID = ${bigCatID}`;
        const list = await db.raw(sql);
        return list[0];
    },

    async findFromBigCategory(bigCatID) {
        const list = await db.select('*').from('category').join('big_category', {'category.BigCat': 'big_category.BigCatID'}).where('big_category.BigCatID', bigCatID);
        return list;
    },

    async findAllCat() {
        const sql = `select c.*, b.BigCatName, count(p.ProID) as ProCount
                     from category c
                              join big_category b
                                   on b.BigCatID = c.BigCat
                              left join product p on c.CatID = p.CatID
                     group by c.CatID, c.CatName`;
        const list = await db.raw(sql);
        return list[0];
    },

    async findAllWithDetails() {
        const sql = `select b.*, count(p.ProID) as ProCount
                     from product p
                              join
                          (category c join big_category b
                              on c.BigCat = b.BigCatID)
                          on p.CatID = c.CatID
                     group by b.BigCatID, b.BigCatName`;
        const list = await db.raw(sql);
        return list[0];
    },

    async countProductByCat(catId) {
        const sql = `select c.*, count(p.ProID) as ProCount
                     from product p
                              join
                          category c
                          on p.CatID = c.CatID
                     where c.CatID = ${catId}
                     group by c.CatID, c.CatName`;
        const list = await db.raw(sql);
        return list[0];
    }
}