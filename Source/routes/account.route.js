import express from 'express';
import bodyParser from 'body-parser';
import bcrypt from 'bcryptjs'
import moment from 'moment';
import userModel from '../models/user.model.js'

const router = express.Router();

const urlencodedParser = bodyParser.urlencoded({ extended: false })

// ---------------- REGISTER ---------------- //
router.get('/register', async function(req, res) {
    res.render('./vwAccount/register');
});

router.post('/register',urlencodedParser,async function(req, res) {
    const rawPassword = req.body.password;
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(rawPassword, salt);
    // const today = moment().tzformat('YYYY-MM-DD');
    const today = moment().format();

    const user = {
        Email: req.body.email,
        Username: req.body.username,
        Password: hash,
        Name: req.body.fullName,
        Address: null,
        DOB: null,
        RegisterDate: today,
        Type: 2,
        Rate: 0
    }

    await userModel.addUser(user);
    res.render('./vwAccount/register');
});

router.get('/is-available', async function (req, res) {
    const email = req.query.user;
    const user = await userModel.findByEmail(email);

    if (user === null) {
        return res.json(true);
    }
    else {
        return res.json(false);
    }
});

// ---------------- LOGIN ---------------- //
router.get('/login', async function (req, res) {
    res.render('./vwAccount/login');
});

router.post('/login',urlencodedParser, async function (req, res) {
    const email = req.body.email;
    const rawPassword = req.body.password;
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(rawPassword, salt);

    const user = await userModel.validateAccount(email,hash);
    res.render('./vwAccount/login');
});

// ---------------- PROFILE ---------------- //
router.get('/profile', async function (req, res) {
    res.render('./vwAccount/profile');
});

export default router;