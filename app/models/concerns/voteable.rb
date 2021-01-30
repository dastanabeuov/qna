module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def toggle_voting(user, value)
    vote = votes.find_by(user_id: user.id)

    if vote
      vote.destroy
    else
      votes.create(user_id: user.id, value: value)
    end
  end

  def voting
    votes.sum(:value)
  end
end