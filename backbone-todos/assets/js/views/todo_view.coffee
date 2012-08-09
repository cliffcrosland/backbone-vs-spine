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

window.TodoView = TodoView
