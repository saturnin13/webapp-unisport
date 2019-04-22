class AddForeignKeysToFavouriteSports < ActiveRecord::Migration
  def up
  	add_foreign_key :favourite_sports, :users 
  	add_foreign_key :favourite_sports, :sports, column: :sport, primary_key: "name", name: "fav_sport_to_sport_fk"
  end

  def down
  	remove_foreign_key :favourite_sports, :users
  	remove_foreign_key :favourite_sports, name: "fav_sport_to_sport_fk"
  end
end
