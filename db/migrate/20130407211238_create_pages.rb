class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :user_id
      
      t.string  :title
      t.text    :url
      t.text    :content
      t.integer :viewed
      
      t.boolean :favorited
      t.boolean :archived

      t.timestamps
    end
  end
end
