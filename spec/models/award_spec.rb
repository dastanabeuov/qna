require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:recipient).class_name('User').optional }

  it 'have one attached files' do
    expect(Award.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end