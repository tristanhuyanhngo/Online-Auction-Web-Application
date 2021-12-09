import express from 'express';
import productModel from "../models/home.model.js";

const router = express.Router();

router.get('/', async function (req, res) {
    const list = await productModel.sortByPrice();
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

router.get('/search', (req, res) => {
    res.render('search');
});


export default router;