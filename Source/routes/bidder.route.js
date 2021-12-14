import express from 'express';
import bidderModel from '../models/bidder.model.js';

const router = express.Router();

router.get('/', (req, res) => {
    let gActive = true;
    res.render('bidder/edit-info',{
        gActive,
        layout: 'account.handlebars'
    });
});

// router.get('/general/edit-name', async (req, res) => {
//     let gActive = true;
//
//     const username = req.query.username || 0;
//     const user = await bidderModel.findByUsername(username);
//
//     if (user === null) {
//         alert("No user found!");
//     }
//
//     console.log("Category: ", category);
//
//     res.render('vwCategory/edit', {
//         category: category
//     });
//
//     res.render('bidder/edit-name', {
//         gActive,
//         layout: 'account.handlebars'
//     });
// });

router.get('/general', (req, res) => {
    let gActive = true;
    res.render('bidder/edit-info',{
        gActive,
        layout: 'account.handlebars'
    });
});

router.get('/password', (req, res) => {
    let pActive = true;
    res.render('bidder/change-password',{
        pActive,
        layout: 'account.handlebars'
    });
});

router.get('/wishlist', (req, res) => {
    let wActive = true;
    res.render('bidder/wishlist',{
        wActive,
        layout: 'account.handlebars'
    });
});

router.get('/cart', (req, res) => {
    let cActive = true;
    res.render('bidder/cart',{
        cActive,
        layout: 'account.handlebars'
    });
});

router.get('/won-bid', (req, res) => {
    let wbActive = true;
    res.render('bidder/won-bid',{
        wbActive,
        layout: 'account.handlebars'
    });
});

//
// router.get('/feedback', (req, res) => {
//     let fActive = true;
//     res.render('bidder/feedback',{
//         fActive,
//         layout: 'account.handlebars'
//     });
// });

// router.get('/register', (req, res) => {
//     res.render('register');
// });
//
// router.get('/login', (req, res) => {
//     res.render('login');
// });

export default router;