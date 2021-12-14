import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
    let cActive = true;
    res.render('admin/category',{
        cActive,
        layout: 'admin.handlebars'
    });
});

router.get('/category', (req, res) => {
    let cActive = true;
    res.render('admin/category',{
        cActive,
        layout: 'admin.handlebars'
    });
});

router.get('/product', (req, res) => {
    let pActive = true;
    res.render('admin/product',{
        pActive,
        layout: 'admin.handlebars'
    });
});

router.get('/account', (req, res) => {
    let aActive = true;
    res.render('admin/account',{
        aActive,
        layout: 'admin.handlebars'
    });
});

router.get('/account-request', (req, res) => {
    let aActive = true;
    res.render('admin/accountRequest',{
        aActive,
        layout: 'admin.handlebars'
    });
});

// router.get('/viewuser', (req, res) => {
//     let gActive = true;
//     res.render('admin/viewuser',{
//         gActive,
//         layout: 'admin.handlebars'
//     });
// });

// router.get('/viewrequest', (req, res) => {
//     let gActive = true;
//     res.render('admin/viewrequest',{
//         gActive,
//         layout: 'admin.handlebars'
//     });
// });
export default router;