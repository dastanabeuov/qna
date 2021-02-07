class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.destroy if current_user.author_of?(@attachment.record)
  end
end