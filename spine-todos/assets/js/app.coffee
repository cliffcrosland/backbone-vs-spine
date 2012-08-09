jQuery ->

  #############
  ## Todo model
  #############
  class Todo extends Spine.Model
    @configure 'Todo', 'message', 'done'
    @extend Spine.Model.Local # use local storage, not remote

    @done: ->
      @select (todo) -> !!todo.done

    @notDone: ->
      @select (todo) -> !todo.done

  #####################
  ## View for one Todo
  #####################
  class TodoItem extends Spine.Controller
    className: 'item'

    elements:
      'input[type=checkbox]' : 'checkbox'

    events:
      'change input[type=checkbox]' : 'toggle'
      'click a.destroy' : 'destroy'

    constructor: ->
      super
      throw '@todo required' unless @todo
      @todo.bind 'change', @render
      @todo.bind 'destroy', @remove

    render: (todo) =>
      @todo = todo if todo
      @html @template @todo
      if @todo.done
        @el.addClass 'done'
      else
        @el.removeClass 'done'
      @

    template: (todo) =>
      templ = $("#todo_templ")
      Mustache.render templ.html(), todo

    remove: =>
      @el.remove()

    destroy: ->
      @todo.destroy()

    toggle: ->
      @todo.done = !@todo.done
      @todo.save()

  ###########################
  ## Counter - num todos done
  ###########################
  class Counter extends Spine.Controller
    events:
      'click a.clear' : 'clearDone'

    constructor: ->
      super
      Todo.bind 'create refresh destroy change', @render

    render: =>
      @html @template()

    template: =>
      templ = $('#counter_templ')
      Mustache.render templ.html(),
        count: Todo.notDone().length
        display: if Todo.done().length > 0 then 'block' else 'none'

    clearDone: ->
      Todo.each (todo) ->
        if todo.done
          todo.destroy()

  #############
  ## Todos App
  #############
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

      counter = new Counter el: @footer
      counter.render()

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

  ##############
  ## Launch it
  ##############
  todos = new Todos el: $('#views')
