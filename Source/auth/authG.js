import passport from 'passport'
import GoogleStrategy from 'passport-google-oauth20'
import userModel from "../models/user.model.js";

const GOOGLE_CLIENT_ID = "365323515645-uthhj6n00feiukd3ds83dck4rnefh0h4.apps.googleusercontent.com";
const GOOGLE_CLIENT_SECRET = "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";

const ggStrategy = GoogleStrategy.Strategy;

passport.use(new ggStrategy({
        clientID: GOOGLE_CLIENT_ID,
        clientSecret: GOOGLE_CLIENT_SECRET,
        callbackURL: "http://localhost:3000/auth/google/callback",
        passReqToCallback: true,
    },
    async function (request, accessToken, refreshToken, profile, done) {
        const email = profile.emails[0].value
        const user = await userModel.findByEmail(email);

        return done(null, profile);
    }));

passport.serializeUser(function(user, done) {
    done(null, user);
});

passport.deserializeUser(function(user, done) {
    done(null, user);
});