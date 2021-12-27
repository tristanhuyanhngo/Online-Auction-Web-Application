import db from '../utils/db.js';

export default {
    async findByEmail(email) {
        const user = await db('user').where('Email', email);
        return user[0] || null;
    },

    async findByUsername(username) {
        const user = await db('user').where('Username', username);
        return user[0] || null;
    },

    async addUser(entity) {
        return db('user').insert(entity);
    },

    async delUser(email) {
        return db('user').where('Email', email).del();
    },

    async updateUser(entity) {
        const email = entity.Email;
        delete entity.Email;
        await db('user').where('Email', email).update(entity);
        return db('user').where('Email', email);
    },

    async updatePassword(entity) {
        const email = entity.Email;
        delete entity.Email;
        await
            db('user').where('Email', email).update(entity);
        return db('user').where('Email', email);
    }
}