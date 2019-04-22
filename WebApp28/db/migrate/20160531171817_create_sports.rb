class CreateSports < ActiveRecord::Migration
  # Create table to store possible sports
  def up
    create_table :sports, id: false do |t|
      t.string :name, primary_key: true, null: false
    end
  end

  def down
    drop_table :sports
  end
end
