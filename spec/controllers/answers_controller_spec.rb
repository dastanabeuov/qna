require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let(:non_author) { create(:user) }
  let(:question) { create :question, user_id: user.id }
  let(:answer) { create :answer, question: question, user_id: user.id }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid atributes' do
      it 'connection with the logged in user' do
        post :create, params: { question_id: question, user_id: user.id, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user_id).to eq user.id
      end

      it 'save a new answer in the database & the answer lies in the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'redirectto show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid atributes' do
      it 'not save a answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end

      it 'redirectto new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :create
      end
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

  describe 'PATCH #update' do
    context 'used by Authenticated user' do
      before { login(user) }

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      context 'with valid attributes' do
        it 'changes the answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: { body: nil }, format: :js } }

        it 'does not change the answer attributes' do
          correct_answer_body = answer.body
          answer.reload

          expect(answer.body).to eq correct_answer_body
        end

        it 're-renders update template' do
          expect(response).to render_template :update
        end
      end
    end

    context 'used by user, who is not author of the answer' do
      before { login(non_author) }

      it 'does not update the answer' do
        correct_answer_body = answer.body
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        answer.reload

        expect(answer.body).to eq correct_answer_body
      end

      it 'redirects to root path' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :update
      end
    end

    context 'used by Unauthenticated user' do
      it 'does not update the answer' do
        correct_answer_body = answer.body
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        answer.reload

        expect(answer.body).to eq correct_answer_body
      end

      it 'returns unauthorized 401 status code' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to_not have_http_status(401)
      end
    end
  end  

end
