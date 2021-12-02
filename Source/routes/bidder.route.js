import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    res.render('bidder/edit_info',{
        layout: 'account.handlebars'
    });
});

router.get('/general', (req, res) => {
    res.render('bidder/edit_info',{
        layout: 'account.handlebars'
    });
});

router.get('/password', (req, res) => {
    res.render('bidder/change_password',{
        layout: 'account.handlebars'
    });
});

router.get('/wishlist', (req, res) => {
    res.render('bidder/wishlist',{
        layout: 'account.handlebars'
    });
});

router.get('/cart', (req, res) => {
    res.render('bidder/cart',{
        layout: 'account.handlebars'
    });
});

router.get('/won-bid', (req, res) => {
    res.render('bidder/won-bid',{
        layout: 'account.handlebars'
    });
});

// router.get('/register', (req, res) => {
//     res.render('register');
// });
//
// router.get('/login', (req, res) => {
//     res.render('login');
// });

export default router;