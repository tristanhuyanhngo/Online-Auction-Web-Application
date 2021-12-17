import express from 'express';

const router = express.Router();


// ---------------- PROFILE ---------------- //
router.get('/profile', async function (req, res) {
    res.render('./vwAccount/profile');
});

export default router;