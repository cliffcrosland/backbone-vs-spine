############
# Todos App
############
class Todos extends Spine.Controller
  elements:
    'form input[type=text]' : 'todoInput'
    '.items' : 'items'
    'footer' : 'footer'

  events:
    'submit form' : 'newTodo'

  constructor: ->
    super
    Todo.bind 'refresh', @addAll
    Todo.bind 'create', @addOne
    Todo.fetch()

    footer = new Footer el: @footer
    footer.render()

  newTodo: (e) ->
    e.preventDefault()
    Todo.create message: @todoInput.val(), done: false
    @todoInput.val('')
    e.target.blur()

  addOne: (todo) =>
    todo_item = new TodoItem todo: todo
    @items.append todo_item.render().el

  addAll: =>
    Todo.each @addOne

window.Todos = Todos
