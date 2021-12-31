import express from 'express';
import bodyParser from "body-parser";
import multer from 'multer';

const router = express.Router();
const urlencodedParser = bodyParser.urlencoded({ extended: false })
const upload = multer({ dest: 'uploads/' });

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

router.post('/',urlencodedParser, upload.single('img'), async(req, res) => {
    let pActive = true;
    console.log(req.body);
    console.log(req.file);
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