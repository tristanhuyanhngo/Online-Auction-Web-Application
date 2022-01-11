import express from 'express';
import bodyParser from "body-parser";
import * as fs from 'fs';
import fsExtra from 'fs-extra';
import multer from 'multer';
import moment from 'moment';
import {v2 as cloudinary} from 'cloudinary';
import { CloudinaryStorage } from "multer-storage-cloudinary";

import bidModel from '../models/bid.model.js';
import productModel from '../models/product.model.js';
import sellerModel from '../models/seller.model.js';
import emailModel from '../models/email.models.js';
import userModel from "../models/user.model.js";
import wonbidModel from "../models/wonbid.model.js";

const router = express.Router();
const urlencodedParser = bodyParser.urlencoded({ extended: false })
router.use(bodyParser.urlencoded({extended: false}))

cloudinary.config({
    cloud_name: "horizon-web-online-auction",
    api_key: "277635668285695",
    api_secret: "u0Qd-zfF5T4nKMsKI4H6TWrJyBQ"
});

// ****************************************************************************************
// --------------------------------------- POST PRODUCT -----------------------------------------
let numberOfImage = 0;
let ID = await productModel.findIDProduct();

const storage = new CloudinaryStorage({
    cloudinary: cloudinary,
    params: {
        folder: `horizon/product/${ID+1}`,
        allowedFormats: ['jpg', 'png'],
        public_id: (req, file) => {
            ++numberOfImage;
            return numberOfImage.toString() +`-${ID + 1}`;
        }
    },
});

const upload = multer({ storage: storage });

router.get('/', async (req, res) => {
    let pActive = true;

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

    // console.log(product.ProName);
    await sellerModel.restrict(restrictEntity);
    await emailModel.sendBidCancel(bidder, product.ProName)
    await sellerModel.cancelBid(proID, bidder);
    const ret = await bidModel.findInBidding(proID);
    // console.log(ret);

    if(ret.length > 0){
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
async function validUploadLength(req, res, next) {
    ID = await productModel.findIDProduct();

    const fileExisted = await (cloudinary.api.sub_folders("horizon/products/", function(error, result){
        if (error) {
            console.log("Error read file existed - Cloudinary");
        } else {
            console.log("Read file existed succesfully - Cloudinary");
        }
    }));

    const fileList = fileExisted.folders;
    const checkExists = fileList.find( ({ name }) => name == `${ID+1}` );
    console.log(fileList);
    console.log(checkExists);

    if (checkExists != undefined) {
        let path = `horizon/products/${ID+1}`;
        console.log(path);
        cloudinary.api.delete_folder(path, function (error, result) {
            console.log(error);
        });
    }

    let errorCategory = false;
    let errorImages = false;
    let errorSellPriceLessThanStartPrice = false;
    let errorSellPriceLessThanStepPrice = false;
    let errorEmptyContent = false;

    // Validate category
    if (req.body.parent_category === 'Empty') {
        errorCategory = true;
    }

    // Validate price
    if (req.body.sellPrice != '') {
        if (+req.body.startPrice >= +req.body.sellPrice) {
            errorSellPriceLessThanStartPrice = true;
        }
        if (+req.body.stepPrice >= +req.body.sellPrice) {
            errorSellPriceLessThanStepPrice = true;
        }
    }

    // Validate images
    if (req.files.length < 3) {
        numberOfImage = 0;
        errorImages = true;
    }

    // Validate description
    const split = req.body.content.split('&nbsp;');
    let contentDescription = "";
    let countSpacebar = 0;
    let countEnter = 0;

    if (split.toString() === '') {
        errorEmptyContent = true;
    }

    for (let i = 0; i < split.length; i++) {
        if ((split[i] != ' ') && split[i] != '</p>\r\n\r\n<p>') {
            contentDescription += split[i];
        }
    }

    if (contentDescription === '<p></p>\r\n') {
        errorEmptyContent = true;
    }

    // Error -> render
    if (errorCategory || errorImages || errorSellPriceLessThanStartPrice || errorSellPriceLessThanStepPrice || errorEmptyContent) {
        res.render('seller/post-product',{
            layout: 'seller.handlebars',
            errorImages,
            errorCategory,
            errorSellPriceLessThanStartPrice,
            errorSellPriceLessThanStepPrice,
            errorEmptyContent
        });
        return;
    }

     next()
}

router.post('/', urlencodedParser, [upload.array('img',10), validUploadLength], async function(req, res) {
    let pActive = true;
    ID = await productModel.findIDProduct();
    let imageURLList = [];

    for (let i = 0; i < req.files.length; i++) {
        let url = req.files[i].path;
        imageURLList.push(url);
    }

    // Product
    const cat_id = await productModel.findCatID(req.body.child_category);
    const sell_price = +req.body.sellPrice || null;
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


    for (let i = 0; i < imageURLList.length; i++) {
        const picture = {
            ProID: ID+1,
            URL: imageURLList[i]
        }
        await productModel.addPicture(picture);
    }

    await productModel.addProduct(product);
    await productModel.addDescription(description);

    return res.render('seller/post-product',{
        pActive,
        layout: 'seller.handlebars',
        congratulations: true
    });
});

router.post('/review',async function(req, res) {
    const email = res.locals.authUser.Email;
    const product = req.body.ProID;
    const receiver = req.body.CurrentWinner;
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

    const url = req.headers.referer || '/seller/sold';
    return res.redirect(url);
});

router.post('/cancel-final',async function(req, res) {
    const email = res.locals.authUser.Email;
    const product = req.body.ProID;
    const receiver = req.body.Bidder;

    const pro = productModel.findByProID(product);

    let commentStr = 'Bidder did not receive product!';

    const item = {
        Sender: email,
        Receiver: receiver,
        Comment: commentStr,
        Time: moment().format(),
        ProID: product,
        Rate: false,
        Cancel: true
    }
    await userModel.addReview(item);
    await userModel.updateRate(receiver);

    await emailModel.sendBidCancel(receiver,pro.ProName);
    const url = req.headers.referer || '/seller/sold';
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
    const products = await productModel.findBySellerSoldLimit(seller,limit,offset);
    //console.log(product);

    let isFirst = 1;
    let isLast = 1;

    if (products.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    for(let i in products){
        // console.log(products[i]);
        products[i].canceled = ((await wonbidModel.cancelBySeller(products[i].CurrentWinner, products[i].ProID))[0].amount==1);
        products[i].evaluated = ((await wonbidModel.evaluatedBySeller(products[i].CurrentWinner, products[i].ProID))[0].amount==1);
        console.log(products[i].evaluated);
        console.log(products[i].canceled);
    }

    res.render('seller/sold', {
        vActive,
        products,
        layout: 'seller.handlebars',
        empty: products.length === 0,
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