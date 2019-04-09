require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create :question, user_id: user.id }
  let(:answer) { create :answer, question: question, user_id: user.id }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid atributes' do
      it 'connection with the logged in user' do
        post :create, params: { question_id: question, user_id: user.id, answer: attributes_for(:answer) }
        expect(assigns(:answer).user_id).to eq user.id
      end

      it 'save a new answer in the database & the answer lies in the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirectto show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid atributes' do
      it 'not save a answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 'redirectto new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template "questions/show"
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'edit the appropriate @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer, question: question, user_id: user.id }
    let!(:invalid_user) { create(:user) }
    let!(:invalid_answer) { create :answer, question: question, user_id: invalid_user.id  }

    it 'deletes the question if login and author current user' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'deletes the question if current user is not author answer' do
      expect { delete :destroy, params: { id: invalid_answer } }.to_not change(Answer, :count)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end  

end
