class AwardsController < ApplicationController
  def index
  	@awards = current_user.awards.with_attached_image
  end
end