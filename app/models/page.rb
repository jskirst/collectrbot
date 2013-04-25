class Page < ActiveRecord::Base
  attr_accessible :title, :content, :url
  
  has_many :user_pages
  
  validates_presence_of :url
end
