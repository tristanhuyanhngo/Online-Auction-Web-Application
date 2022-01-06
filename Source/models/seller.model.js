import db from '../utils/db.js';

export default {
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
    }
};