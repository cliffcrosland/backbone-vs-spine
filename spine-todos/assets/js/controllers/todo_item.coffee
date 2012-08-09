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

window.TodoItem = TodoItem
