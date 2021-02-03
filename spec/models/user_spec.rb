require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:awards) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }

  describe 'method "author_of?":' do
    let(:user) { create(:user) }

    it "valid author" do
      question = create(:question, user_id: user.id )
      expect(user).to be_author_of(question)
    end

    it "invalid author" do
      invalid_user = create(:user)
      question = create(:question, user_id: user.id )
      expect(invalid_user).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end