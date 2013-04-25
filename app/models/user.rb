class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :pages, dependent: :destroy
  
  def encrypted_id(password)
    BCrypt::Engine::hash_secret(email+password, Rails.application.config.secret_token)
  end
end
