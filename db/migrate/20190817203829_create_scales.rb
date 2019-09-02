class CreateScales < ActiveRecord::Migration[6.0]
  def change
    create_table :scales do |t|
      t.references :snake, null: false, foreign_key: true
      t.string :author
      t.text :details

      t.timestamps
    end
  end
end
