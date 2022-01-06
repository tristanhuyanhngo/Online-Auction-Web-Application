import express from 'express';
import productModel from '../models/product.model.js';
import categoryModel from '../models/category.model.js';
//import userModel from "../models/user.model";
import userModel from "../models/user.model.js";
import bodyParser from "body-parser";

const router = express.Router();

const urlencodedParser = bodyParser.urlencoded({ extended: false });

router.get('/detail/:id', async function(req, res) {
    req.session.retUrl = req.originalUrl;
    const pro_id = req.params.id || 0;
    const product = await productModel.findByProID(pro_id);
    let user = null;
    let inWish = false;

    let bidding = await productModel.findBidding(pro_id);

    for(let i = 0; i < bidding.length; i++) {
        const tempUser = await userModel.findByEmail(bidding[i].Bidder);
        bidding[i].Name = tempUser.Name;
    }

    let biddingHighest
    if(bidding != null) {
        biddingHighest = bidding.shift();
    }

    if(res.locals.auth != false){
        user = req.session.authUser.Email;
        const isWish = await productModel.isInWishList(pro_id,user);

        if(isWish.length > 0){
            inWish = true;
        }
    }

    if (product === undefined) {
        return res.redirect('/');
    }

    const description = await productModel.findDescriptionProduct(pro_id);

    const related_products = await productModel.findByCatID(product.CatID, product.ProID);

    //console.log(product);

    let seller  = await userModel.findByEmail(product.Seller);

    res.render('product', {
        product,
        inWish,
        related_products,
        description: description.Content,
        seller,
        bidding,
        biddingHighest
    });
});

router.get('/byBigCat/:id', async function (req, res) {
    const bigCatId = req.params.id || 0;
    const page = req.query.page || 1;
    const type = req.query.type || 1; //0: price , 1: time
    let checkType = false;

    if(type == 0)
        checkType = false;
    else checkType = true;

    const bigCategory_name = await categoryModel.findBigCategoryName(bigCatId)
    const bigCat = bigCategory_name[0].BigCatName;

    const limit = 8;
    const raw = await productModel.countBigCatId(bigCatId);
    const total = raw[0][0].amount;

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
    const list = await productModel.findPageByBigCatId(bigCatId,limit,offset, type);



    let isFirst = 1;
    let isLast = 1;


    for(let i = 0; i < list[0].length; i++) {
        let bidding = await productModel.findBidding(list[0][i].ProID);
        list[0][i].biddingHighest = bidding.shift();
        list[0][i].user = res.locals.authUser;
        const countBidding = await productModel.countBidding(list[0][i].ProID);
        list[0][i].countBidding = countBidding[0].count;

        if(res.locals.auth != false){
            let isWish = await productModel.isInWishList(list[0][i].ProID,req.session.authUser.Email);

            if(isWish.length > 0){
                list[0][i].isWish = true;
            }
        }
    }

    if(list.length != 0){
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage-1].isCurrent;
    }

    const href = "byBigCat"

    res.render('vwProduct/byCat', {
        products: list[0],
        empty: list[0].length === 0,
        page_numbers,
        isFirst,
        isLast,
        bigCategory: bigCat,
        type,
        href,
        CatID: bigCatId,
        checkType
    });
});

router.get('/byCat/:id', async function (req, res) {
    const CatID = req.params.id || 0;
    const page = req.query.page || 1;
    const type = req.query.type || 1; //0: price , 1: time

    let checkType = false;

    if(type == 0)
        checkType = false;
    else checkType = true;

    const limit = 8;
    const raw = await productModel.countCatID(CatID);
    const total = raw[0][0].amount;

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
    const list = await productModel.findPageByCatID(CatID,limit,offset, type);

    let isFirst = 1;
    let isLast = 1;

    for(let i = 0; i < list.length; i++) {
        let bidding = await productModel.findBidding(list[i].ProID);
        list[i].biddingHighest = bidding.shift();
        list[i].user = res.locals.authUser;
        const countBidding = await productModel.countBidding(list[i].ProID);
        list[i].countBidding = countBidding[0].count;

        if(res.locals.auth != false){
            let isWish = await productModel.isInWishList(list[i].ProID,req.session.authUser.Email);

            if(isWish.length > 0){
                list[i].isWish = true;
            }
        }
    }

    //console.log(list);

    if(list.length != 0){
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage-1].isCurrent;
    }

    const href = "byCat"
    res.render('vwProduct/byCat', {
        products: list,
        empty: list.length === 0,
        page_numbers,
        isFirst,
        isLast,
        type,
        CatID,
        href,
        checkType
    });
});


// router.post('/select', urlencodedParser,async function(req, res) {
//     console.log(req.headers.referer);
//     const url = req.headers.referer;
//     if(url.includes("byCat")) {
//       const arr = url.split("/");
//       const id = arr[arr.length-1];
//     }
//     if(req.headers.referer.includes("byBigCat"))
//         console.log("byBigCat")
// });

export default router;