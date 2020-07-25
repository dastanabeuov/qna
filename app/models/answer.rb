class Answer < ApplicationRecord
  default_scope { order(created_at: :asc) }

  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true

  def best_answer
    previous_answer = question.answers.find_by(best: true)

    Answer.transaction do
      previous_answer.update!(best: false) if previous_answer
      update!(best: true)
    end
  end 
end