class CreateUserfiles < ActiveRecord::Migration
  def change
    create_table :userfiles do |t|
      t.string :name
      t.string :link
      t.integer :size
      

      t.timestamps null: false
    end
  end
end
