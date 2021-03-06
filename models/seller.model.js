import db from '../utils/db.js';

export default {
    async cancelBid(ProID,bidder){
        await db('bidding').where({
            ProID: ProID,
            Bidder: bidder
        }).del();
    },

    async restrict(entity){
        await db('restrict').insert(entity);
    }
};