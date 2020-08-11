class Answer < ApplicationRecord
  default_scope { order(created_at: :asc) }

  belongs_to :user
  belongs_to :question

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def best_answer
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.donative(user)
    end
  end
end