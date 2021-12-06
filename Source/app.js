import express from 'express';
import { engine, create } from 'express-handlebars';
import handlebars_sections from 'express-handlebars-sections';
import numeral from 'numeral';
// import asyncErrors from 'express-async-errors';


import path from 'path'
import { dirname } from 'path';
import { fileURLToPath } from 'url';

import indexRoute from './routes/index.js'
import productRoute from './routes/product.js'
import accountRoute from './routes/bidder.route.js'

const __dirname = dirname(fileURLToPath(import.meta.url));

const app = express();
// const hbs = create({
//     helpers: {
//         times(n, block) {
//             var accum = '';
//             for (var i = 0; i < n; ++i)
//                 accum += block.fn(i);
//             return accum;
//         }
//     }
// });

app.engine('handlebars', engine({
    defaultLayout: 'main.handlebars',
    helpers: {
        format_number(val) {
            return numeral(val).format('0,0');
        },
        section: handlebars_sections()
    }
}));
app.set('view engine', 'handlebars');
app.set('views', './views');

app.use(express.static('res')); 
app.use(express.static(path.join(__dirname, 'public')))

app.use('/', indexRoute)
app.use('/product', productRoute)
app.use('/bidder',accountRoute)


const port = 3000;
app.listen(port, function () {
    console.log(`Example app listening at http://localhost:${port}`);
});
