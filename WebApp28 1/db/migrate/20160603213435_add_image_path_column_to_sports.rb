class AddImagePathColumnToSports < ActiveRecord::Migration
  def up
  	add_column :sports, :image_path, :string
  end

  def down
  	remove_column :sports, :image_path
  end
end
