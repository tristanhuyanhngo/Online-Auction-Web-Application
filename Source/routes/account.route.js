import express from 'express';
import userModel from '../models/user.model.js'
import bodyParser from "body-parser";
import bcrypt from "bcryptjs";
import wishlistModel from "../models/wishlist.model.js";
import cartModel from "../models/cart.model.js";
import wonbidModel from "../models/wonbid.model.js";
import bidModel from "../models/bid.model.js";
import moment from "moment";
import emailModel from "../models/email.models.js";

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
    let Type = "Bidder";
    if(res.locals.authUser.Type==='0'){
        Type="Admin";
    } else if(res.locals.authUser.Type==='1'){
        Type = "Seller";
    }
    res.render('bidder/edit-info',{
        gActive,
        Type,
        layout: 'account.handlebars'
    });
});

router.post('/setting/edit-info',async (req, res) => {
    const dob = moment(req.body.DOB).format();
    req.body.DOB = dob;
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

router.get('/setting/general',(req, res) => {
    let gActive = true;
    let Type = "Bidder";
    if(res.locals.authUser.Type==='0'){
        Type="Admin";
    } else if(res.locals.authUser.Type==='1'){
        Type = "Seller";
    }
    res.render('bidder/edit-info',{
        gActive,
        Type,
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

router.get('/request', (req, res) => {
    let rActive = true;
    console.log(res.locals.requested);
    res.render('bidder/request',{
        rActive,
        layout: 'account.handlebars'
    });
});

router.post('/request',async function(req, res) {
    const email = res.locals.authUser.Email;
    const time = moment().format();

    const entity ={
        Email: email,
        RequestTime: time
    }

    const ret = await userModel.updateUser(entity);
    res.locals.authUser = ret[0];
    req.session.authUser = ret[0];

    const url = '/account/request';
    return res.redirect(url);
});

router.get('/wishlist',async (req, res) => {
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
        if(list[i].ProState.readInt8() === 0){
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

router.post('/review',async function(req, res) {
    const email = res.locals.authUser.Email;
    const product = req.body.ProID;
    const receiver = req.body.SellerMail;
    const comment = req.body.content;

    let rate = true;
    let commentStr = ':) Nice. ';
    if(req.body.Rate === '0'){
        rate = false;
        commentStr=':( Bad. '
    }
    commentStr+=comment;
    const item = {
        Sender: email,
        Receiver: receiver,
        Comment: commentStr,
        Time: moment().format(),
        ProID: product,
        Rate: rate,
    }
    await userModel.addReview(item);
    await userModel.updateRate(receiver);

    const url = req.headers.referer || '/account/won-bid';
    return res.redirect(url);
});

router.post('/cart/checkout',async function(req, res) {
    const email = res.locals.authUser.Email;
    const bidder = await userModel.findByEmail(email);
    const today = moment().format();
    const list = await cartModel.findProductToCheckout(email);

    for(let i in list){
        let item = {
            ProID: list[i].ProID,
            Bidder: email,
            OrderDate: today
        }

        const highestBid = await bidModel.findMaxByID(list[i].ProID);
        const currentWinner = highestBid.Bidder;
        if(currentWinner != null){
            if(currentWinner!=email){
                await emailModel.sendBidDefeatEnd(currentWinner,list[i].ProName);
            }
        }
        //
        // console.log("Bidder ", bidder.Name);
        // console.log("Product ",list[i]);
        // console.log("Bidder " + email);
        // console.log("Seller",list[i].SellerMail);
        // console.log("Bidder name " + bidder.Name);
        // console.log("Product price: ",list[i].SellPrice);

        await emailModel.sendBidEndSuccess(email,bidder.Name,list[i].SellerMail,list[i].ProName,list[i].SellPrice);
        await cartModel.checkout(item);
    }
    return res.redirect('/account/cart');
});


router.get('/cart', async (req, res) => {
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
        if(list[i].ProState.readInt8()===1){
            totalPrice+=+list[i].SellPrice;
            amountProduct++;
            list[i].ProState = 'On air';
        } else {
            list[i].ProState = 'Sold';
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

router.get('/won-bid', async (req, res) => {
    let wbActive = true;

    const page = req.query.page || 1;
    const email = req.session.authUser.Email;

    const limit = 4;
    const raw = await wonbidModel.countByEmail(email);
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
    const list = await wonbidModel.findPageByEmail(email, limit, offset);

    for(let i in list){
        list[i].evaluated = ((await wonbidModel.evaluated(email, list[i].ProID))[0].amount===1);
    }

    let isFirst = 1;
    let isLast = 1;

    if (list.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    res.render('bidder/won-bid', {
        wbActive,
        products: list,
        empty: list.length === 0,
        page_numbers,
        isFirst,
        isLast,
        layout: 'account.handlebars'
    });
});

export default router;