require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:user) { create_list(:user) }
  let(:answers) { create_list(:answer, 3, user: user) }

  it 'sends daily digest to all users' do
    answers.each {|user| expect(NewAnswerNotificationMailer).to receive(:notification).with(user).and_call_original}
    subject.subscribers_notification
  end
end