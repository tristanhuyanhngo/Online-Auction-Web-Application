import express from 'express';
import productModel from '../models/product.model.js';
import categoryModel from '../models/category.model.js';
import bidModel from "../models/bid.model.js";
import userModel from "../models/user.model.js";
import emailModel from "../models/email.models.js";
import moment from "moment";
import bodyParser from "body-parser";

const router = express.Router();
router.use(bodyParser.urlencoded({extended: false}))

router.get('/check-bid', async function (req, res) {
    const queryPrice = req.query.price;
    const proID = req.query.pro;

    let product = await productModel.findByProID(proID);
    let maxPrice = product.MaxPrice;

    if (product.CurrentWinner === null) {
        return res.json(true);
    }

    if (queryPrice <= maxPrice) {
        return res.json(false);
    } else {
        return res.json(true);
    }
});

router.post('/detail/:id', async function (req, res) {
    const queryPrice = req.body.queryPrice;
    const ProID = req.params.id;
    const email = req.session.authUser.Email;

    let product = await productModel.findByProID(ProID);
    let maxPrice = product.MaxPrice;
    let step = product.StepPrice;

    const url = '/product/detail/' + ProID;

    if (product.CurrentWinner === null) {
        const bid = {
            ProID: ProID,
            Bidder: email,
            Time: moment().format(),
            Price: queryPrice
        }
        await bidModel.addBidding(bid);

        const productEntity = {
            ProID: ProID,
            CurrentWinner: email,
            MaxPrice: queryPrice
        }
        await productModel.updateProduct(productEntity);
        return res.redirect(url);
    }

    if (queryPrice <= maxPrice) {
        const bid = {
            ProID: ProID,
            Bidder: product.CurrentWinner,
            Time: moment().format(),
            Price: queryPrice
        }
        await bidModel.updateBidding(bid);
        return res.redirect(url);
    } else {
        emailModel.sendBidDefeat(product.CurrentWinner, product.ProName);
        const newPrice = maxPrice + step;
        const bid = {
            ProID: ProID,
            Bidder: email,
            Time: moment().format(),
            Price: newPrice
        }
        const ret = await bidModel.addBidding(bid);
        console.log(ret);

        const productEntity = {
            ProID: ProID,
            CurrentWinner: email,
            MaxPrice: queryPrice
        }
        await productModel.updateProduct(productEntity);
        return res.redirect(url);
    }
});


router.get('/detail/:id', async function (req, res) {
    req.session.retUrl = req.originalUrl;
    const pro_id = req.params.id || 0;
    const product = await productModel.findByProID(pro_id);

    if (product.ProState.readInt8() === 1) {
        product.Onair = true;
    }

    let allowBid = true;

    if (req.session.auth === true) {
        if (product.CurrentWinner === req.session.authUser.Email) {
            allowBid = false;
        }
    }

    console.log(product.Onair);

    let user = null;
    let inWish = false;

    let bidding = await productModel.findBidding(pro_id);

    for (let i = 0; i < bidding.length; i++) {
        const tempUser = await userModel.findByEmail(bidding[i].Bidder);
        bidding[i].Name = tempUser.Name;
    }

    let biddingHighest = null;

    let suggestPrice = +product.StartPrice + +product.StepPrice;
    console.log(suggestPrice);

    if (bidding.length > 0) {
        // biddingHighest = bidding[0];
        suggestPrice = +bidding[0].Price + +product.StepPrice;
        biddingHighest = bidding.shift();
    }

    if (res.locals.auth != false) {
        user = req.session.authUser.Email;
        const isWish = await productModel.isInWishList(pro_id, user);

        if (isWish.length > 0) {
            inWish = true;
        }
    }

    if (product === undefined) {
        return res.redirect('/');
    }

    const description = await productModel.findDescriptionProduct(pro_id);

    const related_products = await productModel.findByCatID(product.CatID, product.ProID);

    let seller = await userModel.findByEmail(product.Seller);

    res.render('product', {
        product,
        suggestPrice,
        allowBid,
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

    if (type == 0)
        checkType = false;
    else checkType = true;

    const limit = 8;
    const raw = await productModel.countBigCatId(bigCatId);
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
    const list = await productModel.findPageByBigCatId(bigCatId, limit, offset, type);

    console.log(list);

    let isFirst = 1;
    let isLast = 1;

    for (let i in list) {
        list[i].noBid = false;
        list[i].user = req.session.authUser;
        const countBidding = await productModel.countBidding(list[i].ProID);
        list[i].countBidding = countBidding[0].count;
        if (list[i].Price==null) {
            list[i].noBid = true;
        } else {
            let bidRet = await productModel.findBidDetails(list[i].ProID);
            list[i].biddingHighest = bidRet[0];
        }

        if (req.session.auth != false) {
            let inWish = await productModel.isInWishList(list[i].ProID, req.session.authUser.Email);
            if (inWish.length > 0) {
                list[i].isWish = true;
            }
        }
    }

    if (list.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
    }

    const href = "byBigCat"

    res.render('vwProduct/byCat', {
        products: list,
        empty: list.length === 0,
        page_numbers,
        isFirst,
        isLast,
        catName: list[0].BigCatName,
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

    if (type == 0)
        checkType = false;
    else checkType = true;

    const limit = 8;
    const raw = await productModel.countCatID(CatID);
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
    const list = await productModel.findPageByCatID(CatID, limit, offset, type);
    console.log(list);

    let isFirst = 1;
    let isLast = 1;

    for (let i in list) {
        list[i].noBid = false;
        list[i].user = req.session.authUser;
        const countBidding = await productModel.countBidding(list[i].ProID);
        list[i].countBidding = countBidding[0].count;
        if (list[i].Price==null) {
            list[i].noBid = true;
        } else {
            let bidRet = await productModel.findBidDetails(list[i].ProID);
            list[i].biddingHighest = bidRet[0];
        }

        if (req.session.auth != false) {
            let inWish = await productModel.isInWishList(list[i].ProID, req.session.authUser.Email);
            if (inWish.length > 0) {
                list[i].isWish = true;
            }
        }
    }

    if (list.length != 0) {
        isFirst = page_numbers[0].isCurrent;
        isLast = page_numbers[nPage - 1].isCurrent;
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
        catName: list[0].CatName,
        href,
        checkType
    });
});

export default router;