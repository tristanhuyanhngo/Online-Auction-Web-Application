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

    //Người mua bị từ chối ra giá
    sendBidRestrict(receiver, proName) {
        const otpStr = 'We are sorry that your bid for product ' + proName + ' on Horizon has been restricted and canceled by seller!\n'
            +'Please try with another product.';
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: receiver,
            subject: 'Bid for '+proName+' has been restricted!',
            text: otpStr
        };

        sender.sendMail(mailOptions);
    },

    //Dau gia ket thuc
    sendBidEndSuccess(winner, winnerName,seller, proName,price) {
        const maillist = [
            winner,
            seller
        ];
        const otpStr = 'The bidding for ' + proName + ' on Horizon is over!\n'
            +'The success bidder is '+winnerName+'!\n'+'Final price: '+price+'VND\n'
        +'In case the payment is not complete, the success bidder have to finish it within 3 days from now!';
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: maillist,
            subject: 'Bid for '+proName+' finished!',
            text: otpStr
        };

        sender.sendMail(mailOptions);
    },

    //Dau gia ket thuc, ko co nguoi mua
    sendBidEnd(seller, proName) {
        const otpStr = 'The bidding time for ' + proName + ' on Horizon is over!\n'
            +'We are sorry that no bid is placed for your product!\n'
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: seller,
            subject: 'Bid for '+proName+' finished!',
            text: otpStr
        };

        sender.sendMail(mailOptions);
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

    sendBidDefeatEnd(receiver, proName) {
        const otpStr = 'There is some one who bought ' + proName + ' with the BUY NOW price!\n' +
            'The bid for '+proName+' is over!';
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: receiver,
            subject: 'Bid for '+proName+' is over',
            text: otpStr
        };

        sender.sendMail(mailOptions);
    },

    sendSuccessBid(bidder, bidderName, seller, proName, price) {
        const maillist = [
            bidder,
            seller
        ];
        const curPrice = new Intl.NumberFormat().format(price);
        const otpStr = bidderName+' has successfully placed bid for product ' + proName + ' on Horizon! \n' +
            'Current price: '+curPrice+'VND';
        const mailOptions = {
            from: "Horizon <horizon@gmail.com>",
            to: maillist,
            subject: proName+' has one new success bidding!',
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


