export default function auth(req, res, next) {
    req.session.retUrl = req.originalUrl;

    if (req.session.auth === false) {
        req.session.retUrl = req.originalUrl;
        return res.redirect('/login');
    } else{
        let type = req.session.authUser.Type;
        let reqTime = req.session.authUser.RequestTime;
        req.session.requested=true;
        if(type=='2' && reqTime==null){
            req.session.bidder = true;
            req.session.requested=false;
        }
        res.locals.bidder = req.session.bidder;
        res.locals.requested = req.session.requested;
    }
    next();
}