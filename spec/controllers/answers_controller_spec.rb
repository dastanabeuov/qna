require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create :question, user_id: user.id }
  let(:answer) { create :answer, question: question, user: user }

  before { login(user) }

  describe 'POST #create' do
    context 'valid attributes' do
      it 'authenticated user can create' do
        post :create, params: { question: question, user: user, answer: attributes_for(:answer), format: :js }
        
        expect(assigns(:answer).user_id).to eq user.id
      end

      it 'can save new answer in the database & the answer lies in the question' do
        count = question.answers.count
        post :create, params: { question: question, answer: attributes_for(:answer), format: :js }
        
        expect(question.answers.count).to eq count + 1
      end

      it 'redirectto show view' do
        post :create, params: { question: question, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :show
      end
    end

    context 'invalid attributes' do
      it 'not save a answer in the database' do
        count = question.answers.count
        post :create, params: { question: question, answer: attributes_for(:answer, :invalid), format: :js }
      
        expect(question.answers.count).to eq count
      end

      it 'redirect to new view' do
        post :create, params: { question: question, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer, question: question, user: user }
    let!(:invalid_user) { create(:user) }
    let!(:invalid_answer) { create :answer, question: question, user: invalid_user  }

    it 'deletes the question if login and author current user' do
      count = Answer.count
      delete :destroy, params: { id: answer }

      expect(Answer.count).to eq count - 1
    end

    it 'deletes the question if current user is not author answer' do
      count = Answer.count
      delete :destroy, params: { id: invalid_answer }
      
      expect(Answer.count).to eq count
    end

    it 'redirect to show page question' do
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

      it 'render "update" template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

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

  describe 'PATCH #correct_best' do
    let(:other_answer) { create(:answer, question: question, user: user) }

    context 'used bu authenticated user' do
      before { login(user) }

      it 'changes needed answer attributes' do
        patch :correct_best, params: { id: answer, format: :js }
        answer.reload

        expect(answer).to be_best
      end

      it 'changes needed attributes for other answers' do
        other_answer = create(:answer, question: question, best: true)
        patch :correct_best, params: { id: answer, format: :js }
        other_answer.reload

        expect(other_answer).to_not be_best
      end

      it 'renders correct_best template' do
        patch :correct_best, params: { id: answer, format: :js }

        expect(response).to render_template :correct_best
      end
    end

    context 'used by user, who is not author of the related question' do
      before { login(non_author) }

      it 'does not change best status of the answer' do
        patch :correct_best, params: { id: other_answer, format: :js }
        answer.reload

        expect(answer).to_not be_best
      end

      it 'have http status Forbidden' do
        patch :correct_best, params: { id: answer, format: :js }

        expect(response).to have_http_status(403)
      end
    end

    context 'used by unauthenticated user' do
      it 'does not change best status of the answer' do
        patch :correct_best, params: { id: other_answer, format: :js }
        answer.reload

        expect(answer).to_not be_best
      end

      it 'returns unauthorized 401 status code' do
        patch :correct_best, params: { id: answer, format: :js }

        expect(response).to have_http_status(401)
      end
    end
  end
end
