import express from 'express';
import productModel from '../models/product.model.js';
import categoryModel from '../models/category.model.js';

const router = express.Router();

router.get('/detail/:id', async function(req, res) {
    const pro_id = req.params.id || 0;
    const product = await productModel.findByProID(pro_id);

    if (product === undefined) {
        return res.redirect('/');
    }

    const description = await productModel.findDescriptionProduct(pro_id);

    const related_products = await productModel.findByCatID(product.CatID, product.ProID);

    res.render('product', {
        product,
        related_products,
        description: description.Content
    });
});

router.get('/byBigCat/:id', async function (req, res) {
    const bigCatId = req.params.id || 0;
    const page = req.query.page || 1;

    const bigCategory_name = await categoryModel.findBigCategoryName(bigCatId)
    const bigCat = bigCategory_name[0].BigCatName;

    const limit = 8;
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

    const offset = (page-1)*limit;
    const list = await productModel.findPageByBigCatId(bigCatId,limit,offset);
    res.render('vwProduct/byCat', {
        products: list[0],
        empty: list.length === 0,
        page_numbers,
        isFirst: page_numbers[0].isCurrent,
        isLast: page_numbers[nPage-1].isCurrent,
        bigCategory: bigCat
    });
});

router.get('/byCat/:id', async function (req, res) {
    const CatID = req.params.id || 0;
    const page = req.query.page || 1;

    const limit = 8;
    const raw = await productModel.countCatID(CatID);
    const total = raw[0][0].amount;
    console.log(total);

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
    const list = await productModel.findPageByCatID(CatID,limit,offset);
    console.log(list);
    res.render('vwProduct/byCat', {
        products: list,
        empty: list.length === 0,
        page_numbers,
        isFirst: page_numbers[0].isCurrent,
        isLast: page_numbers[nPage-1].isCurrent,
    });
});

export default router;