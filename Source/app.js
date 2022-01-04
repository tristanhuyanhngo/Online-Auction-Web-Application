import express from 'express';

import { dirname } from 'path';
import path from 'path';
import { fileURLToPath } from 'url';
const __dirname = dirname(fileURLToPath(import.meta.url));
import activate_locals_middleware from './middlewares/locals.mdw.js';
import activate_view_middleware from './middlewares/view.mdw.js';
import activate_route_middleware from './middlewares/routes.mdw.js';
import activate_session_middleware from './middlewares/session.mdw.js';

const app = express();

app.use(express.static('res')); 
app.use(express.static(path.join(__dirname, 'public')))
app.use('/public', express.static('public'));


activate_session_middleware(app);
activate_view_middleware(app);
activate_locals_middleware(app);
activate_route_middleware(app);

const port = 3000;
app.listen(port, function () {
    console.log(`Example app listening at http://localhost:${port}`);
});

app.use(function (req, res, next) {
    res.render('error/404', {
        layout: false,
    });
});
