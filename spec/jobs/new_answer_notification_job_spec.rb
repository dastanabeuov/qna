require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
	let(:user) { create(:user) }
	let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'calls Services::NewAnswerNotification#notification' do
    expect(Services::NewAnswerNotification).to receive(:notification).with(answer)
    NewAnswerNotificationJob.perform_now(answer)
  end
end