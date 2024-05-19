class AddLogisticsUserIdToDiscussionSession < ActiveRecord::Migration[7.1]
  def change
    add_column :discussion_sessions, :logistics_user_id, :string
  end
end
