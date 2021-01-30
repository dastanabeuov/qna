require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  describe 'GET #index' do
    let!(:user) { create(:user) }
    let!(:question1) { create(:question, user: user) }
    let!(:question2) { create(:question, user: user) }
    let!(:award1) { create(:award, question: question1, recipient: user) }
    let!(:award1) { create(:award, question: question2, recipient: user) }

    before do
      login(user)
      get :index
    end

    it 'creates and populates an array of user awards' do
      expect(controller.awards).to match_array(user.awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end