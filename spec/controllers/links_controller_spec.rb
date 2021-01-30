require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { log_in(user) }

  describe 'DELETE #destroy' do
    context 'question' do
      let!(:question_link) { create(:link, linkable: question) }

      context 'user is user_id' do
        it 'deletes link' do
          expect { delete :destroy, params: { id: question_link }, format: :js }.to change(question.links, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: { id: question_link }, format: :js
          
          expect(response).to render_template :destroy
        end
      end

      context 'not the user_id of the question' do
        let(:user2) { create(:user) }

        before { log_in(user2) }

        it 'does not delete link' do
          expect { delete :destroy, params: { id: question_link }, format: :js }.not_to change(question.links, :count)
        end

        it 'returns 403 head' do
          delete :destroy, params: { id: question_link }, format: :js
          
          expect(response.status).to eq(403)
        end
      end
    end

    context 'answer' do
      let(:answer) { create(:answer, question: question, user: user) }
      let!(:answer_link) { create(:link, linkable: answer) }

      context 'user is user_id' do
        it 'deletes link' do
          expect { delete :destroy, params: { id: answer_link }, format: :js }.to change(answer.links, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: { id: answer_link }, format: :js
          
          expect(response).to render_template :destroy
        end
      end

      context 'not the user_id of the answer' do
        let(:user3) { create(:user) }

        before { log_in(user3) }

        it 'does not delete link' do
          expect { delete :destroy, params: { id: answer_link }, format: :js }.not_to change(answer.links, :count)
        end

        it 'returns 403 head' do
          delete :destroy, params: { id: answer_link.id }, format: :js
          
          expect(response.status).to eq(403)
        end
      end
    end
  end
end