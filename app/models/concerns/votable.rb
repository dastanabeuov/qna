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
    votes.sum(:value)
  end

  def liked?(user)
    duplicated_vote?(user, 1)
  end

  def disliked?(user)
    duplicated_vote?(user, -1)
  end

  private

  def vote(user, value)
    return false if user.author_of?(self) || duplicated_vote?(user, value)

    transaction do
      votes.create!(user: user, value: value)
    end
  end

  def duplicated_vote?(user, value)
    last_vote(user)&.value == value
  end

  def last_vote(user)
    votes.find_by(user: user.id) if user.present?
  end
end