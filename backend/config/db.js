const mongoose = require("mongoose");
const app = require('../app')
const connections = mongoose
  .connect(
    "mongodb+srv://jaspalsinghgkp512:in4zgQhewnhd8hXx@cluster0.xpdxjov.mongodb.net/ToDo?retryWrites=true&w=majority&appName=Cluster0"
  )
  .then(() => {
    console.log("connected to database");
  })
  .catch((err) => {
    console.log("connection failed");
  });

module.exports = connections;
