##########################
# Footer - num todos done
##########################
class Footer extends Spine.Controller
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

window.Footer = Footer
