class AddConstraintToLevelOfEvent < ActiveRecord::Migration
  def up
  	execute "ALTER TABLE events ADD CONSTRAINT level_between_zero_and_three CHECK (level >= 0 AND level <= 3);"
  end

  def down
  	execute "ALTER TABLE events REMOVE CONSTRAINT level_between_zero_and_three;"
  end

end
