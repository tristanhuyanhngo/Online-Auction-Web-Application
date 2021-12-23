import express from 'express';
import productModel from '../models/product.model.js';
import adminModel from '../models/admin.model.js';
import categoryModel from '../models/category.model.js';
import bodyParser from 'body-parser';
import bcrypt from "bcryptjs";
import moment from "moment";
import userModel from "../models/user.model.js";
const router = express.Router();

router.use(bodyParser.urlencoded({ extended: false }))
router.get('/', async (req, res) => {
    let cActive = true;

    const bigcat = await categoryModel.findAllWithDetails();
    console.log(bigcat);
    res.render('admin/category-parent', {
        cActive,
        bigcat,
        layout: 'admin.handlebars'
    });
});

router.get('/category-parent', async (req, res) => {
    let cActive = true;

    const bigcat = await categoryModel.findAllWithDetails();
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
        RegisterDate: today,
        Type: req.body.Role,
        Rate: 0
    }
    const ret = await userModel.addUser(user);
    console.log(ret);
    // return null;
    res.redirect('/admin/account');
});

router.post('/account/update',async function(req, res) {
    const ret = await userModel.updateUser(req.body);
    console.log(ret);
    return res.redirect('/admin/account');
});

router.post('/account/del',   async (req, res) => {
    const ret = await userModel.delUser(req.body.Email);
    console.log(ret);
    return res.redirect('/admin/account');
});

router.get('/category-child', (req, res) => {
    let cActive = true;
    res.render('admin/category-child',{
        cActive,
        layout: 'admin.handlebars'
    });
});

router.get('/category-parent', (req, res) => {
    let cActive = true;
    res.render('admin/category-parent',{
        cActive,
        layout: 'admin.handlebars'
    });
});

router.post('/product/del',   async (req, res) => {
    const ret = await productModel.del(req.body.ProID);
    console.log(ret);
    return res.redirect('/admin/product');
});

router.get('/product', async (req, res) => {
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

    res.render('admin/product', {
        pActive,
        product,
        layout: 'admin.handlebars',
        empty: product.length === 0,
        page_numbers,
        isFirst: page_numbers[0].isCurrent,
        isLast: page_numbers[nPage-1].isCurrent,
    });
});

router.get('/account', async (req, res) => {
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
    let color = [];
    for(let i=0;i<user.length;i++){
        if(user[i].Type==='0'){
            user[i].Type = "admin";
            color.push(true);
        }
        else if(user[i].Type==='1'){
            user[i].Type="seller";
            color.push(false);
        }
        else {
            user[i].Type = "bidder";
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
        isFirst: page_numbers[0].isCurrent,
        isLast: page_numbers[nPage-1].isCurrent,
    });
});

router.get('/account-request', (req, res) => {
    let aActive = true;
    res.render('admin/accountRequest',{
        aActive,
        layout: 'admin.handlebars'
    });
});

export default router;