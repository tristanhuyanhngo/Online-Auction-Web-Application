import express from 'express';
import userModel from '../models/user.model.js'
import bodyParser from "body-parser";
import bcrypt from "bcryptjs";
import wishlistModel from "../models/wishlist.model.js";
import cartModel from "../models/cart.model.js";
import auth from "../middlewares/auth.mdw.js";

const router = express.Router();
router.use(bodyParser.urlencoded({ extended: false }))

// ---------------- PROFILE ---------------- //
router.get('/', (req, res) => {
    // Get information of user from session
    const user = req.session.authUser || 0;
    if (!user) {
        console.log("Please login first ! ");
        res.redirect('/');
        return;
    }
    res.render('profile');
});

router.get('/profile', auth,async function (req, res) {
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
router.get('/setting', auth,(req, res) => {
    let gActive = true;
    res.render('bidder/edit-info',{
        gActive,
        layout: 'account.handlebars'
    });
});

router.post('/setting/edit-info',async (req, res) => {
    const ret = await userModel.updateUser(req.body);
    res.locals.authUser = ret[0];
    req.session.authUser = ret[0];
    console.log(ret[0]);
    res.redirect('/account/setting');
});

router.post('/setting/edit-email',async (req, res) => {
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

router.get('/setting/general', auth,(req, res) => {
    let gActive = true;
    res.render('bidder/edit-info',{
        gActive,
        layout: 'account.handlebars'
    });
});

router.get('/setting/password', auth,(req, res) => {
    let pActive = true;
    res.render('bidder/change-password',{
        pActive,
        layout: 'account.handlebars'
    });
});

router.get('/wishlist', auth,async (req, res) => {
    let wActive = true;

    const page = req.query.page || 1;
    const email = req.session.authUser.Email;

    const limit = 9;
    const raw = await wishlistModel.countByEmail(email);
    const total = raw[0][0].amount;

    let nPage = Math.floor(total / limit);
    if (total % limit > 0) {
        nPage++;
    }

    const page_numbers = [];
    for (let i = 1; i <= nPage; i++) {
        page_numbers.push({
            value: i,
            isCurrent: +page === i
        });
    }

    const offset = (page - 1) * limit;
    const list = await wishlistModel.findPageByEmail(email, limit, offset);

    let isFirst = 1;
    let isLast = 1;


    if (list.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    for (let i in list){
        if(list[i].ProState === false){
            list[i].ProState="Sold";
        } else{
            list[i].ProState="On air";
        }
    }

    res.render('bidder/wishlist', {
        wActive,
        products: list,
        empty: list.length === 0,
        page_numbers,
        isFirst,
        isLast,
        layout: 'account.handlebars'
    });
});

router.post('/wishlist/del',async function(req, res) {
    const email = res.locals.authUser.Email;
    const ret = await wishlistModel.delPro(req.body.ProID,email);
    console.log(ret);

    const url = req.headers.referer || '/account/wishlist';
    return res.redirect(url);
});

router.post('/wishlist/add',async function(req, res) {
    const email = res.locals.authUser.Email;
    const product = req.body.ProID;

    const item = {
        ProID: product,
        Bidder: email
    }
    const ret = await wishlistModel.add(item);
    console.log(ret);

    const url = req.headers.referer || '/account/wishlist';
    return res.redirect(url);
});

router.get('/cart', auth,async (req, res) => {
    let cActive = true;

    const page = req.query.page || 1;
    const email = req.session.authUser.Email;
    let totalPrice = 0;
    let amountProduct=0;

    const limit = 4;
    const raw = await cartModel.countByEmail(email);
    const total = raw[0][0].amount;

    let nPage = Math.floor(total / limit);
    if (total % limit > 0) {
        nPage++;
    }

    const page_numbers = [];
    for (let i = 1; i <= nPage; i++) {
        page_numbers.push({
            value: i,
            isCurrent: +page === i
        });
    }

    const offset = (page - 1) * limit;
    const list = await cartModel.findPageByEmail(email, limit, offset);
    console.log(list);

    let isFirst = 1;
    let isLast = 1;


    if (list.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    for (let i in list) {
        totalPrice+=+list[i].SellPrice;
        amountProduct++;
        if (list[i].ProState === false) {
            list[i].ProState = "Sold";
        } else {
            list[i].ProState = "On air";
        }
    }

    res.render('bidder/cart', {
        cActive,
        products: list,
        totalPrice,
        amountProduct,
        empty: list.length === 0,
        page_numbers,
        isFirst,
        isLast,
        layout: 'account.handlebars'
    });
});

router.get('/won-bid', auth,(req, res) => {
    let wbActive = true;
    res.render('bidder/won-bid',{
        wbActive,
        layout: 'account.handlebars'
    });
});

export default router;