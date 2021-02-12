require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  it_behaves_like 'resourcable'

  it 'have many attached files' do
    expect(Answer.new.attachments).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should validate_presence_of :body }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'method "set_best":' do
    before do 
      answers.last.set_best
      answers.first.set_best
    end

    it 'correct answer set_best' do
      expect(answers.first).to be_best
    end

    it 'correct answer only one set_best' do
      expect(question.answers.where(best: true).count).to eq 1
    end
  end
end