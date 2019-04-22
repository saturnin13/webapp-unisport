class ModifyUniversityColumnInEvents < ActiveRecord::Migration
  def up
  	rename_column :events, :university, :university_location
  	change_column_null :events, :university_location, false
  end

  def down
  	rename_column :events, :university_location, :university
  	change_column_null :events, :university, :true
  end
end
