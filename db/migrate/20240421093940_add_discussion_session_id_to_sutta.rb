class AddDiscussionSessionIdToSutta < ActiveRecord::Migration[7.1]
  def change
    add_reference :suttas, :discussion_session, null: false, foreign_key: true
  end
end
