import express from 'express';
import productModel from '../models/product.model.js';
import adminModel from '../models/admin.model.js';
import categoryModel from '../models/category.model.js';
import bodyParser from 'body-parser';
import bcrypt from "bcryptjs";
import moment from "moment";
import * as fs from 'fs';

import userModel from "../models/user.model.js";
const router = express.Router();

router.use(bodyParser.urlencoded({ extended: false }))
router.get('/', async (req, res) => {
    const isAdmin = req.session.isAdmin;
    if (!isAdmin) {
        return res.redirect('/');
    }

    let cActive = true;

    const user = req.session.authUser || 0;
    if (!user) {
        console.log("Please login first ! ");
        res.redirect('/');
        return;
    }
<<<<<<< HEAD
=======

>>>>>>> 6ec889640da94dc619f1087d116c5bca4408fcd7
    if (!isAdmin) {
        console.log("You don't have permission to access this page ! ");
        res.redirect('/');
        return;
    }

    const bigcat = await categoryModel.findAllWithDetails();
    console.log(bigcat);
    res.render('admin/category-parent', {
        cActive,
        bigcat,
        layout: 'admin.handlebars'
    });
});

router.get('/category-parent', async (req, res) => {
    const isAdmin = req.session.isAdmin;
    if (!isAdmin) {
        return res.redirect('/');
    }

    let cActive = true;

    const bigcat = await categoryModel.findAllWithDetails();

    for (let i in bigcat){
        if(bigcat[i].ProCount === 0){
            bigcat[i].hasProduct=false;
        } else{
            bigcat[i].hasProduct=true;
        }
    }

    console.log(bigcat);
    res.render('admin/category-parent', {
        cActive,
        bigcat,
        layout: 'admin.handlebars'
    });
});

router.post('/account/add',async function(req, res)  {
    const rawPassword = req.body.Password;
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(rawPassword, salt);
    const today = moment().format();

    const user = {
        Email: req.body.Email,
        Username: req.body.Username,
        Password: hash,
        Name: req.body.Name,
        Address: null,
        DOB: null,
        Valid: true,
        RegisterDate: today,
        Type: req.body.Role,
        Rate: 0
    }
    const ret = await userModel.addUser(user);
    console.log(ret);
    const url = req.headers.referer || '/admin/account';
    return res.redirect(url);
});

router.post('/account/update',async function(req, res) {
    const ret = await userModel.updateUser(req.body);
    console.log(ret);
    const url = req.headers.referer || '/admin/account';
    return res.redirect(url);
});


router.post('/account/del',   async (req, res) => {
    const ret = await userModel.delUser(req.body.Email);
    console.log(ret);
    const url = req.headers.referer || '/admin/account';
    return res.redirect(url);
});

router.get('/category-child', async (req, res) => {
    const isAdmin = req.session.isAdmin;
    if (!isAdmin) {
        return res.redirect('/');
    }

    let cActive = true;
    const category = await categoryModel.findAllCat();
    const bigcat = await categoryModel.findAllWithDetails();

    for (let i in category){
        if(category[i].ProCount === 0){
            category[i].hasProduct=false;
        } else{
            category[i].hasProduct=true;
        }
    }

    res.render('admin/category-child', {
        cActive,
        category,
        bigcat,
        layout: 'admin.handlebars'
    });
});

router.post('/category-parent/add', async (req, res) => {
    const ret = await categoryModel.addBigCat(req.body);
    console.log(ret);
    const url = req.headers.referer || '/admin/category-parent';
    return res.redirect(url);
});

router.post('/category-child/add',async function(req, res)  {
    const ret = await categoryModel.addCat(req.body);
    console.log(ret);
    const url = req.headers.referer || '/admin/category-child';
    return res.redirect(url);
});

router.post('/category-parent/update',async function(req, res) {
    const ret = await categoryModel.updateBigCat(req.body);
    console.log(ret);
    const url = req.headers.referer || '/admin/category-parent';
    return res.redirect(url);
});

router.post('/category-parent/del',async function(req, res) {
    const ret = await categoryModel.delBigCat(req.body.BigCatID);
    console.log(ret);
    const url = req.headers.referer || '/admin/category-parent';
    return res.redirect(url);
});

router.post('/category-child/del',async function(req, res) {
    const ret = await categoryModel.delCat(req.body.CatID);
    console.log(ret);
    const url = req.headers.referer || '/admin/category-child';
    return res.redirect(url);
});

router.post('/category-child/update',async function(req, res) {
    const ret = await categoryModel.updateCat(req.body);
    console.log(ret);
    const url = req.headers.referer || '/admin/category-child';
    return res.redirect(url);
});

router.post('/product/del',   async (req, res) => {
    const information = await productModel.findBigCatAndCatByProID(req.body.ProID);
    const ret = await productModel.del(req.body.ProID);
    console.log(ret);

    let filePath = './public/images/Product/' + `${information.bigCatName}/` + `${information.catName}/` + `${req.body.ProID}`;

    if (fs.existsSync(filePath)) {
        //console.log('Directory exists!');
        fs.rmSync(filePath, { recursive: true });
    } else {
        console.log('Directory not found.');
    }

    const url = req.headers.referer || '/admin/product';
    return res.redirect(url);
});

router.get('/product', async (req, res) => {
    const isAdmin = req.session.isAdmin;
    if (!isAdmin) {
        return res.redirect('/');
    }

    let pActive = true;
    const page = req.query.page || 1;
    const limit = 6;

    const total = await productModel.countProduct();

    let nPage = Math.floor(total/limit);
    if(total%limit>0){
        nPage++;
    }

    const page_numbers = [];
    for (let i = 1; i <= nPage; i++) {
        page_numbers.push({
            value: i,
            isCurrent: +page === i
        });
    }

    const offset = (page-1)*limit;

    const product = await productModel.findAllLimit(limit,offset);


    let isFirst = 1;
    let isLast = 1;

    if (product.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    res.render('admin/product', {
        pActive,
        product,
        layout: 'admin.handlebars',
        empty: product.length === 0,
        page_numbers,
        isFirst,
        isLast
    });
});

router.get('/account', async (req, res) => {
    const isAdmin = req.session.isAdmin;
    if (!isAdmin) {
        return res.redirect('/');
    }

    let aActive = true;
    const page = req.query.page || 1;
    const limit = 6;

    const total = await adminModel.countUser();

    let nPage = Math.floor(total/limit);
    if(total%limit>0){
        nPage++;
    }

    const page_numbers = [];
    for (let i = 1; i <= nPage; i++) {
        page_numbers.push({
            value: i,
            isCurrent: +page === i
        });
    }

    const offset = (page-1)*limit;

    const user = await adminModel.findAllLimit(limit,offset);


    let isFirst = 1;
    let isLast = 1;

    if (user.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    let color = [];
    for(let i=0;i<user.length;i++){
        if(user[i].Type==='1'){
            user[i].Type = "seller";
            color.push(true);
        }
        else if(user[i].Type==='2'){
            user[i].Type="bidder";
            color.push(false);
        }
        else {
            user[i].Type = "admin";
            color.push(false);
        }
    }

    res.render('admin/account', {
        aActive,
        user,
        color,
        layout: 'admin.handlebars',
        empty: user.length === 0,
        page_numbers,
        isFirst,
        isLast
    });
});

router.post('/account-request/decline',   async (req, res) => {
    await adminModel.declineReq(req.body);
    const url = req.headers.referer || '/admin/account-request';
    return res.redirect(url);
});

router.post('/account-request/accept',   async (req, res) => {
    const time = moment().format();
    const entity={
        email: req.body.Email,
        time: time,
    }
    const ret = await adminModel.acceptReq(entity);
    req.session.bidder = false;
    req.session.authUser = ret[0];
    res.locals.authUser = req.session.authUser;
    const url = req.headers.referer || '/admin/account-request';
    return res.redirect(url);
});

router.get('/account-request', async (req, res) => {
    const isAdmin = req.session.isAdmin;
    if (!isAdmin) {
        return res.redirect('/');
    }

    let aActive = true;
    const page = req.query.page || 1;
    const limit = 6;

    const total = await adminModel.countRequest();

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
    const request = await adminModel.findRequestLimit(limit, offset);

    let isFirst = 1;
    let isLast = 1;

    if (request.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    res.render('admin/accountRequest', {
        aActive,
        request,
        layout: 'admin.handlebars',
        empty: request.length === 0,
        page_numbers,
        isFirst,
        isLast,
    });
});

export default router;