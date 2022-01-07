import express from 'express';
import bodyParser from "body-parser";
import * as fs from 'fs';
import fsExtra from 'fs-extra';
import multer from 'multer';
import moment from 'moment';

import sellerModel from '../models/seller.model.js';

const router = express.Router();
const urlencodedParser = bodyParser.urlencoded({ extended: false })

let ID = await sellerModel.findIDProduct();
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

// Validate number of pictures
async function validUploadLength (req, res, next) {
    if (req.files.length < 3) {
        for (let i = 1; i <= numberOfImage; i++) {
            let filePath = dir + `/${i}.jpg`;
            fs.unlinkSync(filePath);
        }
        numberOfImage = 0;
        res.render('seller/post-product',{
            pActive,
            layout: 'seller.handlebars',
            errorOfImages: true
        });
    }

    ID = await sellerModel.findIDProduct();
    dir_temp = './public/images/Product/' + await (ID+2).toString();

    if (!fs.existsSync(dir_temp)){
        fs.mkdirSync(dir_temp);
    };

    next()
}

router.post('/',urlencodedParser, [upload.array('img', 10),validUploadLength], async(req, res) => {
    let pActive = true;

    // Product
    ID = await sellerModel.findIDProduct();
    const cat_id = await sellerModel.findCatID(req.body.child_category);
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

    await sellerModel.addProduct(product);
    await sellerModel.addDescription(description);

    dir = dir_temp;
    numberOfImage = 0;
});

router.get('/additional', async (req, res) => {
    let aActive = true;

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

    res.render('seller/additional',{
        aActive,
        layout: 'seller.handlebars'
    });
});

router.get('/selling', async (req, res) => {
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

    res.render('seller/selling',{
        vActive,
        layout: 'seller.handlebars'
    });
});
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

    res.render('seller/sold',{
        vActive,
        layout: 'seller.handlebars'
    });
});


export default router;