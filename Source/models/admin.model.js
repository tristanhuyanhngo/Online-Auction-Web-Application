import db from '../utils/db.js';
import productModel from '../models/product.model.js';

export default {
    async findAll(){
        const user = await db.select().from('user');
        return user;
    },

    async del(email){
        await db('bidding').where('Bidder',email).del();
        const list = await db('product').where('Seller',email);
        for(let i in list){
            await productModel.delBySeller(list[i].ProID, email);
        }
        await db('user').where('Email',email).del();
    },

    async countUser(){
        const list = await db('user').select().from('user').count({amount : 'Email'} );
        return list[0].amount;
    },

    async countRequest(){
        const list = await db('user').select().from('user').whereNotNull('RequestTime').count({amount : 'Email'} );
        return list[0].amount;
    },

    async findAllLimit(limit, offset){
        const user = await db.select().from('user').limit(limit).offset(offset).orderBy('RegisterDate','desc');
        return user;
    },

    async findRequestLimit(limit, offset){
        const user = await db.select().from('user').whereNotNull('RequestTime').orderBy('RequestTime','desc').limit(limit).offset(offset);
        return user;
    },

    async declineReq(entity) {
        const email = entity.Email;

        const sql = `update user
                        set RequestTime = NULL
                        where Email = '${email}'`;
        await db.raw(sql);
    },

    async acceptReq(entity) {
        const email = entity.email;
        const time = entity.time;

        const sql = `update user
                     set RequestTime = NULL,
                         Type = '2',
                         AcceptTime = '${time}'
                     where Email = '${email}'`;
        await db.raw(sql);
        return db('user').where('Email',email);
    },

    async setBackBidder(email) {
        const sql = `update user
                     set AcceptTime = NULL,
                         Type = '2'
                     where Email = '${email}'`;
        await db.raw(sql);
        return db('user').where('Email',email);
    },
}
