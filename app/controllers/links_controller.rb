class LinksController < ApplicationController
  def destroy
  	@link = Link.find(params[:id])
    @link.destroy if current_user.author_of?(@link.linkable)
    # if @link.linkable.is_a?(Question)
    #   redirect_to @link.linkable
    # else
    #   redirect_to @link.linkable.question
    # end
  end
end