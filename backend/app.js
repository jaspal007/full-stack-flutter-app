const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const userRouter = require('./routers/user.route')

app.use(bodyParser.json());
app.use('/', userRouter);


module.exports = app;
