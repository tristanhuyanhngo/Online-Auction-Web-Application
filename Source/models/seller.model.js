import db from '../utils/db.js';

export default {
    async findIDProduct() {
        const ID = await db.max(`ProID`).from(`product`);
        return Object.values(ID[0])[0];
    }
};