class LinksController < ApplicationController
  def destroy
    link.destroy if current_user.author_of?(link.linkable)
  end
end