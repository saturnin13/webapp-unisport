class AddConstraintToSportsName < ActiveRecord::Migration
  def up
  	add_foreign_key :events, :sports, column: :sport, primary_key: "name", name: "event_to_sport_fk"
  end

  def down
  	remove_foreign_key :events, name: "event_to_sport_fk"
  end
end
