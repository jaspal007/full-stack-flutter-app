const userModel = require('../model/user.model');
const userService = require('../services/user.service')

exports.registerUser = async(req, res, next)=>{
    try {
        const {email, password} = req.body;
        const successRegister = await userService.registerUser(email, password)

        res.json({status: true, success: 'User registered successfully'})
    } catch (error) {
        throw error;
    }
}

exports.loginUser = async(req, res, next)=>{
    try {
        const {email, password, time} = req.body;
        const user = await userService.checkUser(email);
        if(!user){
            throw new Error('user doesn\'t exist');
        }

        const isMatch = await user.comparePassword(password);
        if(isMatch === false)
            throw new Error('password is incorrect');

        let userToken = {_id: user._id, email: user.email};
        const token = await userService.generateToken(userToken, "secretKey", '1h');
        res.status(200).json({status: true, token:token});
    } catch (error) {
        throw error;
    }
}

exports.getUser = async(req, res, next)=>{
    try {
        const {id} = req.params;
        const user = await userService.checkUser(id);
        if(!user){
            throw new Error('user doesn\'t exist');
        }

        res.status(200).json(user);
    } catch (error) {
        throw error;
    }
}

exports.logoutUser = async(req, res, next)=>{
    try {
        const {id} = req.params;
        const user = await userService.checkUser(id);
        if(!user){
            throw new Error('user doesn\'t exist');
        }
        let userToken = {_id: user._id, email: user.email};
        const token = await userService.generateToken(userToken, "secretKey", '0s');
        res.status(200).json({status: 'success', msg: 'user successfully logged out', token: token});
    } catch (error) {
        throw error;
    }
}