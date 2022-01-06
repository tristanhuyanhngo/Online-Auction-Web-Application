import express from 'express';
import bodyParser from "body-parser";
import * as fs from 'fs';
import multer from 'multer';
import sellerModel from '../models/seller.model.js';

const router = express.Router();
const urlencodedParser = bodyParser.urlencoded({ extended: false })

// const ID = await sellerModel.findIDProduct();
// const dir = './public/image/product';
//
// if (!fs.existsSync(dir)){
//     fs.mkdirSync(dir);
// };

let numberOfImage = 0;

const storage = multer.diskStorage({
    destination: function (request, file, callback) {
        let path = "./public/images" ;
        callback(null, path);
    },
    filename: function (request, file, callback) {
        ++numberOfImage
        const name = numberOfImage.toString() + ".jpg"
        callback(null, name);
    }
});

const upload = multer({storage: storage}).array('img', 10);

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

// middleware
function validUploadLength (req, res, next) {
    console.log(req.files.length);
    if (req.files.length < 3 || req.files.length > 10) {
        return res.status(400).json({ error: 'Three files is required'})
    }
    next()
}

router.post('/', async(req, res) => {
    let pActive = true;

    upload(req, res, function (err) {
        if (req.files.length < 3) {
            for (let i = 1; i <= numberOfImage; i++) {
                let filePath = `./public/images/${i}.jpg`;
                fs.unlinkSync(filePath);
            }
        }
        numberOfImage = 0;
        if (req.files.length < 3 || req.files.length > 10) {
            return res.status(400).json({ error: 'Three files is required'})
        }
        if (err instanceof multer.MulterError) {
            console.log(err);
        } else if (err) {
            // An unknown error occurred when uploading.
        }
        // Everything went fine.
    })

    res.render('seller/post-product',{
        pActive,
        layout: 'seller.handlebars'
    });
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