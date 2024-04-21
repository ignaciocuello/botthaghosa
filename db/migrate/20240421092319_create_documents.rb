class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :title, null: false, index: { unique: true }
      t.string :link

      t.timestamps
    end
  end
end
