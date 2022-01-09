import express from 'express';
import bodyParser from "body-parser";
import * as fs from 'fs';
import fsExtra from 'fs-extra';
import multer from 'multer';
import moment from 'moment';

import bidModel from '../models/bid.model.js';
import productModel from '../models/product.model.js';
import sellerModel from '../models/seller.model.js';
import emailModel from '../models/email.models.js';

const router = express.Router();
const urlencodedParser = bodyParser.urlencoded({ extended: false })
router.use(bodyParser.urlencoded({extended: false}))

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

    // // Get information of user from session
    // const user = req.session.authUser || 0;
    // if (!user) {
    //     console.log("Please login first ! ");
    //     res.redirect('/');
    //     return;
    // }

    const isSeller = req.session.isSeller;
    if (!isSeller) {
        return res.redirect('/');
    }

    res.render('seller/post-product',{
        pActive,
        layout: 'seller.handlebars'
    });
});

router.post('/cancel', async(req, res) => {
    const bidder = req.body.Bidder;
    const proID = req.body.ProID;

    const product = await productModel.findByProID(proID);
    //console.log("ProID",proID);
    //console.log(product);

    const restrictEntity = {
        ProID: proID,
        Bidder: bidder,
    }

    await sellerModel.restrict(restrictEntity);
    await emailModel.sendBidCancel(bidder, product.ProName)
    await sellerModel.cancelBid(proID, bidder);
    const ret = await bidModel.findInBidding(proID);
    // console.log(ret);

    if(ret.length >0){
        const entity = {
            ProID: proID,
            CurrentWinner: ret[0].Bidder,
        }
        await productModel.updateProduct(entity);
        await emailModel.sendBidRevive(ret[0].Bidder, product.ProName,ret[0].CurPrice);
    } else{
        const entity = {
            ProID: proID,
            CurrentWinner: 'NULL'
        }
        await productModel.updateProduct(entity);
    }

    const url = req.headers.referer || '/seller/selling';

    return res.redirect(url);
});


// Validate number of pictures
async function validUploadLength (req, res, next) {
    if (req.files.length < 3) {
        for (let i = 1; i <= numberOfImage; i++) {
            let filePath = dir + `/${i}.jpg`;
            if (fs.existsSync(filePath)) {
                fs.unlinkSync(filePath);
            } else {
                console.log('Directory not found.');
            }
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
        AllowAllUsers: allow_users,
        ProState: true,
        CurrentWinner: null,
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

    const url = req.headers.referer || '/';
    return res.redirect(url);
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

    const isSeller = req.session.isSeller;
    if (!isSeller) {
        return res.redirect('/');
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
        // console.log(product[i].ProID)
        const query = await productModel.findByProID(product[i].ProID);
        // console.log(query);
        if(query.CurrentWinner!=null){
            product[i].CurrentWinner = query.CurrentWinner;
            product[i].CurPrice = query.Price;
        }else{
            product[i].CurrentWinner = "No bid yet";
            product[i].CurPrice = product[i].StartPrice;
            product[i].FinalBid = true;
        }

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
    // const user = req.session.authUser || 0;
    // if (!user) {
    //     console.log("Please login first ! ");
    //     res.redirect('/');
    //     return;
    // }

    // Get type of User: 1 -> Seller | 2 -> Bidder | 3 -> Admin
    const isSeller = req.session.isSeller;
    if (!isSeller) {
        return res.redirect('/');
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
    //console.log(product);

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

    const isSeller = req.session.isSeller;
    if (!isSeller) {
        return res.redirect('/');
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
});

router.post('/products/del',  async (req, res) => {
    const information = await productModel.findBigCatAndCatByProID(req.body.ProID);
    const ret = await productModel.del(req.body.ProID);

    let filePath = './public/images/Product/' + `${information.bigCatName}/` + `${information.catName}/` + `${req.body.ProID}`;

    if (fs.existsSync(filePath)) {
        //console.log('Directory exists!');
        fs.rmSync(filePath, { recursive: true });
    } else {
        console.log('Directory not found.');
    }

    const url = req.headers.referer || '/seller/products';
    return res.redirect(url);
});

export default router;