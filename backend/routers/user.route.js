const express = require("express");
const router = express.Router();
const userController = require("../controller/user.controller");

router.post("/registration", userController.registerUser);
router.post("/login", userController.loginUser);

module.exports = router;
