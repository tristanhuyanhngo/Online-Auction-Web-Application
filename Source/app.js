import express from 'express';
// import asyncErrors from 'express-async-errors';

import { dirname } from 'path';
import path from 'path';
import { fileURLToPath } from 'url';
const __dirname = dirname(fileURLToPath(import.meta.url));
import activate_locals_middleware from './middlewares/locals.mdw.js';
import activate_view_middleware from './middlewares/view.mdw.js';
import activate_route_middleware from './middlewares/routes.mdw.js';
import adminRoute from './routes/admin.route.js'
import sellerRoute from './routes/seller.route.js'

const app = express();

app.use(express.static('res')); 
app.use(express.static(path.join(__dirname, 'public')))
app.use('/public', express.static('public'));

activate_view_middleware(app);
activate_locals_middleware(app);
activate_route_middleware(app);

app.use('/admin',adminRoute)
app.use('/seller',sellerRoute)

const port = 3000;
app.listen(port, function () {
    console.log(`Example app listening at http://localhost:${port}`);
});
