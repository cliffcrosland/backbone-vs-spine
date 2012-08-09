jQuery ->

  ####################################
  ## Save changes to localStorage
  ####################################
  Backbone.sync = (method, model, options) ->
    console.log arguments
    switch method
      when 'read'
        stored = localStorage[model.url]
        if stored
          options.success JSON.parse stored
      when 'create', 'update'
        localStorage[model.url] = JSON.stringify(model)
        options.success model
      when 'delete'
        delete localStorage[model.url]
        options.success model

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

  class TodoView extends Backbone.View
    initialize: ->
      _.bindAll @

      @model.bind 'change', @render
      @model.bind 'remove', @unrender

    render: =>
      checked = 'checked="checked"'
      $(@el).html """
        <div class="view" title="Double click to edit...">
          <input type="checkbox" #{if @model.get 'done' then checked else ''}>
          <span>#{@model.get 'message'}</span>
          <a class="destroy"></a>
        </div>
        <div class="edit">
          <input type="text" value="#{@model.get 'message'}">
        </div>
      """
      $(@el).addClass 'item'
      if @model.get 'done'
        $(@el).addClass 'done'
      else
        $(@el).removeClass 'done'
      @

    unrender: =>
      $(@el).remove()

    editTodo: ->
      $(@el).addClass 'editing'
      $(@el).find('input').focus()

    blurOnEnter: (e) ->
      if e.keyCode is 13 then e.target.blur()

    close: ->
      new_message = $(@el).find('input[type=text]').val()
      @model.set message: new_message
      $(@el).removeClass 'editing'

    toggle: ->
      @model.set done: !(@model.get 'done')

    destroy: -> @model.destroy()

    events:
      'dblclick span': 'editTodo'
      'keypress input[type=text]': 'blurOnEnter'
      'blur input[type=text]': 'close'
      'click .destroy': 'destroy'
      'change input[type=checkbox]': 'toggle'

  ####################
  ## Add todo to list
  ####################

  class AddTodoView extends Backbone.View
    tagName: 'form'

    initialize: ->
      _.bindAll @

    render: ->
      $(@el).html """
        <input type="text" placeholder="What needs to be done?">
      """
      @

  #################
  ## Footer view
  #################
  class FooterView extends Backbone.View
    tagName: 'footer'

    initialize: ->
      _.bindAll @
      @collection.bind 'add', @render
      @collection.bind 'change', @render
      @collection.bind 'remove', @render
      @render()

    render: ->
      num_done = _.filter(@collection.models, (todo) -> todo.get 'done').length
      display = if num_done > 0 then 'block' else 'none'
      $(@el).html """
        <a class="clear" style="display:#{display};">Clear completed</a>
        <div class="count">
          <span class="countVal">#{@collection.length}</span> left
        </div>
      """
      @

    removeCompleted: ->
      _.map(@collection.models, (todo) ->
        if todo.get 'done'
          todo.destroy())

    events:
      'click .clear' : 'removeCompleted'

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

  app_view = new AppView
