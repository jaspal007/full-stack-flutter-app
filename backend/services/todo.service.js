const todoModel = require("../model/todo.model");

class todoService{
    static async createTodo(userId, title, desc){
        const createTodo = new todoModel({userId, title, desc});
        return await createTodo.save();
    }
    static async getTodos(){
        const todo = await todoModel.find({});
        return todo;
    }
    static async getTodo(id, res){
        const todo = await todoModel.findById(id);
        if(!todo)
            res.status(404).json({msg: 'item not found'});
        else
            return todo;
    }
    static async updateTodo(id, req, res){
        const todo = await todoModel.findByIdAndUpdate(id, req);
        if(!todo)
            res.status(404).json({msg: 'item not found'});
        else
            return todo;
    }
    static async deleteTodo(id, res){
        const todo = await todoModel.findByIdAndDelete(id);
        if(!todo)
            res.status(404).json({msg: 'item not found'});
        else
            res.status(200).json({msg:'item deleted successfully'});
    }
};

module.exports = todoService;