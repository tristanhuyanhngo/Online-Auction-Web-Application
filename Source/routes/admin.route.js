import express from 'express';
import productModel from '../models/product.model.js';
import bodyParser from 'body-parser';
const router = express.Router();

router.use(bodyParser.urlencoded({ extended: false }))
router.get('/', (req, res) => {
    let cActive = true;
    res.render('admin/category',{
        cActive,
        layout: 'admin.handlebars'
    });
});

router.get('/category', (req, res) => {
    let cActive = true;
    res.render('admin/category',{
        cActive,
        layout: 'admin.handlebars'
    });
});

router.post('/product/del',   async (req, res) => {
    const ret = await productModel.del(req.body.ProID);
    console.log(ret);
    return res.redirect('/admin/product');
});

router.get('/product', async (req, res) => {
    let pActive = true;
    const page = req.query.page || 1;
    const limit = 6;

    const total = await productModel.countProduct();

    let nPage = Math.floor(total/limit);
    if(total%limit>0){
        nPage++;
    }

    const page_numbers = [];
    for (let i = 1; i <= nPage; i++) {
        page_numbers.push({
            value: i,
            isCurrent: +page === i
        });
    }

    const offset = (page-1)*limit;

    const product = await productModel.findAllLimit(limit,offset);

    //console.log(product);
    res.render('admin/product', {
        pActive,
        product,
        layout: 'admin.handlebars',
        empty: product.length === 0,
        page_numbers,
        isFirst: page_numbers[0].isCurrent,
        isLast: page_numbers[nPage-1].isCurrent,
    });
});

router.get('/account', (req, res) => {
    let aActive = true;
    res.render('admin/account',{
        aActive,
        layout: 'admin.handlebars'
    });
});

router.get('/account-request', (req, res) => {
    let aActive = true;
    res.render('admin/accountRequest',{
        aActive,
        layout: 'admin.handlebars'
    });
});
export default router;