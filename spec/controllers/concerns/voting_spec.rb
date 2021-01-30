require 'rails_helper'

shared_examples "Like or Dislike QnA" do
  let (:user) { create(:user) }
  let (:user2) { create(:user) }
  let (:user3) { create(:user) }
  let (:question) { create(:question, user: user) }
  let (:answer) { create(:answer, user: user, question: question) } 

  describe 'PATCH #Like' do
    login(user2)

    it "change like +1" do
      patch :like, params: { id: question, value: 1, votable_id: question.id, votable_type: question.class.name, user_id: user2 format: :json }
      patch :like, params: { id: answer, value: 1, votable_id: answer.id, votable_type: answer.class.name, user_id: user2 format: :json }

      question.reload
      answer.reload
      
      expect(question.votes.first.value).to eq 1
      expect(answer.votes.first.value).to eq 1
    end
  end

  describe 'PATCH #Dislike' do
    login(user3)

    it "change dislike -1" do 
      patch :dislike, params: { id: question, value: 1, votable_id: question.id, votable_type: question.class.name, user_id: user2 format: :json }
      patch :dislike, params: { id: answer, value: 1, votable_id: answer.id, votable_type: answer.class.name, user_id: user2 format: :json }

      question.reload
      answer.reload
      
      expect(question.votes.first.value).to eq 1
      expect(answer.votes.first.value).to eq 1
    end
  end

  describe 'PATCH #cancel_votes' do
    login(user)

    it "changes cancel value (like + dislike)" do 
      patch :dislike, params: { id: question, value: 1, votable_id: question.id, votable_type: question.class.name, user_id: user2 format: :json }
      patch :dislike, params: { id: answer, value: 1, votable_id: answer.id, votable_type: answer.class.name, user_id: user2 format: :json }

      question.reload
      answer.reload
      
      expect(question.votes.first.value).to eq nil
      expect(answer.votes.first.value).to eq nil
    end
  end
end