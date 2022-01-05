import db from '../utils/db.js';
import productModel from "./product.model.js";
import bidModel from "./bid.model.js";

export default {
    async findByEmail(email) {
        const user = await db('user').where({
            Email: email,
            Valid: true
        });
        return user[0] || null;
    },

    async findByEmailRegister(email) {
        const user = await db('user').where({
            Email: email,
        });
        return user[0] || null;
    },

    async findOTP(email) {
        const user = await db('user').select('OTP').where({
            Email: email
        });
        return user[0] || null;
    },

    async findByUsername(username) {
        const user = await db('user').where({
            Username: username,
            Valid: true
        });
        return user[0] || null;
    },

    async findByUsernameRegister(username) {
        const user = await db('user').where({
            Username: username,
        });
        return user[0] || null;
    },

    async addUser(entity) {
        return db('user').insert(entity);
    },

    async delUser(email) {
        const listPro = await db('bidding').where('Bidder',email);
        for(let i in listPro){
            const entity = {
                ProID: listPro[i].ProID,
                CurrentWinner: 'NULL',
                MaxPrice: 'NULL'
            }
            await productModel.updateProduct(entity);
        }
        await db('bidding').where('Bidder',email).del();

        const listMaxBid = await bidModel.findMax();
        for(let i in listMaxBid){
            const entity = {
                ProID: listMaxBid[i].ProID,
                CurrentWinner: listMaxBid[i].Bidder,
                MaxPrice: listMaxBid[i].MaxPrice
            }
            await productModel.updateProduct(entity);
        }

        const list = await db('product').where('Seller',email);
        for(let i in list){
            await productModel.delBySeller(list[i].ProID, email);
        }
        return db('user').where('Email', email).del();
    },

    async updateUser(entity) {
        const email = entity.Email;
        delete entity.Email;
        await db('user').where('Email', email).update(entity);
        return db('user').where('Email', email);
    },

    async updateEmail(entity) {
        const username = entity.Username;
        delete entity.Username;
        await db('user').where('Username', username).update(entity);
        return db('user').where('Username', username);
    },

    async updatePassword(entity) {
        const email = entity.Email;
        delete entity.Email;
        await db('user').where('Email', email).update(entity);
        return db('user').where('Email', email);
    }
}