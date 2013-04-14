class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  before_save :ensure_authentication_token
  
  has_many :pages, dependent: :destroy
end
