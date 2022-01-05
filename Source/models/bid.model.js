import db from '../utils/db.js';
import asyncErrors from 'express-async-errors'

export default {
    async addBidding (entity) {
        return db('bidding').insert(entity);
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
