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

window.AddTodoView = AddTodoView
