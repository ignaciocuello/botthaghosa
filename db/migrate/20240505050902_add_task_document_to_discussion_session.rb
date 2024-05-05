class AddTaskDocumentToDiscussionSession < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :kind, :integer, default: 0, null: false
  end
end
