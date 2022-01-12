const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

import userService from '../auth/userService.js';

passport.use(new LocalStrategy(
    async function(email, password, done) {
        const user = await userService.findByEmail(email);
        if (!user) {
            return done(null, false, {message: "Incorrect username or password !"});
        }
        if (!userService.validPassword(user, password)) {
            return done(null, false, {message: "Incorrect username or password !"});
        }
        return done(null, user);
    }
));

passport.serializeUser(function(user, done) {
    done(null, user.email);
});

passport.deserializeUser(function(email, done) {
    userService.findByEmail(email, function(err, user) {
        done(err, user);
    });
});

module.exports = passport;