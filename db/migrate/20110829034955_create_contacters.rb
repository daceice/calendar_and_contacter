class CreateContacters < ActiveRecord::Migration
  def self.up
    create_table :contacters do |t|
      t.string :name
      t.string :company
      t.string :email
      t.string :phone
      t.string :cellphone
      t.text :note
      t.string :address
      t.integer :user_id
      t.boolean :for_public
      t.boolean :available, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :contacters
  end
end
