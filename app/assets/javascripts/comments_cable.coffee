$ ->

  questionId = $('.question').data('id')

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'comments_question', { id: questionId }
    ,

    received: (data) ->
      object = JSON.parse(data)
      $('.question-' + object.id + '-comments-list').append('<li class="comment-'+object.comment.id+'">'+object.comment.text+'</li>')
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'comments_answer', { id: questionId }
    ,

    received: (data) ->
      object = JSON.parse(data)
      $('.answer-' + object.id + '-comments-list').append('<li class="comment-'+object.comment.id+'">'+object.comment.text+'</li>')
  })