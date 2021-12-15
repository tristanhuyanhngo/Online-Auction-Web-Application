import { engine, create } from 'express-handlebars';
import numeral from 'numeral';
import moment from 'moment';
import handlebars_sections from "express-handlebars-sections";

export default function (app) {
    app.engine('handlebars', engine({
        defaultLayout: 'main.handlebars',
        helpers: {
            format_number(val) {
                return numeral(val).format('0,0');
            },
            format_date(val) {
                return moment(val).format('YYYY-MM-DD, h:mm');
            },
            section: handlebars_sections()
        }
    }));
    app.set('view engine', 'handlebars');
    app.set('views', './views');
}
