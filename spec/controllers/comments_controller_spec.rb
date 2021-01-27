require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let(:non_author) { create(:user) }
  let(:question) { create :question, user_id: user.id }
  let(:answer) { create :answer, question: question, user_id: user.id }

  before { sign_in(user) }

  describe 'POST #create (question comment)' do
  	context 'with question comment' do
  		it 'only question' do
  			visit question_path(question)
        post :create, params: { commentable_id: question.id, commentable_type: question, user: user, text: 'My text' }

        expect(question.comments).to eq 'My text'
      end
  	end
  end

  describe 'POST #create (answer comment)' do
  	context 'with answer comment' do
  		it 'only answer' do
  			visit question_path(question)
        post :create, params: { commentable_id: answer.id, commentable_type: answer, user: user, text: 'My text' }
  		  
        expect(answer.comments).to eq 'My text'
      end
  	end
  end
end
