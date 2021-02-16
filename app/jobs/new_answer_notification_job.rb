class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
		Services::NewAnswerNotification.notification(answer)
  end
end