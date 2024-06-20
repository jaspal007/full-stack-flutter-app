const express = require('express');
const router = express.Router();
const todoController = require('../controller/todo.controller');

router.post('/storeTodo', todoController.createTodo);           //create
router.get('/getTodos', todoController.getTodos);               //read list
router.get('/getTodo/:id', todoController.getTodo);             //read item
router.patch('/updateTodo/:id', todoController.updateTodo);     //update
router.delete('/deleteTodo/:id', todoController.deleteTodo);    //delete

module.exports = router;