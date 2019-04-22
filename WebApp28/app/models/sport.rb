class Sport < ActiveRecord::Base

  ## Foreign key from favourite_sports.sport to sports.name
  ## If a sport is destroyed, his favourite sports entries are also destroyed
  has_many :favourite_sports, dependent: :destroy

end
