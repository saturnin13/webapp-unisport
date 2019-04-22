class AddConstraintsEventParticipants < ActiveRecord::Migration
  def up
  	add_foreign_key :event_participants, :events 
  	add_foreign_key :event_participants, :users
  end

  def down
  	remove_foreign_key :event_participants, :events
  	remove_foreign_key :event_participants, :users
  end
end
