import express from 'express';
import userModel from '../models/user.model.js'
import bodyParser from "body-parser";
import bcrypt from "bcryptjs";

const router = express.Router();
router.use(bodyParser.urlencoded({ extended: false }))

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

router.get('/username-available', async function (req, res) {
    const username = req.query.user;
    const user = await userModel.findByUsername(username);
    if(user ==null){
        return res.json(true);
    }
    else return res.json(false);
});


//==============BIDDER's FUNCTIONS=================
router.get('/setting', (req, res) => {
    let gActive = true;
    res.render('bidder/edit-info',{
        gActive,
        layout: 'account.handlebars'
    });
});

router.post('/setting/edit-info', async (req, res) => {
    const ret = await userModel.updateUser(req.body);
    res.locals.authUser = ret[0];
    req.session.authUser = ret[0];
    console.log(ret[0]);
    res.redirect('/account/setting');
});

router.post('/setting/edit-email', async (req, res) => {
    const ret = await userModel.updateEmail(req.body);
    res.locals.authUser = ret[0];
    req.session.authUser = ret[0];
    console.log(ret[0]);
    console.log(req.session.authUser.Username);
    res.redirect('/account/setting');
});

router.post('/setting/password', async (req, res) => {
    const isEqual = bcrypt.compareSync(req.body.OldPassword, res.locals.authUser.Password);
    if(isEqual === false) {
        console.log("Error");
        return res.render('bidder/change-password', {
            pActive: true,
            error: 'Incorrect password!',
            layout: 'account.handlebars'
        });
    }

    const newPassword = req.body.Password;
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(newPassword, salt);

    const user = {
        Email: req.body.Email,
        Password: hash
    }

    const ret = await userModel.updatePassword(user);
    res.locals.authUser = ret[0];
    req.session.authUser = ret[0];
    console.log(ret[0]);
    return res.render('bidder/change-password', {
        pActive: true,
        success: 'Password changed!',
        layout: 'account.handlebars'
    });
});

router.get('/setting/general', (req, res) => {
    let gActive = true;
    res.render('bidder/edit-info',{
        gActive,
        layout: 'account.handlebars'
    });
});

router.get('/setting/password', (req, res) => {
    let pActive = true;
    res.render('bidder/change-password',{
        pActive,
        layout: 'account.handlebars'
    });
});

router.get('/wishlist', (req, res) => {
    let wActive = true;
    res.render('bidder/wishlist',{
        wActive,
        layout: 'account.handlebars'
    });
});

router.get('/cart', (req, res) => {
    let cActive = true;
    res.render('bidder/cart',{
        cActive,
        layout: 'account.handlebars'
    });
});

router.get('/won-bid', (req, res) => {
    let wbActive = true;
    res.render('bidder/won-bid',{
        wbActive,
        layout: 'account.handlebars'
    });
});

export default router;