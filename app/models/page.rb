class Page < ActiveRecord::Base
  attr_accessible :title, :content, :visible_content, :url, :user_id, :viewed
  
  belongs_to :user
  
  validates_presence_of :url
  validates_presence_of :content
  validates_presence_of :user_id
  validates_presence_of :viewed
end
