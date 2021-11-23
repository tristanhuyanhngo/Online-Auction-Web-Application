import express from 'express';
import { engine } from 'express-handlebars';
import indexRoute from './routes/index.js'
import path from 'path'
import { dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));


const app = express();

app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.use(express.static(path.join(__dirname, 'public')))


app.use('/', indexRoute)

app.listen(3000);
