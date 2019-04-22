class AddLevelFieldToEvents < ActiveRecord::Migration
  def up
    add_column :events, :level, :integer, default: 0
  end

  def down
    remove_column :events, :level
  end
end
