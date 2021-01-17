$ ->
  questionsList = $('.questions-list')

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Connected follow!'
      @perform 'follow'
    ,

    received: (data) ->
    	questionsList.append data
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log 'Connected follow_question!'
      @perform 'follow_question', {id: gon.question_id}
    ,
    received: (data) ->
      object = JSON.parse(data)
      $('.question-' + object.id + '-comments').append('<li class="comment-'+object.comment.id+'">'+object.comment.text+'</li>')
  })