import db from '../utils/db.js';

export default {
    // async findBigCategoryName(bigCatID) {
    //     const sql = `select BC.BigCatName from big_category as BC where BC.BigCatID = ${bigCatID}`;
    //     const list = await db.raw(sql);
    //     return list[0];
    // },

    async findByUsername(username){
        const user = await db('user').where('username',username);
        return user[0];
    },

    //
    // async findAllWithDetails(){
    //     const sql = `select b.*, count(p.ProID) as ProCount
    //                  from product p join
    //                       (category c join big_category b
    //                           on c.BigCat = b.BigCatID)
    //                       on p.CatID = c.CatID
    //                  group by b.BigCatID, b.BigCatName`;
    //     const list = await db.raw(sql);
    //     return list[0];
    // }
}