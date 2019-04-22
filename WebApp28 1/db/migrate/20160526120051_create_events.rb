class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|

      t.string :sport, null: false
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :location, null: false
      t.string :additional_info

      t.integer :needed, null: false
      t.integer :min_participants
      t.integer :participants, null: false

      t.integer :user_id, null: false
      t.timestamps null: false
    end
  end

  def down
  	drop_table :events
  end
end
