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

  # Launch it
  app_view = new AppView
