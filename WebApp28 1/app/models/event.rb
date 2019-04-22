class Event < ActiveRecord::Base

	## Foreign key from events.user_id to users.id
	belongs_to :user
	## Foreign key from event_participants.event_id to events.id
	## Destroying an event also destroys all the participations to this event
	has_many :event_participants, dependent: :destroy

	## The 'Needed' field has to be >= 1
	validates :needed, :numericality => { :greater_than_or_equal_to => 1 }

	## Date of event cannot be in the past on creation or update
	validate :date_cannot_be_in_past

	## Start time of event has to be before end time of event
	validate :times_are_logical

	## If min_participants isn't null, it cannot be negative
	validate :min_participants_cannot_be_lower_than_two

	## University location must be a valid university
	validate :university_location_is_valid

	## Sport must be a valid sport
	validate :sport_is_valid

	## Level must be between 0 and 3
	validates :level, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 3}


	private

	def date_cannot_be_in_past
		if date < Date.today
			errors.add(:date, "Date cannot be in the past!")
		end
	end

	def times_are_logical
		if start_time >= end_time
			errors.add(:end_time, "End time should be later than the start time!")
		end
	end

	def min_participants_cannot_be_lower_than_two
		if min_participants && min_participants < 2
			errors.add(:min_participants, "Minimum number of participants should be at least 2!")
		end
	end

  def university_location_is_valid
    if !UniversityMail.where(university_name: self.university_location).exists? then
      errors.add(:university_location, "University location is invalid.")
    end
  end

  def sport_is_valid
  	if !Sport.where(name: self.sport).exists? then
  		errors.add(:sport, "Sport choice is invalid.")
  	end
  end

end
