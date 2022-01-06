import sender from "../utils/email.js";
import bcrypt from "bcryptjs";

export default {
    sendOTP(receiver) {
        const otp = Math.floor(100000 + Math.random() * 900000);
        const otpStr = 'This is your OTP. Please do not share it with anyone.\n' + otp;
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: receiver,
            subject: 'Reset password',
            text: otpStr
        };

        sender.sendMail(mailOptions);
        return otp;
    },

    sendOTPRegister(receiver) {
        const otp = Math.floor(100000 + Math.random() * 900000);
        const otpStr = 'This is your OTP. Please do not share it with anyone.\n' + otp;
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: receiver,
            subject: 'Account verification',
            text: otpStr
        };

        sender.sendMail(mailOptions);
        return otp;
    },

    sendBidDefeat(receiver, proName) {
        const otpStr = 'Your bid for product ' + proName + ' on Horizon has been won over by another bidder!\n' +
            'Let\'s comeback and place another bid!';
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: receiver,
            subject: 'Bid has been won over by another bidder!',
            text: otpStr
        };

        sender.sendMail(mailOptions);
    },

    sendNewPassword(receiver) {
        let chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        let passwordLength = 8;
        let password = "";

        for (let i = 0; i <= passwordLength; i++) {
            let randomNumber = Math.floor(Math.random() * chars.length);
            password += chars.substring(randomNumber, randomNumber + 1);
        }

        const passStr = 'This is your new password: ' + password +
            '\nPlease do not share it with anyone. \nYour password has been encrypted so that only you know it. You can change it later in settings';
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: receiver,
            subject: 'New password',
            text: passStr
        };

        sender.sendMail(mailOptions);

        const salt = bcrypt.genSaltSync(10);
        const hash = bcrypt.hashSync(password, salt);
        return hash;
    }
}


