class AttachmentsController < ApplicationController
	respond_to :js
  
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    respond_with(@attachment.destroy) if current_user.author_of?(@attachment.record)
  end
end