import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    let pActive = true;
    res.render('seller/post-product',{
        pActive,
        layout: 'seller.handlebars'
    });
});

router.get('/post', (req, res) => {
    let pActive = true;
    res.render('seller/post-product',{
        pActive,
        layout: 'seller.handlebars'
    });
});

router.get('/additional', (req, res) => {
    let aActive = true;
    res.render('seller/additional',{
        aActive,
        layout: 'seller.handlebars'
    });
});

router.get('/selling', (req, res) => {
    let vActive = true;
    res.render('seller/selling',{
        vActive,
        layout: 'seller.handlebars'
    });
});
router.get('/sold', (req, res) => {
    let vActive = true;
    res.render('seller/sold',{
        vActive,
        layout: 'seller.handlebars'
    });
});


export default router;