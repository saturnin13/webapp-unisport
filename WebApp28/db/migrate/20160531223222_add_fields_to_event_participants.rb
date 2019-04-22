class AddFieldsToEventParticipants < ActiveRecord::Migration
  def up
  	add_column :event_participants, :confirmed, :boolean, null: false
  	add_column :event_participants, :message, :string, null: true
  end

  def down
  	remove_column :event_participants, :confirmed
  	remove_column :event_participants, :message
  end
end
