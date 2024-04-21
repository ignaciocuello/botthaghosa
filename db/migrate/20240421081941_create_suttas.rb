class CreateSuttas < ActiveRecord::Migration[7.1]
  def change
    create_table :suttas do |t|
      t.string :abbreviation, null: false, index: { unique: true }
      t.string :title, null: true

      t.timestamps
    end
  end
end
