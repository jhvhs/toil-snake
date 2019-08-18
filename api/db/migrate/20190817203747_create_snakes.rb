class CreateSnakes < ActiveRecord::Migration[6.0]
  def change
    create_table :snakes do |t|
      t.string :title
      t.string :author

      t.timestamps
    end
  end
end
