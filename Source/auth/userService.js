import db from '../utils/db.js';
import bcrypt from "bcryptjs";

export default {
    async findByEmail(email){
        const user = await db('user').where('Email',email);
        return user[0] || null;
    },
    async validPassword(user, password) {
        return bcrypt.compareSync(password, user.Password);
    }
};