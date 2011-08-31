class CreateCalendars < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.datetime :date
      t.text :note
      t.integer :user_id
      t.boolean :for_public
      t.boolean :available, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :calendars
  end
end
