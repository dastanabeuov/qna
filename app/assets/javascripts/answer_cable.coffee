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
        rating: data.rating,
        question_author: data.question_author
      }))
  })