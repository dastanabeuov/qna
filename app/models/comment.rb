class Comment < ApplicationRecord
  default_scope { order(created_at: :asc) }
  
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true
end
