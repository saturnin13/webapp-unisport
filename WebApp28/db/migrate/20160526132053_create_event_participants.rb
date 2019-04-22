class CreateEventParticipants < ActiveRecord::Migration
  def up
    create_table :event_participants, id: false do |t|
      t.integer :event_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end

    add_index :event_participants, ["event_id", "user_id"], :unique => true

    execute "ALTER TABLE event_participants ADD PRIMARY KEY (event_id, user_id);"
  end

  def down
    drop_table :event_participants
  end
end
