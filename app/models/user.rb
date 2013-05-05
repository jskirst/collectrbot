class User < ActiveRecord::Base
  def to_param
    username
  end
  
  default_scope order('id ASC')
  
  DISALLOWED_USERNAMES = ["pages", "users", "api"]
  
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :limited
  
  has_many :pages
  
  has_many :subscription_records, class_name: "Subscription", foreign_key: "subscriber_id"
  has_many :subscriber_records, class_name: "Subscription", foreign_key: "subscribed_id"
  
  has_many :subscriptions, through: :subscription_records, source: :subscribed, conditions: ["subscriptions.approved is not ?", nil]
  has_many :subscribers, through: :subscriber_records, source: :subscriber, conditions: ["subscriptions.approved is not ?", nil]
  
  has_many :pending_subscriptions, through: :subscription_records, source: :subscribed, conditions: ["subscriptions.approved is ?", nil]
  has_many :pending_subscribers, through: :subscriber_records, source: :subscriber, conditions: ["subscriptions.approved is ?", nil]
  
  before_save do
    if DISALLOWED_USERNAMES.include?(username)
      errors.add :base, "Username not allowed."
    end
  end
  
  def limited?() limited.nil? ? false : true end
  
  def encrypted_id(password)
    BCrypt::Engine::hash_secret(email+password, Rails.application.config.secret_token)
  end
  
  def subscription(user) return subscription_records.find_by_subscriber_id_and_subscribed_id(self.id, user.id) end
  def subscribed?(user) subscription(user).present? end
  def subscribe!(user)
    unless subscribed?(user)
      Subscription.create!(subscriber_id: self.id, subscribed_id: user.id)
    end
  end
  def unsubscribe!(user)
    sub = subscription(user)
    sub.destroy if sub
  end
  def approve_subscriber(user)
    subscriber_records.find_by_subscriber_id_and_subscribed_id(user.id, self.id).approve!
  end
  
  def wipe_clean(user_token)
    Subscription.where("subscriber_id = ? or subscribed_id = ?", self.id, self.id).destroy_all
    UserPage.where("user_id = ? or user_id = ?", self.id, user_token).destroy_all
  end
end
