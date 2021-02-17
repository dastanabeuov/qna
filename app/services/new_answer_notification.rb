class Services::NotificationAnswer
  def notification(answer)
    question = answer.question
    question.subscribers.find_each(batch_size: 100) do |user|
      NotificationAnswerMailer.subscribers_notification(answer, user).deliver_later
    end
  end
end