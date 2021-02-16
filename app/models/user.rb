class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, foreign_key: 'recipient_id'
	has_many :votes
	has_many :comments
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_question, through: :subscriptions, source: :question
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github facebook]

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def subscribe?(entity)
    subscriptions.where(question: entity).exists?
  end
end
