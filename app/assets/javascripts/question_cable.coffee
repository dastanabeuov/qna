$ ->

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'questions_list'
    ,

    received: (data) ->
    	$('.questions-list').append data
  })