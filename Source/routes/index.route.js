import express from 'express';
import productHome from "../models/home.model.js";
import productSearch from "../models/search.model.js";

const router = express.Router();

router.get('/', async function (req, res) {
    const list = await productHome.sortByPrice();
    res.render('home', {
        products: list[0]
    });
});

router.get('/register', (req, res) => {
    res.render('register');
});

router.get('/login', (req, res) => {
    res.render('login');
});

router.get('/search', async function (req, res) {
    const list = await productSearch.findAll();
    console.log(list[0][1]);
    res.render('search', {
        products: list[0],
        is
    });
});

export default router;