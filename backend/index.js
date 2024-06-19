const app = require("./app");
const db = require("./config/db");
const user = require("./model/user.model");
const port = 3000;

app.get("/", (req, res) => {
  res.send("Hellooo");
});

db.then(() => {
  app.listen(3000, () => {
    console.log("connection established");
  });
});