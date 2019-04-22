class MoveParticipatingInformationToEventParticipantsTable < ActiveRecord::Migration
  def up
  	remove_column :events, :participants
  	add_column :event_participants, :participants, :integer, null: false
  end

  def down
  	add_column :events, :participants, :integer, null: false
  	remove_column :event_participants, :participants
  end
end
