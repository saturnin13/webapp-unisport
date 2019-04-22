class ChangeUsersFields < ActiveRecord::Migration
  def up
  	## First and Last Name cannot be null
  	change_column_null :users, :first_name, false
  	change_column_null :users, :last_name, false

  	## Removing university field
  	remove_column :users, :university
  end

  def down
    change_column_null :users, :first_name, true
  	change_column_null :users, :last_name, true

    add_column :users, :university, :string
  end
end
