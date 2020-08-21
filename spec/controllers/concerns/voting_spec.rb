require 'rails_helper'

shared_examples "Like or Dislike QnA" do
  let (:author_of_qna)     { create(:user) }
  let (:votable_question) { create(:question, user: author_of_qna) }
  let (:votable_answer)   { create(:answer, question: votable_question, user: author_of_qna)}
  
  describe 'PATCH #Like' do
    sign_in_user

    it "creates new like" do
      patch :like, params: { id: question, format: :json }
      patch :like, params: { question_id: votable_question, id: votable_answer, format: :json }
      votable_question.reload
      votable_answer.reload
      expect(votable_question.votes.first.value).to eq 1
      expect(votable_answer.votes.first.value).to eq 1
    end
  end

  describe 'PATCH #Dislike' do
    sign_in_user

    it "creates new dislike" do 
      patch :dislike, params: { id: voteble_question, format: :json }
      patch :dislike, params: { question_id: votable_question, id: votable_answer, format: :json }
      votable_question.reload
      votable_answer.reload
      expect(votable_question.votes.first.value).to eq -1
      expect(votable_answer.votes.first.value).to eq -1
    end
  end

  describe 'PATCH #cancel_votes' do
    sign_in_user

    it "changes value" do 
      patch :cancel_votes, params: { id: votable_question, format: :json }
      patch :cancel_votes, params: { question_id: votable_question, id: votable_answer, format: :json }
      votable_question.reload
      votable_answer.reload
      expect(votable_question.votes.first).to eq nil
      expect(votable_question.votes.first).to eq nil
    end
  end
end