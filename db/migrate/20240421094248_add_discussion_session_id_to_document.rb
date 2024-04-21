class AddDiscussionSessionIdToDocument < ActiveRecord::Migration[7.1]
  def change
    add_reference :documents, :discussion_session, null: false, foreign_key: true
  end
end
