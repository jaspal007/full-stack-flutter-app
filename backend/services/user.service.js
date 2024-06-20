const userModel = require('../model/user.model')
const jwt = require('jsonwebtoken')

class userService{
    static async registerUser(email, password){
        try {
            const createUser = new userModel({email, password})
            return await createUser.save()
        } catch (err) {
            throw err
        }
    }
    static async checkUser(email){
        try {
            return await userModel.findOne({email});
        } catch (error) {
            throw err
        }
    }
    static generateToken(userToken, secretKey, jwt_expires){
        return jwt.sign(userToken, secretKey, {expiresIn: jwt_expires});
    }
    static async logOutUser(email, req){
        try {
            await userModel.findOneAndUpdate({email}, req.body);
        } catch (error) {
            throw err
        }
    }
};

module.exports = userService;