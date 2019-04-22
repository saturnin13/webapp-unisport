class AddImageFieldsInUserTable < ActiveRecord::Migration
  def up
    add_column :users, :filename, :string
    add_column :users, :content_type, :string
    add_column :users, :file_contents, :binary
  end

  def down
    remove_column :users, :filename
    remove_column :users, :content_type
    remove_column :users, :file_contents
  end
end
