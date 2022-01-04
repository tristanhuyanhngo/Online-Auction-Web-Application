import express from 'express';
import productModel from '../models/product.model.js';
import categoryModel from '../models/category.model.js';
//import userModel from "../models/user.model";
import userModel from "../models/user.model.js";

const router = express.Router();

router.get('/detail/:id', async function(req, res) {
    req.session.retUrl = req.originalUrl;
    const pro_id = req.params.id || 0;
    const product = await productModel.findByProID(pro_id);
    let user = null;
    let inWish = false;

    if(res.locals.auth != false){
        user = req.session.authUser.Email;
        const isWish = await productModel.isInWishList(pro_id,user);

        if(isWish.length >0){
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
    console.log(seller);

    res.render('product', {
        product,
        inWish,
        related_products,
        description: description.Content,
        seller
    });
});

router.get('/byBigCat/:id', async function (req, res) {
    const bigCatId = req.params.id || 0;
    const page = req.query.page || 1;

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
    const list = await productModel.findPageByBigCatId(bigCatId,limit,offset);

    let isFirst = 1;
    let isLast = 1;

    if(list.length != 0){
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage-1].isCurrent;
    }

    res.render('vwProduct/byCat', {
        products: list[0],
        empty: list.length === 0,
        page_numbers,
        isFirst,
        isLast,
        bigCategory: bigCat
    });
});

router.get('/byCat/:id', async function (req, res) {
    const CatID = req.params.id || 0;
    const page = req.query.page || 1;

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
    const list = await productModel.findPageByCatID(CatID,limit,offset);

    let isFirst = 1;
    let isLast = 1;


    if(list.length != 0){
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage-1].isCurrent;
    }
    res.render('vwProduct/byCat', {
        products: list,
        empty: list.length === 0,
        page_numbers,
        isFirst,
        isLast
    });
});

export default router;