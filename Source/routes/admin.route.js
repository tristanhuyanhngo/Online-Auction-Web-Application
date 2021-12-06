import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    let gActive = true;
    res.render('admin/edit-info',{
        gActive,
        layout: 'admin.handlebars'
    });
});


export default router;