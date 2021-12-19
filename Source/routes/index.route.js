import express from 'express';
import bodyParser from "body-parser";
import bcrypt from "bcryptjs";
import moment from "moment";

import productHome from "../models/product.model.js";
import productSearch from "../models/search.model.js";
import userModel from "../models/user.model.js";

const router = express.Router();

// ---------------- HOME ---------------- //
router.get('/', async function (req, res) {
    const list_1 = await productHome.sortByEndDate();
    const list_2 = await productHome.sortByBid();
    const list_3 = await productHome.sortByPrice();

    console.log(req.session.auth);
    console.log(req.session.authUser);

    res.render('home', {
        products: list_1[0],
        products_1: list_2[0],
        products_2: list_3[0]
    });
});

// ---------------- SEARCH ---------------- //
router.get('/search', async function (req, res) {
    const limit = 8;
    const page = req.query.page || 1;
    const offset = (page - 1) * limit;

    const total = await productSearch.countAllProducts();
    //console.log(total);
    let nPages = Math.floor(total / limit);
    if (total % limit > 0) {
        nPages++;
    }

    const page_numbers = [];
    for (let i = 1; i <= nPages; i++) {
        page_numbers.push({
            value: i,
            isCurrent: +page === i
        });
    }

    const list = await productSearch.findAllPage(limit, offset);
    res.render('search', {
        products: list[0],
        page_numbers,
        isFirst: page_numbers[0].isCurrent,
        isLast: page_numbers[nPages-1].isCurrent
    });
});

const urlencodedParser = bodyParser.urlencoded({ extended: false })

// ---------------- REGISTER ---------------- //
router.get('/register', async function(req, res) {
    res.render('register');
});

router.post('/register',urlencodedParser,async function(req, res) {
    const rawPassword = req.body.password;
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(rawPassword, salt);
    // const today = moment().format('YYYY-MM-DD');
    const today = moment().format();

    const user = {
        Email: req.body.email,
        Username: req.body.username,
        Password: hash,
        Name: req.body.fullName,
        Address: null,
        DOB: null,
        RegisterDate: today,
        Type: 2,
        Rate: 0
    }

    await userModel.addUser(user);
    res.render('register');
});

router.get('/is-available', async function (req, res) {
    const email = req.query.user;
    const user = await userModel.findByEmail(email);

    if (user === null) {
        return res.json(true);
    }
    else {
        return res.json(false);
    }
});

router.get('/check-username', async function (req, res) {
    const username = req.query.Username;
    const user = await userModel.findByUsername(username);

    if (user === null) {
        return res.json(true);
    }
    else {
        return res.json(false);
    }
});

// ---------------- LOGIN ---------------- //
router.get('/login', async function (req, res) {
    res.render('login');
});

router.post('/login',urlencodedParser, async function (req, res) {
    const email = req.body.email;
    const user = await userModel.findByEmail(email);

    if(user === null){
        return res.render('login',{
            error: 'Invalid username or password !'
        });
    }

    const ret = bcrypt.compareSync(req.body.password, user.Password);
    if(ret === false){
        return res.render('login',{
            error: 'Invalid username or password !'
        });
    }

    req.session.auth=true;
    req.session.authUser=user;

    res.redirect('/home');
});


router.get('/profile', (req, res) => {
    res.render('profile');
})

router.get('/user/:username', async function (req, res) {
    const Username = req.params.username || 0;

    const user = await userModel.findByUsername(Username);

    res.render('profileUserOther', {
        user
    });
});

export default router;