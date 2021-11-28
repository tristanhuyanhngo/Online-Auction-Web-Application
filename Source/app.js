import express from 'express';
import { engine, create } from 'express-handlebars';
import indexRoute from './routes/index.js'
import productRoute from './routes/product.js'
import path from 'path'
import { dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));


const app = express();
const hbs = create({
    helpers: {
        times(n, block) {
            var accum = '';
            for (var i = 0; i < n; ++i)
                accum += block.fn(i);
            return accum;
        }
    }
});

app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.use(express.static(path.join(__dirname, 'public')))


app.use('/', indexRoute)
app.use('/product', productRoute)

app.listen(3000);
