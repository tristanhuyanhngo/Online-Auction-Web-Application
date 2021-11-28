import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    res.render('bidder/account');
});


// router.get('/register', (req, res) => {
//     res.render('register');
// });
//
// router.get('/login', (req, res) => {
//     res.render('login');
// });

export default router;