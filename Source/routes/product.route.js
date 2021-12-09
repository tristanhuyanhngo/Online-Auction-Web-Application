import express from 'express';
import productModel from '../models/home.model.js';

const router = express.Router();

router.get('/', (req, res) => {
    res.render('product');
});

export default router;