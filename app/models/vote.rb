class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :value, presence: true
  validates :user, uniqueness: { scope: %i[voteable_type voteable_id] }
end
