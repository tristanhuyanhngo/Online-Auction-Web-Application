import session from 'express-session';

export default function (app) {
    app.set('trust proxy', 1) // trust first proxy
    app.use(session({
        secret: 'SHH_SHIZUKANINATTE',
        resave: false,
        saveUninitialized: true,
        cookie: {
            // secure: true
        }
    }))
}
