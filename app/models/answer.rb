class Answer < ApplicationRecord
  include Voteable
  
  default_scope { order(created_at: :asc) }

  belongs_to :user
  belongs_to :question, touch: true

  has_many_attached :attachments
  has_many :comments, as: :commentable
  has_many :links, dependent: :destroy, as: :linkable
  
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :send_notify

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

  private

  def send_notify
    NewAnswerNotificationJob.perform_later(self)
  end
end