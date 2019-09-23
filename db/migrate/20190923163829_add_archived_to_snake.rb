class AddArchivedToSnake < ActiveRecord::Migration[6.0]
  def change
    add_column :snakes, :archived, :boolean, default: false
  end
end
