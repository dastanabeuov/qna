class Question < ApplicationRecord
  include Voteable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
  has_many_attached :attachments
  has_one :award, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  
  validates :title, :body, presence: true

  scope :one_day_ago, -> { where("created_at > ?", Time.now - 1.day) }

  after_create :calculate_reputation
  after_create :create_subscription_for_author

  def donative(user)
    award.update!(recipient: user)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def create_subscription_for_author
    subscriptions.create(user: user)
  end
end