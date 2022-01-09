import express from 'express';
import productModel from '../models/product.model.js';
import bidModel from "../models/bid.model.js";
import userModel from "../models/user.model.js";
import emailModel from "../models/email.models.js";
import moment from "moment";
import bodyParser from "body-parser";
import cron from 'node-cron';
import cartModel from "../models/cart.model.js";
import adminModel from "../models/admin.model.js";

const router = express.Router();
router.use(bodyParser.urlencoded({extended: false}))

function checkTimeOut(time) {
    const now = new Date().getTime();
    const then = new Date(time).getTime();
    const gap = then - now;

    const second = 1000;
    const minute = second * 60;
    const hour = minute * 60;
    const day = hour * 24;

    let textDay = Math.floor(gap / day);
    let textHour = Math.floor((gap % day) / hour);
    let textMinute = Math.floor((gap % hour) / minute);
    let textSecond = Math.floor((gap % minute) / second);

    if (textDay < 0) {
        textDay = 0;
    }
    if (textHour < 0) {
        textHour = 0;
    }
    if (textMinute < 0) {
        textMinute = 0;
    }
    if (textSecond < 0) {
        textSecond = 0;
    }

    if (textDay === 0 && textHour === 0 && textMinute === 0 && textSecond === 0) {
        return true;
    }

    return false;
}

// * * * Check time out after 1 minutes then send mail
cron.schedule("0 */1 * * * *", async function() {
    const listProduct = await productModel.getProductNotSoldForMailing();

    for (let i = 0; i < listProduct.length; i++) {
        if (checkTimeOut(listProduct[i].EndDate)) {

            await productModel.updateProState(listProduct[i].ProID);
            let endDate = moment(listProduct[i].EndDate).format('dddd, MMMM Do YYYY - h:mm a');

            if (listProduct[i].CurrentWinner != null) {
                emailModel.sendSellerEndBidWithWinner(listProduct[i].Seller, listProduct[i].ProName, listProduct[i].ProID, endDate, listProduct[i].CurrentWinner, listProduct[i].Price);
                emailModel.sendWinnerBid(listProduct[i].CurrentWinner, listProduct[i].ProName, listProduct[i].Price);
            }
            else {
                emailModel.sendSellerEndBidWithoutWinner(listProduct[i].Seller, listProduct[i].ProName, listProduct[i].ProID, endDate);
            }
        }
    }
});

router.get('/check-bid', async function (req, res) {
    const queryPrice = +req.query.price;
    const proID = req.query.pro;

    let product = await productModel.findByProID(proID);
    let maxPrice = product.MaxPrice;

    console.log(queryPrice);
    console.log(maxPrice);


    if (product.CurrentWinner === null) {
        return res.json(true);
    }

    if (queryPrice <= maxPrice) {
        return res.json(false);
    } else {
        return res.json(true);
    }
});

router.post('/buynow', async function (req, res) {
    const email = req.session.authUser.Email;
    const ProID = req.body.ProID;
    const today = moment().format();
    const bidder = await userModel.findByEmail(email);
    const  product = await productModel.findByProID(ProID);
    const Price = product.SellPrice;
    const currentWinner = req.body.CurrentWinner || null;

    let item = {
        ProID: ProID,
        Bidder: email,
        OrderDate: today
    }

    // console.log("Current",currentWinner);
    if(currentWinner != null){
        if(currentWinner!==email){
            // console.log("Current",currentWinner);
            await emailModel.sendBidDefeatEnd(currentWinner,product.ProName);
        }
    }
    await emailModel.sendBidEndSuccess(email,bidder.Name,product.Seller,product.ProName,Price);
    await cartModel.checkout(item);

    const ret = '/product/detail/'+ProID;
    const url = req.headers.referer || ret;
    return res.redirect(url);
});

router.post('/detail/:id', async function (req, res) {
    const queryPrice = +req.body.queryPrice;
    const ProID = req.params.id;
    const email = req.session.authUser.Email;
    const bidder = await userModel.findByEmail(email);
    const bidderName = bidder.Name;

    let product = await productModel.findByProID(ProID);
    const seller = product.Seller;
    console.log(product)
    let maxPrice = product.MaxPrice;
    let step = product.StepPrice;
    let start = product.StartPrice;

    const url = '/product/detail/' + ProID;

    if (product.CurrentWinner === null) {
        const bid = {
            ProID: ProID,
            Bidder: email,
            Time: moment().format(),
            Price: +start+ +step,
            MaxPrice: queryPrice
        }
        await bidModel.addBidding(bid);

        let productEntity = {
            ProID: ProID,
            CurrentWinner: email
        }

        if(product.AutoExtend.readInt8()===1){
            const now = moment();
            const endDate = moment(product.EndDate);
            const gap = now.diff(endDate, 'seconds');
            if (gap <= 300) {
                productEntity = {
                    ProID: ProID,
                    CurrentWinner: email,
                    EndDate: endDate.add(10,'minutes').format()
                }
            }
        }

        await productModel.updateProduct(productEntity);
        emailModel.sendSuccessBid(email, bidderName, seller, product.ProName, queryPrice);

        return res.redirect(url);
    }

    if (queryPrice <= maxPrice) {
        const bid = {
            ProID: ProID,
            Bidder: product.CurrentWinner,
            Time: moment().format(),
            Price: queryPrice,
            MaxPrice: product.MaxPrice
        }
        console.log(bid)
        await bidModel.addBidding(bid);
        return res.redirect(url);
    } else {
        const newPrice = maxPrice + step;

        emailModel.sendSuccessBid(email, bidderName, seller, product.ProName, newPrice);
        emailModel.sendBidDefeat(product.CurrentWinner, product.ProName);

        const bid = {
            ProID: ProID,
            Bidder: email,
            Time: moment().format(),
            Price: newPrice,
            MaxPrice: queryPrice
        }
        const ret = await bidModel.addBidding(bid);
        //console.log(ret);

        let productEntity = {
            ProID: ProID,
            CurrentWinner: email
        }

        if(product.AutoExtend.readInt8()===1){
            const now = moment();
            const endDate = moment(product.EndDate);
            const gap = now.diff(endDate, 'seconds');
            if (gap <= 300) { //equal 5 minutes
                productEntity = {
                    ProID: ProID,
                    CurrentWinner: email,
                    EndDate: endDate.add(10,'minutes').format()
                }
            }
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
    let isRestrict = false;
    if (req.session.auth === true) {
        if (product.CurrentWinner === req.session.authUser.Email) {
            allowBid = false;
        }
        const checkRestrict = await productModel.findRestrict(product.ProID,req.session.authUser.Email)

        console.log("Restrict?",checkRestrict);
        if(checkRestrict!=null){
            isRestrict = true;
        }
    }

    let user = null;
    let inWish = false;

    let bidding = await productModel.findBidding(pro_id);

    for (let i = 0; i < bidding.length; i++) {
        const tempUser = await userModel.findByEmail(bidding[i].Bidder);
        bidding[i].Name = tempUser.Name;
    }

    let biddingHighest = null;

    let suggestPrice = +product.StartPrice + +product.StepPrice;
    //console.log(suggestPrice);

    if (bidding.length > 0) {
        suggestPrice = +bidding[0].Price + +product.StepPrice;
        biddingHighest = bidding[0];
    }

    if (res.locals.auth !== false) {
        user = req.session.authUser.Email;
        const isWish = await productModel.isInWishList(pro_id, user);

        if (isWish.length > 0) {
            inWish = true;
        }

        product.allowUser = true;

        if (product.AllowAllUsers.readInt8() === 0) {
            const rate = req.session.authUser.Rate;
            if (rate < 80) {
                product.allowUser = false;
            }
        }
    }

    if (product === undefined) {
        return res.redirect('/');
    }

    const listDes = await productModel.findDescriptionProduct(pro_id);
    let description = "";
    for (let i = 0; i < listDes.length; i++) {
        description += listDes[i].Content;
        if (i !== listDes.length - 1) {
            description += '\n';
            description += "<br>";
        }
    }

    const related_products = await productModel.findByCatID(product.CatID, product.ProID);

    let seller = await userModel.findByEmail(product.Seller);

    res.render('product', {
        product,
        suggestPrice,
        allowBid,
        inWish,
        related_products,
        description,
        seller,
        bidding,
        biddingHighest,
        isRestrict
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

    //console.log(list);

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
            let bidRet = await productModel.findBidDetails(list[i].ProID);
            list[i].biddingHighest = bidRet[0];
        }

        if (req.session.auth !== false) {
            let inWish = await productModel.isInWishList(list[i].ProID, req.session.authUser.Email);
            if (inWish.length > 0) {
                list[i].isWish = true;
            }
        }
    }

    if (list.length !== 0) {
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

    if (type === 0)
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
    //console.log(list);

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

    if (list.length !== 0) {
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