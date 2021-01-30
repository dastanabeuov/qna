class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge if current_user.author_of?(@attachment.record)
    if @attachment.record.is_a?(Question)
      redirect_to @attachment.record
    else
      redirect_to @attachment.record.question
    end 
  end
end