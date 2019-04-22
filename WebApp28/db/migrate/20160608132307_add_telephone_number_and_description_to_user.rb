class AddTelephoneNumberAndDescriptionToUser < ActiveRecord::Migration
  def up
    add_column :users, :telephone_number, :string
    add_column :users, :description, :string
  end

  def down
    remove_column :users, :description
    remove_column :users, :telephone_number
  end
end
