$ ->
  questionsList = $('.questions-list')
  questionId = $('.question').data('id')

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Connected!'
      @perform 'follow'
    ,

    received: (data) ->
    	questionsList.append data
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow_question', {id: questionId}
    ,
    received: (data) ->
      object = JSON.parse(data)
      $('.question-' + object.id + '-comments').append('<p>'+object.comment.text+'</p>')
  })