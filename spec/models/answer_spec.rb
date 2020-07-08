require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }
	
	it { should validate_presence_of :body }
  it { should belong_to :question }

  describe 'method "best_answer":' do
    before do 
      answers.last.best_answer
      answers.first.best_answer
    end

    it 'correct answer by best' do
      expect(answers.first).to be_best
    end

    it 'correct only one best answer' do
      expect(question.answers.where(best: true).count).to eq 1
    end
  end  
end