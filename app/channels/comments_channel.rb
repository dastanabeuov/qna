class CommentsChannel < ApplicationCable::Channel
  def comments_question(params)
    stream_from "comments-for-question-#{params['id']}"
  end

  def comments_answer(params)
    stream_from "comments-for-answer-#{params['id']}"
  end
end