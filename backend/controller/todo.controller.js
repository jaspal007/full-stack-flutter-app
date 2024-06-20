const todoService = require('../services/todo.service');

exports.createTodo = async(req, res, next)=>{
    try {
        const {userId, title, desc} = req.body;
        let todo = await todoService.createTodo(userId, title, desc);
        
        res.status(200).json(todo);
    } catch (error) {
        throw error;
    }
}

exports.getTodos = async(req, res, next)=>{
    try {
        let todo = await todoService.getTodos();
        res.status(200).json(todo);
    } catch (error) {
        throw error;
    }
}

exports.getTodo = async(req, res, next)=>{
    try {
        const {id} = req.params;
        let todo = await todoService.getTodo(id, res);
        res.status(200).json(todo);
    } catch (error) {
        throw error;
    }
}

exports.updateTodo = async(req, res, next)=>{
    try {
        const {id} = req.params;
        let todo = await todoService.updateTodo(id, req.body, res);
        let updateTodo = await todoService.getTodo(id);
        res.status(200).json(updateTodo);
    } catch (error) {
        throw error;
    }
}

exports.deleteTodo = async(req, res, next)=>{
    try {
        const {id} = req.params;
        await todoService.deleteTodo(id, res);
    } catch (error) {
        throw error;
    }
}