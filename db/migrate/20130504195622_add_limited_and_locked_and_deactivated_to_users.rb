class AddLimitedAndLockedAndDeactivatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :limited, :datetime
    add_column :users, :locked, :datetime
    add_column :users, :deactivated, :datetime
  end
end
