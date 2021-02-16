class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi #{user.email}"
    @questions = Question.one_day_ago
    mail(to: user.email, subject: 'Daily digest of questions') if @questions.any?
  end
end
