module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def like(user)
    vote(user, 1)
  end

  def dislike(user)
    vote(user, -1)
  end

  def vote_count
    votes.sum(:value) + 1
  end

  def liked?(user)
    duplicate_vote?(user, 1)
  end

  def disliked?(user)
    duplicate_vote?(user, -1)
  end

  private

  def vote(user, value)
    return false if user.author_of?(self) || duplicate_vote?(user, value)

    transaction do
      last_vote(user)
      votes.create!(user: user, value: value)
    end
  end

  def duplicate_vote?(user, value)
    last_vote(user)&.value == value
  end

  def last_vote(user)
    votes.find_by(user: user.id) if user.present?
  end
end