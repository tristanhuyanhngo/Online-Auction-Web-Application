import db from '../utils/db.js';

export default {
    async findByUsername(username){
        const user = await db('user').where('username',username);
        return user[0];
    },
}