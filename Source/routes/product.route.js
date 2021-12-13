import express from 'express';
import productModel from '../models/product.model.js';

const router = express.Router();

router.get('/', (req, res) => {
    res.render('product');
});

router.get('/byCat/:id', async function (req, res) {
    const bigCatId = req.params.id||0;
    const page = req.query.page || 1;

    const limit =8;
    const raw = await productModel.countBigCatId(bigCatId);
    const total = raw[0][0].amount;

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

    console.log(page_numbers)

    const offset = (page-1)*limit;
    const list = await productModel.findPageByBigCatId(bigCatId,limit,offset);
    res.render('vwProduct/byCat', {
        products: list[0],
        empty: list.length === 0,
        page_numbers,
        isFirst: page_numbers[0].isCurrent,
        isLast: page_numbers[nPage-1].isCurrent
    });
});

export default router;