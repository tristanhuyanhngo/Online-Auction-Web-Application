import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    // Get information of user from session
    const user = req.session.authUser || 0;
    if (!user) {
        console.log("Please login first ! ");
        res.redirect('/');
        return;
    }
    res.render('profile');
});

export default router;