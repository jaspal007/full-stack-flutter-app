const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const userRouter = require('./routers/user.route')
const todoRouter = require('./routers/todo.route')

app.use(bodyParser.json());
app.use('/', userRouter);
app.use('/', todoRouter);


module.exports = app;
