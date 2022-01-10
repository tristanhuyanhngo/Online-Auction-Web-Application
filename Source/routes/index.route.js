import express from 'express';
import bodyParser from "body-parser";
import bcrypt from "bcryptjs";
import moment from "moment";
import reCapt from 'express-recaptcha';
import productHome from "../models/product.model.js";
import productSearch from "../models/search.model.js";
import userModel from "../models/user.model.js";
import emailModel from "../models/email.models.js";
import productModel from "../models/product.model.js";
import passport from "passport";
import '../auth/authG.js'

const RC = reCapt.RecaptchaV3;
const recaptcha = new RC('6LfL_ukdAAAAAG6NMUqQsNLhSnhD9X2IVAB24XiC', '6LfL_ukdAAAAAOymLm0tldwv1RZIyPDq27lmoBmt', {callback:'cb'});

const router = express.Router();
const urlencodedParser = bodyParser.urlencoded({ extended: false });
router.use(bodyParser.urlencoded({ extended: false }));

let filterSearch = "";
let searchContent = "product";

// ---------------- HOME ---------------- //
router.get('/', async function (req, res) {
    const list_1 = await productHome.sortByEndDate();
    const list_2 = await productHome.sortByBid();
    const list_3 = await productHome.sortByPrice();

    for(let i in list_1) {
        list_1[i].noBid = false;
        list_1[i].user = req.session.authUser;
        const countBidding = await productModel.countBidding(list_1[i].ProID);
        list_1[i].countBidding = countBidding[0].count;
        if (list_1[i].Price==null) {
            list_1[i].noBid = true;
        } else {
            let bidRet = await productModel.findBidding(list_1[i].ProID);
            list_1[i].biddingHighest = bidRet[0];
        }

        if (req.session.auth != false) {
            let inWish = await productModel.isInWishList(list_1[i].ProID, req.session.authUser.Email);
            if (inWish.length > 0) {
                list_1[i].isWish = true;
            }
        }
        // smaller 10 minutes is new
        if(moment.now() - list_1[i].UploadDate <= 600000)
            list_1[i].isNew = true;
    }

    for(let i in list_2) {
        list_2[i].noBid = false;
        list_2[i].user = req.session.authUser;
        const countBidding = await productModel.countBidding(list_2[i].ProID);
        list_2[i].countBidding = countBidding[0].count;
        if (list_2[i].Price==null) {
            list_2[i].noBid = true;
        } else {
            let bidRet = await productModel.findBidding(list_2[i].ProID);
            list_2[i].biddingHighest = bidRet[0];
        }

        if (req.session.auth != false) {
            let inWish = await productModel.isInWishList(list_2[i].ProID, req.session.authUser.Email);
            if (inWish.length > 0) {
                list_2[i].isWish = true;
            }
        }

        // smaller 10 minutes is new
        if(moment.now() - list_2[i].UploadDate <= 600000)
            list_2[i].isNew = true;
    }

    for(let i in list_3) {
        list_3[i].noBid = false;
        list_3[i].user = req.session.authUser;
        const countBidding = await productModel.countBidding(list_3[i].ProID);
        list_3[i].countBidding = countBidding[0].count;
        if (list_3[i].Price==null) {
            list_3[i].noBid = true;
        } else {
            let bidRet = await productModel.findBidding(list_3[i].ProID);
            list_3[i].biddingHighest = bidRet[0];
        }

        if (req.session.auth != false) {
            let inWish = await productModel.isInWishList(list_3[i].ProID, req.session.authUser.Email);
            if (inWish.length > 0) {
                list_3[i].isWish = true;
            }
        }

        // smaller 10 minutes is new
        if(moment.now() - list_3[i].UploadDate <= 600000)
            list_3[i].isNew = true;
    }

    res.render('home', {
        products: list_1,
        products_1: list_2,
        products_2: list_3
    });
});

// ---------------- SEARCH ---------------- //
router.get('/search', async function (req, res) {
    const page = req.query.page || 1;
    const type = req.query.type || 1; //0: price , 1: time
    let checkType = false;

    if (type == 0)
        checkType = false;
    else checkType = true;

    const limit = 8;
    let total = 0;

    if (filterSearch == 'category') {
        total = await productModel.countByCategoryFTX(searchContent);
    }
    else {
        total = await productModel.countByProductNameFTX(searchContent);
    }

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
    let list;

    if (filterSearch == 'category') {
        list = await productModel.findByCategoryFTX(searchContent, limit, offset);
    }
    else {
        list = await productModel.findByNameFTX(searchContent, limit, offset);
    }

    let isFirst = 1;
    let isLast = 1;
    for (let i in list) {
        list[i].noBid = false;
        list[i].user = req.session.authUser;
        const countBidding = await productModel.countBidding(list[i].ProID);
        list[i].countBidding = countBidding[0].count;
        if (list[i].Price == null) {
            list[i].noBid = true;
        } else {
            let bidRet = await productModel.findBidding(list[i].ProID);
            list[i].biddingHighest = bidRet[0];
        }

        if (req.session.auth !== false) {
            let inWish = await productModel.isInWishList(list[i].ProID, req.session.authUser.Email);
            if (inWish.length > 0) {
                list[i].isWish = true;
            }
        }

        if(moment.now() - list[i].UploadDate <= 600000)
            list[i].isNew = true;
    }

    if (list.length !== 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    const href = "search"

    console.log(list[3])

    res.render('search', {
        products: list,
        empty: list.length === 0,
        page_numbers,
        isFirst,
        isLast,
        catName: "SEARCH: " + searchContent,
        type,
        href,
        checkType,
        filterSearch,
        searchContent
    });
});

router.post('/search', async function (req, res) {
    filterSearch = req.body.filterSearch;
    searchContent = req.body.searchContent;

    res.redirect('search');
})

// ---------------- REGISTER ---------------- //
router.get('/register', recaptcha.middleware.render, async function(req, res) {
    if(req.session.auth === true) {
        res.redirect("/");
    }
    else
        res.render('register');
});

router.get('/forget-password', async function(req, res) {
    res.render('otp/forget-password');
});

router.post('/forget-password', async function(req, res) {
    const email = req.body.Email;
    const user = await userModel.findByEmail(email);

    if(user === null){
        return res.render('otp/forget-password',{
            error: 'Email not found. Please try again!'
        });
    }

    req.session.forgetUser = email;
    //console.log(req.session.forgetUser);
    const otp = emailModel.sendOTP(email);
    req.body.OTP = otp.toString();
    await userModel.updateUser(req.body);

    return res.redirect('/confirm-otp');
});

router.get('/confirm-otp', async function(req, res) {
    res.render('otp/confirm-otp');
});

router.get('/reset-success', async function(req, res) {
    res.render('otp/reset-success');
});

router.post('/confirm-otp', async function(req, res) {
    const email = req.session.forgetUser;
    //console.log(email);
    const ret = await userModel.findOTP(email);
    const otpInput = req.body.OTP;

    if(otpInput !== ret.OTP){
        return res.render('otp/confirm-otp',{
            error: 'OTP is incorrect!'
        });
    }
    const password = emailModel.sendNewPassword(email);
    req.body.Email = email;
    req.body.OTP = 'NULL';
    req.body.Password = password;
    await userModel.updateUser(req.body);

    req.session.forgetUser = null;
    return res.redirect('/reset-success');
});

router.post('/register', recaptcha.middleware.verify,async function(req, res) {
    if (!req.recaptcha.error) {
        const rawPassword = req.body.password;
        const salt = bcrypt.genSaltSync(10);
        const hash = bcrypt.hashSync(rawPassword, salt);
        const today = moment().format();
        const otp = emailModel.sendOTPRegister(req.body.email);

        const user = {
            Email: req.body.email,
            Username: req.body.username,
            Password: hash,
            Name: req.body.fullName,
            Address: null,
            DOB: null,
            RegisterDate: today,
            Type: 2,
            Rate: 0,
            OTP: otp.toString(),
            Valid: false
        }

        await userModel.addUser(user);
        req.session.registerUser = req.body.email;

        res.redirect('/confirm-register');
    }
    else {
        return res.render('register',{
            error: 'Please check the captcha! !'
        });
    }

});

router.get('/confirm-register', async function(req, res) {
    res.render('otp/otp-register');
});

router.get('/register-success', async function(req, res) {
    res.render('otp/register-success');
});

router.post('/confirm-register', async function(req, res) {
    const email = req.session.registerUser;
    const ret = await userModel.findOTP(email);
    const otpInput = req.body.OTP;

    if(otpInput !== ret.OTP){
        return res.render('otp/confirm-otp',{
            error: 'OTP is incorrect!'
        });
    }
    req.body.Email = email;
    req.body.OTP = 'NULL';
    req.body.Valid = true;
    await userModel.updateUser(req.body);

    req.session.registerUser = null;
    return res.redirect('/register-success');
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

router.get('/is-available-register', async function (req, res) {
    const email = req.query.user;
    const user = await userModel.findByEmailRegister(email);

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

router.get('/username-available', async function (req, res) {
    const username = req.query.username;
    const user = await userModel.findByUsernameRegister(username);
    if (user === null) {
        return res.json(true);
    }
    else {
        return res.json(false);
    }
});

// ---------------- LOGIN ---------------- //
router.get('/login', recaptcha.middleware.render, async function(req, res){
    if(req.session.auth === true) {
        res.redirect("/");
    }
    else
        res.render('login', { captcha:recaptcha.render() });
});

router.get('/auth/google', passport.authenticate('google', { scope: [ 'email', 'profile' ] }
    ));

router.get('/auth/google/callback', passport.authenticate('google', { failureRedirect: '/failed' }),
    async function (req, res) {
        const email = req.user.emails[0].value
        const user = await userModel.findByEmail(email);
        if(user === null) {
            const today = moment().format();
            const username = email.split("@")[0]

            const userRegister = {
                Email: req.user.emails[0].value,
                Username: username,
                Password: "null",
                Name: req.user.name.familyName + " " + req.user.name.givenName,
                Address: null,
                DOB: null,
                RegisterDate: today,
                Type: 2,
                Rate: 0,
                Valid: true
            }

            await userModel.addUser(userRegister);

            req.session.auth=true;
            req.session.authUser=userRegister;

            const url = req.session.retUrl||'/';
            res.redirect(url);
        }
        else {
            // 1 - Seller , 2 - Bidder, 3 - Admin
            req.session.auth=true;
            req.session.authUser=user;

            if (user.Type === '3') {
                req.session.isSeller = true;
                req.session.isAdmin = true;
            }
            else if (user.Type === '1') {
                req.session.isSeller = true;
                req.session.isAdmin = false;
            }

            const url = req.session.retUrl||'/';
            res.redirect(url);
        }
    }
);

router.post('/login', recaptcha.middleware.verify, async function (req, res) {
    if (!req.recaptcha.error) {
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
                error: 'Invalid username or password!'
            });
        }

        delete user.Password;

        req.session.auth=true;
        req.session.authUser=user;
    
        if (user.Type === '3') {
            req.session.isAdmin = true;
        }
        else if (user.Type === '1') {
            req.session.isSeller = true;
            req.session.isAdmin = false;
        }
    
        const url = req.session.retUrl||'/';
        res.redirect(url);
    } 
    else {
        return res.render('login',{
            error: 'Please check the captcha!'
        });
    }
});

// ---------------- LOGOUT ---------------- //
router.post('/logout', async function(req, res) {
    req.session.auth = false;
    req.session.authUser = null;
    req.session.isSeller = null;
    req.session.isAdmin = null;

    res.locals.auth=req.session.auth;
    res.locals.authUser=req.session.authUser;
    res.locals.isSeller=req.session.isSeller;
    res.locals.isAdmin=req.session.isAdmin;

    const url = req.headers.referer || '/';
    res.redirect(url);
});

router.get('/profile/:username', async function (req, res) {
    if (req.session.auth === false) {
        req.session.retUrl = req.originalUrl;
        return res.redirect('/login');
    }

    const Username = req.params.username;

    let viewSelf = false;
    if(Username === req.session.authUser.Username){
        viewSelf= true;
    }

    const user = await userModel.findByUsername(Username);

    if (user === null) {
        return res.redirect('/');
    }

    const email = user.Email;
    const rateList = await userModel.findRating(email);

    let hasReview = false;
    if(rateList.length>0){
        hasReview = true;
    }

    return res.render('profile', {
        user,
        rateList,
        hasReview,
        viewSelf
    });
});

export default router;