import express from 'express';

const router = express.Router();

router.get('/test', (req, res) => {
    res.render('admin/account',{
        layout: 'admin.handlebars'
    });
});

export default router;