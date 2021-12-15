import express from 'express';

const router = express.Router();

// ---------------- REGISTER ---------------- //
router.get('/register', async function(req, res) {
    res.render('./vwAccount/register');
});

// ---------------- LOGIN ---------------- //
router.get('/login', async function (req, res) {
    res.render('./vwAccount/login');
});

// ---------------- PROFILE ---------------- //
router.get('/profile', async function (req, res) {
    res.render('./vwAccount/profile');
});

export default router;