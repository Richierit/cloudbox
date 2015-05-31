class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|

    	t.string :sharer
    	t.integer :file_id
    	t.string :sharedto

      	t.timestamps null: false
    end
  end
end
