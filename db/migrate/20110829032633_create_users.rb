class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login_name
      t.string :password
      t.string :name
      t.boolean :available, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
