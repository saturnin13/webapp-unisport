class EventParticipant < ActiveRecord::Base

	## Set the pair (event_id, user_id) as primary key
	self.primary_keys = :event_id, :user_id
	## Set foreign key from event_id to events.id
	belongs_to :event
	## Set foreign key from user_id to users.id
	belongs_to :user

	## Checks participants >= 1
	validates :participants, :numericality => { :greater_than_or_equal_to => 1 }
end
