class Subscription < ActiveRecord::Base
  # :subscriber_id, :subscribed_id
  # :approved
  
  belongs_to :subscriber, class_name: "User"
  belongs_to :subscribed, class_name: "User"
  
  before_create do
    unless subscribed.limited?
      self.approved = Time.now()
    end
  end
  
  def approved?() not approved.nil? end
  def approve!
    self.approved = Time.now()
    self.save
  end
end