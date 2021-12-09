import indexRoute from '../routes/index.route.js'
import productRoute from '../routes/product.route.js'
import bidderRoute from '../routes/bidder.route.js'
import adminRoute from '../routes/admin.route.js'
import homeRoute from '../routes/home.route.js'

export default function (app) {
    app.use('/', indexRoute);
    app.use('/home', homeRoute);
    app.use('/product', productRoute);
    app.use('/bidder',bidderRoute);
    app.use('/admin',adminRoute);
}
