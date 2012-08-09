
#################
## App
#################

class AppView extends Backbone.View
  el: $ '#tasks'

  initialize: ->
    _.bindAll @
    @collection = new TodoList
    @collection.bind 'add', @appendTodo
    @collection.bind 'reset', @renderTodos

    @collection.bind 'add', @collection.save
    @collection.bind 'remove', @collection.save
    @collection.bind 'change', @collection.save
    @collection.fetch()

    @add_todo_view = new AddTodoView
    @footer_view = new FooterView collection: @collection

    @render()

  render: ->
    $(@el).append '<h1>Todos</h1>'
    $(@el).append @add_todo_view.render().el
    $(@el).append '<div class="items"></div>'
    $(@el).append @footer_view.render().el
    @renderTodos()

  addTodo: (e) ->
    e.preventDefault() # prevent submitting form
    $input = $(@el).find('form input')
    todo = new Todo message: $input.val()
    @collection.add todo
    $input.val('')

  appendTodo: (todo) ->
    todo_view = new TodoView model: todo
    $(@el).find('.items').append todo_view.render().el

  renderTodos: ->
    $(@el).find('.items').html('')
    _.map(@collection.models, @appendTodo)

  events:
    'submit form' : 'addTodo'

window.AppView = AppView
