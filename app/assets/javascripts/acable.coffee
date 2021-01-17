$ ->
  answersList = $('.answers')

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      console.log 'Connected follow!'
      @perform 'follow', { id: gon.question_id }
    ,
    received: (data) ->
      answersList.append(JST['templates/answer']({
        answer: data.answer,
        attachments: data.files,
        current_user: gon.question_user_id,
        votes: data.votes,
        comments: data.comments,
        question_author: data.question_author
      }))
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log 'Connected follow_answer!'
      @perform 'follow_answer', {id: gon.question_id}
    ,
    received: (data) ->
      object = JSON.parse(data)
      $('.answer-' + object.id + '-comments').append('<li class="comment-'+object.comment.id+'">'+object.comment.text+'</li>')
  })