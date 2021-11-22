var express = require('express');
const handlebars = require('express-handlebars').create({ defaultLayout: 'main' })
const path = require('path');

var app = express();

app.engine('handlebars', handlebars.engine)
app.set('view engine', 'handlebars')
app.use(express.static(path.join(__dirname, 'public')))


app.get('/', function (req, res) {
    res.render('home');
});

app.listen(3000);
