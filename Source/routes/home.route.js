import express from 'express';
import productModel from '../models/home.model.js';

const router = express.Router();

router.get('/', async function (req, res) {
    const list = await productModel.sortByPrice();
    res.render('/')
});