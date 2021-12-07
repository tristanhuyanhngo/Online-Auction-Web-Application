import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    let gActive = true;
    res.render('admin/viewuser',{
        gActive,
        layout: 'admin.handlebars'
    });
});

router.get('/viewuser', (req, res) => {
    let gActive = true;
    res.render('admin/viewuser',{
        gActive,
        layout: 'admin.handlebars'
    });
});

export default router;