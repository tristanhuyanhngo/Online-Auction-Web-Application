import express from 'express';
import userModel from '../models/user.model.js'

const router = express.Router();


// ---------------- PROFILE ---------------- //
router.get('/profile', async function (req, res) {
    res.render('./vwAccount/profile');
});

router.get('/is-available', async function (req, res) {
    const email = req.query.user;
    const user = await userModel.findByEmail(email);
    console.log(user);
    if(user ==null){
        return res.json(true);
    }
    else return res.json(false);
});

export default router;