require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  describe 'DELETE #destroy from Question' do
    before { login(user) }
    let!(:question) { create :question, user_id: user.id }
    let!(:invalid_user) { create(:user) }
    let!(:invalid_question) { create :question, user_id: invalid_user.id }
    
    it 'Delete files attachments the question if user author' do
      expect { delete :destroy, params: { id: question.files.first }, format: :js }.not_to change(question.files, :count).by(-1)
    end

    it 'Delete files attachments the question if user not author' do
    	expect { delete :destroy, params: { id: invalid_question.files.first }, format: :js }.not_to change(question.files, :count)
    end    
  end

  describe 'DELETE #destroy from Answer' do
    before { login(user) }
    let!(:question) { create :question, user_id: user.id }
    let!(:answer) { create :answer, user_id: user.id, question_id: question.id }
    let!(:invalid_user) { create(:user) }
    let!(:invalid_answer) { create :answer, user_id: invalid_user.id }
    
    it 'Delete files attachments the question if user author' do
      expect { delete :destroy, params: { id: answer.files.first }, format: :js }.not_to change(question.files, :count).by(-1)
    end

    it 'Delete files attachments the question if user not author' do
    	expect { delete :destroy, params: { id: invalid_answer.files.first }, format: :js }.not_to change(question.files, :count)
    end    
  end  
end