class UserPage < ActiveRecord::Base
  # :user_id, :page_id, :viewed, :archived, :trashed, :shared, :favorited
  
  belongs_to :user
  belongs_to :page
  
  validates_presence_of :user_id
  validates_presence_of :page_id
  validates_presence_of :viewed
  
  delegate :domain, :sub_url, to: :page
end
