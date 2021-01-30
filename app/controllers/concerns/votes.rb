module Votes
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: [:like, :dislike]
    before_action :set_voteable, only: [:like, :dislike]
  end

  def like
    @voteable.toggle_voting(current_user, 1)
    render 'votes/toggle_voting'
  end

  def dislike
    @voteable.toggle_voting(current_user, -1)
    render 'votes/toggle_voting'
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end