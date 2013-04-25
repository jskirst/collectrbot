class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :title
      t.text    :url
      t.text    :content
    end
    add_index :pages, [:url], unique: true
    
    create_table :user_pages do |t|
      t.string  :user_id
      t.integer :page_id
      
      t.integer :viewed
      t.boolean :favorited
      t.boolean :archived
      
      t.timestamps
    end
    add_index :user_pages, [:user_id, :page_id], unique: true
  end
end
