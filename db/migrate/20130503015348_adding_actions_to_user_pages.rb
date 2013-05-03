class AddingActionsToUserPages < ActiveRecord::Migration
  def up
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    
    remove_column :user_pages, :favorited
    remove_column :user_pages, :archived
    
    add_column :user_pages, :shared, :datetime
    add_column :user_pages, :favorited, :datetime
    add_column :user_pages, :archived, :datetime
    add_column :user_pages, :trashed, :datetime
  end
  
  def down    
    remove_column :users, :username
        
    remove_column :user_pages, :shared
    remove_column :user_pages, :favorited
    remove_column :user_pages, :archived
    remove_column :user_pages, :trashed
    
    add_column :user_pages, :favorited, :boolean
    add_column :user_pages, :archived, :boolean
  end
end
