class TodoController < ApplicationController
    def show
        @todolist = Todo.all
    end

    def create
        pass
    end

    def destroy
        pass
    end
end
