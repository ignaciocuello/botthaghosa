class CreateDiscussionSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :discussion_sessions do |t|
      t.datetime :occurs_on, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
