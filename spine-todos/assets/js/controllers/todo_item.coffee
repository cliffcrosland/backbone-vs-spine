#####################
## View for one Todo
#####################
class TodoItem extends Spine.Controller
  className: 'item'

  elements:
    'input[type=checkbox]' : 'checkbox'
    'input[type=text]' : 'input'

  events:
    'change input[type=checkbox]' : 'toggle'
    'click a.destroy' : 'destroy'
    'dblclick span' : 'edit'
    'blur input[type=text]' : 'close'
    'keypress input[type=text]' : 'blurOnEnter'

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
    @todo.updateAttributes done: !@todo.done

  edit: ->
    @el.addClass 'editing'
    @input.focus()

  close: ->
    @todo.updateAttributes message: @input.val()
    @el.removeClass 'editing'

  blurOnEnter: (e) ->
    if e.keyCode is 13 then e.target.blur()

window.TodoItem = TodoItem
