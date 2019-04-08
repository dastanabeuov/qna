require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  
  describe "Associations" do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  describe "Validation" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe "Methods" do
    let(:user) { create(:user) }

    it "valid author" do
      question = create(:question, user_id: user.id )
      expect(user).to be_author_of(question)
    end

    it "invalid author" do
      invalid_user = create(:user)
      question = create(:question, user_id: user.id )
      expect( user.author_of?(question) ).to eq false
    end
  end   

end
