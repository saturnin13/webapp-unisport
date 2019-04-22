class AddUniversityToEvents < ActiveRecord::Migration
  def up
  	add_column :events, :university, :string
  end

  def down
  	remove_column :events, :university
  end
end
