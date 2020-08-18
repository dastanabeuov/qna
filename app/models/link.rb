class Link < ApplicationRecord
	URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  belongs_to :linkable, polymorphic: true

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true,
   format: { with: URL_REGEX, multiline: true,
    message: "Only format 'http or https://example.com' " }    
end
