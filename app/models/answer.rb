class Answer < ApplicationRecord
  include Voteable
  
  default_scope { order(created_at: :asc) }

  belongs_to :user
  belongs_to :question

  has_many_attached :attachments
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def best?
    self.best == true
  end

  def set_best
    transaction do 
      question.answers.update_all(best: false)
      update!(best: true)
      question.donative(user)
    end
  end
end