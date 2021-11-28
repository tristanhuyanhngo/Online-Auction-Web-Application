import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    res.render('bidder/edit_info',{
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