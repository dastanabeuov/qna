class SingleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at

  has_many :attachments
  has_many :links
  has_many :comments
  
  def comments
    object.comments.order(id: :asc)
  end

  def attachments
    object.attachments.order(id: :asc)
  end
end