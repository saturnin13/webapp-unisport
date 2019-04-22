class FavouriteSport < ActiveRecord::Base
	self.primary_keys = :user_id, :sport
	belongs_to :user
	belongs_to :sports

	## Sport must be a valid sport
	validate :sport_is_valid

	private

	def sport_is_valid
		if !Sport.where(name: self.sport).exists? then
			errors.add(:sport, "Sport choice is invalid.")
		end
	end

end
