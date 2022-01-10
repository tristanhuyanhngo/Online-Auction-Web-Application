import db from '../utils/db.js';
import asyncErrors from 'express-async-errors'

export default {
    async addBidding (entity) {
        return db('bidding').insert(entity);
    },


    async findMax () {
        const sql = `select ProID, Bidder, MAX(Price) as MaxPrice
                        from bidding
                        group by ProID`;
        const ret = await db.raw(sql);
        return ret[0];
    },

    async findMaxByID (proID) {
        const sql = `select ProID, Bidder, MAX(Time), Price as MaxPrice
                     from bidding
                     group by ProID
                     having ProID = ${proID}`;
        const ret = await db.raw(sql);
        return ret[0][0];
    },

    async findInBidding (proID) {
        const sql = `select ProID, Bidder, MAX(Time), MAX(Price) as CurPrice, MaxPrice
                        from bidding
                        group by ProID
                        having ProID = ${proID}`;
        const ret = await db.raw(sql);
        return ret[0];
    },

    async updateBidding (entity) {
        const proid = entity.ProID;
        const bidder = entity.Bidder;
        delete entity.ProID;
        delete entity.Bidder;
        return db('bidding').where({
            ProID: proid,
            Bidder: bidder
        }).update(entity);
    },
}
