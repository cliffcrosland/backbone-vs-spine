##################
## Todo
##################
class Todo extends Backbone.Model
  defaults:
    message: 'Get the milk'
    done: false

class TodoList extends Backbone.Collection
  model: Todo
  url: '/todolist'
  save: ->
    Backbone.sync 'create', @,
      success: (res) -> console.log res
      error: (res) -> console.log res

window.Todo = Todo
window.TodoList = TodoList
