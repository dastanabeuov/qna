require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
=begin
  it 'validate precense of title' do
    expect(Question.new(title: 'Mytitle')).to_not be_valid 
  end

  it 'validate precense of body' do
    expect(Question.new(body: 'Mytext')).to_not be_valid 
  end
=end
end
