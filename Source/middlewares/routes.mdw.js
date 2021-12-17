import indexRoute from '../routes/index.route.js'
import productRoute from '../routes/product.route.js'
import bidderRoute from '../routes/bidder.route.js'
import adminRoute from '../routes/admin.route.js'
import accountRoute from '../routes/account.route.js'
import sellerRoute from '../routes/seller.route.js'
import express from "express";

export default function (app) {
    app.use('/', indexRoute);
    app.use('/home', indexRoute);
    app.use('/product', productRoute);
    app.use('/profile', accountRoute);
    app.use('/bidder', bidderRoute);
    app.use('/admin', adminRoute);
    app.use('/seller',sellerRoute)
    app.use('/public',express.static('public'));
}
