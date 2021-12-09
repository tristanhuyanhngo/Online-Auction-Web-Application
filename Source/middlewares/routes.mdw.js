import indexRoute from '../routes/index.route.js'
import productRoute from '../routes/product.route.js'
import bidderRoute from '../routes/bidder.route.js'
import adminRoute from '../routes/admin.route.js'

export default function (app) {
    app.use('/', indexRoute);
    app.use('/home', indexRoute);
    app.use('/product', productRoute);
    app.use('/bidder',bidderRoute);
    app.use('/admin',adminRoute);
}
