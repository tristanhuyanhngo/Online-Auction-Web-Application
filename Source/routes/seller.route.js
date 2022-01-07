import express from 'express';
import bodyParser from "body-parser";
import * as fs from 'fs';
import fsExtra from 'fs-extra';
import multer from 'multer';
import moment from 'moment';

import bidModel from '../models/bid.model.js';
import productModel from '../models/product.model.js';
import sellerModel from '../models/seller.model.js';

const router = express.Router();
const urlencodedParser = bodyParser.urlencoded({ extended: false })
router.use(bodyParser.urlencoded({ extended: false }));

// ****************************************************************************************
// --------------------------------------- POST PRODUCT -----------------------------------------
let ID = await productModel.findIDProduct();
let dir = './public/images/Product/' + (ID+1).toString();
let dir_temp;

if (!fs.existsSync(dir)){
    fs.mkdirSync(dir);
};

let numberOfImage = 0;

const storage = multer.diskStorage({
    destination: function (request, file, callback) {
        let path = dir ;
        callback(null, path);
    },
    filename: function (request, file, callback) {
        ++numberOfImage
        const name = numberOfImage.toString() + ".jpg"
        callback(null, name);
    }
});

const upload = multer({storage: storage});

router.get('/', async (req, res) => {
    let pActive = true;

    // Get information of user from session
    const user = req.session.authUser || 0;
    if (!user) {
        console.log("Please login first ! ");
        res.redirect('/');
        return;
    }

    // Get type of User: 1 -> Seller | 2 -> Bidder | 3 -> Admin
    const isSeller = req.session.isSeller;
    if (!isSeller) {
        console.log("You don't have permission to access this page ! ");
        res.redirect('/');
        return;
    }

    res.render('seller/post-product',{
        pActive,
        layout: 'seller.handlebars'
    });
});

router.post('/cancel', async(req, res) => {
    const bidder = req.body.Bidder;
    const proID = req.body.ProID;

    await sellerModel.cancelBid(proID, bidder);
    const url = req.headers.referer || '/seller/selling';

    return res.redirect(url);
});


// Validate number of pictures
async function validUploadLength (req, res, next) {
    if (req.files.length < 3) {
        for (let i = 1; i <= numberOfImage; i++) {
            let filePath = dir + `/${i}.jpg`;
            fs.unlinkSync(filePath);
        }
        numberOfImage = 0;
        res.render('seller/post-product',{
            layout: 'seller.handlebars',
            errorOfImages: true
        });
        return;
    }

    ID = await productModel.findIDProduct();
    dir_temp = './public/images/Product/' + await (ID+2).toString();

    if (!fs.existsSync(dir_temp)){
        fs.mkdirSync(dir_temp);
    };

    next()
}

router.post('/',urlencodedParser, [upload.array('img', 10),validUploadLength], async(req, res) => {
    let pActive = true;

    // Product
    ID = await productModel.findIDProduct();
    const cat_id = await productModel.findCatID(req.body.child_category);
    const sell_price = +req.body.sellPrice || 0;
    const date = new Date();
    const upload_date = moment(date).format('YYYY-MM-DD hh:mm:ss');
    const auto_extend = req.body.auto_renew === "Yes" ? true : false;
    const allow_users = req.body.allow_users === "Yes" ? true : false;
    const end_date = moment(req.body.end_date).format('YYYY-MM-DD 00:00:00');

    const product = {
        ProID: ID+1,
        CatID: cat_id,
        Seller: req.session.authUser.Email,
        ProName: req.body.title,
        StartPrice: +req.body.startPrice,
        StepPrice: +req.body.stepPrice,
        SellPrice: sell_price,
        UploadDate: upload_date,
        EndDate: end_date,
        AutoExtend: auto_extend,
        ProState: true,
        CurrentWinner: null,
        MaxPrice: 0
    }

    // Description
    const description_date = moment(date).format('DD/MM/YYYY hh:mm');
    const content = '<p>' + '<strong>' + description_date + '</strong>' + '</p>' + '\n' + req.body.content;

    const description = {
        ProID: ID+1,
        DesDate: upload_date,
        Content: content
    }

    // Images
    const cat_name = req.body.child_category;
    const bigCat_name = req.body.parent_category;
    const new_dir = './public/images/Product/' + bigCat_name + '/' + cat_name + '/' + (ID+1).toString();

    fsExtra.move(dir, new_dir, err => {
        if (err) {
            return console.error(err);
        }
        console.log(`Move to ${new_dir} successfully !`);
    });

    await productModel.addProduct(product);
    await productModel.addDescription(description);

    dir = dir_temp;
    numberOfImage = 0;

    res.render('seller/post-product',{
        pActive,
        layout: 'seller.handlebars'
    });
});

// ****************************************************************************************
// --------------------------------------- SELLING -----------------------------------------
router.get('/selling', async (req, res) => {
    let vActive = true;

    // // Get information of user from session
    // const user = req.session.authUser || 0;
    // if (!user) {
    //     console.log("Please login first ! ");
    //     res.redirect('/');
    //     return;
    // }

    // Get type of User: 1 -> Seller | 2 -> Bidder | 3 -> Admin
    const isSeller = req.session.isSeller;
    if (!isSeller) {
        console.log("You don't have permission to access this page ! ");
        res.redirect('/');
        return;
    }

    const seller = req.session.authUser.Email;
    const page = req.query.page || 1;
    const limit = 6;

    const total = await productModel.countProductNotSoldBySeller(seller);

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
    const product = await productModel.findBySellerNotSoldLimit(seller,limit,offset);
    for(let i in product){
        const query = await bidModel.findInBidding(product[i].ProID);
        const MaxPrice = query[0].MaxPrice
        product[i].MaxPrice = MaxPrice;
    }

    let isFirst = 1;
    let isLast = 1;

    if (product.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    res.render('seller/selling', {
        vActive,
        product,
        layout: 'seller.handlebars',
        empty: product.length === 0,
        page_numbers,
        isFirst,
        isLast
    });
});

// ****************************************************************************************
// --------------------------------------- SOLD-----------------------------------------
router.get('/sold', async (req, res) => {
    let vActive = true;

    // Get information of user from session
    const user = req.session.authUser || 0;
    if (!user) {
        console.log("Please login first ! ");
        res.redirect('/');
        return;
    }

    // Get type of User: 1 -> Seller | 2 -> Bidder | 3 -> Admin
    const isSeller = req.session.isSeller;
    if (!isSeller) {
        console.log("You don't have permission to access this page ! ");
        res.redirect('/');
        return;
    }

    const seller = req.session.authUser.Email;
    const page = req.query.page || 1;
    const limit = 6;

    const total = await productModel.countProductSoldBySeller(seller);

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
    const product = await productModel.findBySellerSoldLimit(seller,limit,offset);
    console.log(product);

    for (let i = 0; i < product.length; i++) {
        if (product[i].ProState[0]) {
            product[i].ProState = "Still on sale";
        }
        else {
            product[i].ProState = "Has been sold";
        }
    }

    let isFirst = 1;
    let isLast = 1;

    if (product.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    res.render('seller/sold', {
        vActive,
        product,
        layout: 'seller.handlebars',
        empty: product.length === 0,
        page_numbers,
        isFirst,
        isLast
    });
});

// ****************************************************************************************
// --------------------------------------- PRODUCTS -----------------------------------------
router.get('/products', async (req, res) => {
    let vActive = true;

    // // Get information of user from session
    // const user = req.session.authUser || 0;
    // if (!user) {
    //     console.log("Please login first ! ");
    //     res.redirect('/');
    //     return;
    // }

    // Get type of User: 1 -> Seller | 2 -> Bidder | 3 -> Admin
    const isSeller = req.session.isSeller;
    if (!isSeller) {
        console.log("You don't have permission to access this page ! ");
        res.redirect('/');
        return;
    }

    const seller = req.session.authUser.Email;
    const page = req.query.page || 1;
    const limit = 6;

    const total = await productModel.countProductBySeller(seller);

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

    const product = await productModel.findBySellerLimit(seller,limit,offset);

    let isFirst = 1;
    let isLast = 1;

    if (product.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    res.render('seller/products', {
        vActive,
        product,
        layout: 'seller.handlebars',
        empty: product.length === 0,
        page_numbers,
        isFirst,
        isLast
    });
});

router.post('/products',urlencodedParser, async (req, res) => {
    let vActive = true;

    // Add description
    const date = new Date();
    const description_date = moment(date).format('DD/MM/YYYY hh:mm');
    const upload_date = moment(date).format('YYYY-MM-DD hh:mm:ss');
    const content = '<p>' + '<strong>' + description_date + '</strong>' + '</p>' + '\n' + req.body.Content;

    const description = {
        ProID: req.body.ProID,
        DesDate: upload_date,
        Content: content
    }

    await productModel.addDescription(description);

    const url = req.headers.referer || '/seller/products';
    return res.redirect(url);

    // // Render
    // const seller = req.session.authUser.Email;
    // const page = req.query.page || 1;
    // const limit = 6;
    //
    // const total = await productModel.countProductBySeller(seller);
    //
    // let nPage = Math.floor(total/limit);
    // if(total%limit>0){
    //     nPage++;
    // }
    //
    // const page_numbers = [];
    // for (let i = 1; i <= nPage; i++) {
    //     page_numbers.push({
    //         value: i,
    //         isCurrent: +page === i
    //     });
    // }
    //
    // const offset = (page-1)*limit;
    //
    // const product = await productModel.findBySellerLimit(seller,limit,offset);
    //
    // for (let i = 0; i < product.length; i++) {
    //     if (product[i].ProState[0]) {
    //         product[i].ProState = "Has sold";
    //     }
    //     else {
    //         product[i].ProState = "Not sold yet";
    //     }
    // }
    //
    // let isFirst = 1;
    // let isLast = 1;
    //
    // if (product.length != 0) {
    //     isFirst = page_numbers[0].isCurrent;
    //     isLast = page_numbers[nPage - 1].isCurrent;
    // }
    //
    // res.render('seller/products', {
    //     vActive,
    //     product,
    //     layout: 'seller.handlebars',
    //     empty: product.length === 0,
    //     page_numbers,
    //     isFirst,
    //     isLast
    // });
});

export default router;