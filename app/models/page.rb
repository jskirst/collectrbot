class Page < ActiveRecord::Base
  # :title, :content, :url
  
  has_many :user_pages
  
  validates_presence_of :url
  
  def domain() url.split("/")[2] end
  def sub_url() url.split("/")[3..-1].join("/") end
end
