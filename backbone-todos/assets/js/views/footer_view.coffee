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

window.FooterView = FooterView
