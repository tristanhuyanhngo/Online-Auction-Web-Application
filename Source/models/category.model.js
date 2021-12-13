import db from '../utils/db.js';

export default {
    findAll() {
        return db('product');
    },

    async findAllWithDetails(){
        const sql = `select c.*, b.BigCatName, count(p.ProID) as ProCount
                     from category c join big_category b on c.BigCat = b.BigCatID
                                     left join product p on c.CatID = p.CatID
                     group by c.CatID, c.CatName`;
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