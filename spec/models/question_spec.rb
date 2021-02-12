require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:award).dependet(:destroy) }

  it_behaves_like 'resourcable'

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'method "donative":' do
    before do 
      question.answers.last.best_answer
    end

    it 'question correct answer by best' do
      expect(answers.last).to be_best
    end

    it 'question correct only one best answer' do
      expect(question.answers.where(best: true).count).to eq 1
    end
  
    it 'question only correct answer donative author user' do
      expect(question.user_id).to be_donative
    end
  end 
end