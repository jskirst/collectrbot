class CreateSubscriptionsTable < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id
      t.integer :subscribed_id
      
      t.datetime :approved
      
      t.timestamps
    end
  end
end
