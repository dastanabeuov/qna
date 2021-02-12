class Question < ApplicationRecord
  include Voteable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
  has_many_attached :attachments
  has_one :award, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  
  validates :title, :body, presence: true

  def donative(user)
    award.update!(recipient: user)
  end
end