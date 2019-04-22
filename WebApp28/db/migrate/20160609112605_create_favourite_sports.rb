class CreateFavouriteSports < ActiveRecord::Migration
  def change
    create_table :favourite_sports, id: false do |t|
      t.integer :user_id, null: false
      t.string :sport, null: false
    end
  end
end
