import db from '../utils/db.js';

export default {
    findAll() {
        return db('product');
    },

    async findAllWithDetails(){
        const sql = `select b.*, count(p.ProID) as ProCount
                     from product p join
                          (category c join big_category b
                              on c.BigCat = b.BigCatID)
                          on p.CatID = c.CatID
                     group by b.BigCatID, b.BigCatName`;
        const list = await db.raw(sql);
        return list[0];
    },

    async findById(id) {
        const list = await db('product').where('ProID', id);
        if (list.length === 0)
            return null;

        return list[0];
    },

    // add(entity) {
    //     return db('categories').insert(entity);
    // },
    //
    // del(id) {
    //     return db('categories')
    //         .where('CatID', id)
    //         .del();
    // },
    //
    // patch(entity) {
    //     const id = entity.CatID;
    //     delete entity.CatID;
    //
    //     return db('categories')
    //         .where('CatID', id)
    //         .update(entity);
    // },
}