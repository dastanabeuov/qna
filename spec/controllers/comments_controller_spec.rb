require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  before { login(user) }

  describe 'POST #create' do
  	context "valid attribute"
    	it 'question comment' do
        count = question.comments.count
  			visit question_path(question)
        post :create, params: { commentable_id: question.id, commentable_type: question, user: user, text: 'My text' }

        expect(question.comments.count).to eq count + 1
      end

      it 'answer comment' do
        count = answer.comments.count
        visit question_path(question)
        post :create, params: { commentable_id: answer.id, commentable_type: answer, user: user, text: 'My text' }
        
        expect(answer.comments.count).to eq count + 1
      end
    end

    context "invalid attribute"
      it 'question comment' do
        count = question.comments.count
        visit question_path(question)
        post :create, params: { commentable_id: nil, commentable_type: nil, user: user, text: 'My text' }

        expect(question.comments.count).to eq count
      end

      it 'answer comment' do
        count = answer.comments.count
        visit question_path(question)
        post :create, params: { commentable_id: nil, commentable_type: nil, user: user, text: 'My text' }
        
        expect(answer.comments.count).to eq count
      end
    end
  end
end
