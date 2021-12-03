import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    res.render('home');
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

router.get('/test', (req, res) => {
    res.render('test');
});

export default router;