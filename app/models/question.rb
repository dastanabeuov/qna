class Question < ApplicationRecord
  include Votable
  
  belongs_to :user

  has_many :answers, dependent: :destroy
	has_one :award, dependent: :destroy  
	has_many :links, dependent: :destroy, as: :linkable	
	has_many_attached :files
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
	accepts_nested_attributes_for :award, reject_if: :all_blank
	
  validates :title, :body, presence: true

  def donative(user)
    award.update!(recipient: user)
  end
end