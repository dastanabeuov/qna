class LinksController < ApplicationController
	respond_to :js
  
  authorize_resource

  def destroy
  	@link = Link.find(params[:id])
    respond_with(@link.destroy) if current_user.author_of?(@link.linkable)
  end
end