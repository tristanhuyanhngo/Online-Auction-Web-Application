import moment from "moment";
import adminModel from '../models/admin.model.js';

export default async function auth(req, res, next) {
    req.session.retUrl = req.originalUrl;

    if (req.session.auth === false) {
        req.session.retUrl = req.originalUrl;
        return res.redirect('/login');
    } else {
        let type = req.session.authUser.Type;
        console.log(type);
        let reqTime = req.session.authUser.RequestTime;
        req.session.requested = true;
        if (type === '2' && reqTime == null) {
            req.session.bidder = true;
            req.session.requested = false;
        } else{
            req.session.bidder = false;
        }
        console.log(req.session.bidder);
        const accTime = moment(req.session.authUser.AcceptTime);
        if (accTime != null) {
            const now = moment();
            const gap = now.diff(accTime, 'seconds');
            if (gap >= 604800) { //equals 7 days 604800
                const email = req.session.authUser.Email;
                const ret = await adminModel.setBackBidder(email);
                req.session.authUser=ret[0];
                res.locals.authUser = req.session.authUser;
            }
        }
        res.locals.bidder = req.session.bidder;
        res.locals.requested = req.session.requested;
    }
    next();
}