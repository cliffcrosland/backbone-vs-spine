class Todo extends Spine.Model
  @configure 'Todo', 'message', 'done'
  @extend Spine.Model.Local # use local storage, not remote

  @done: ->
    @select (todo) -> !!todo.done

  @notDone: ->
    @select (todo) -> !todo.done

window.Todo = Todo
