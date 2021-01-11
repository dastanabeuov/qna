$ ->
  answersList = $('.answers')
  questionId = $('.question').data('id')
  userId = $('.question').data('user')

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', { id: questionId }
    ,
    received: (data) ->
      answersList.append(JST['templates/answer']({
        answer: data.answer,
        attachments: data.attachments,
        current_user: userId,
        voting: data.voting,
        question_author: data.question_author
      }))
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow_answer', {id: questionId}
    ,
    received: (data) ->
      object = JSON.parse(data)
      $('.answer-' + object.id + '-comments').append('<p>'+object.comment.text+'</p>')
  })