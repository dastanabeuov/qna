FactoryBot.define do
  factory :attachment do
    attachment { Rack::Test::UploadedFile.new('spec/support/image.png') }
  end
end