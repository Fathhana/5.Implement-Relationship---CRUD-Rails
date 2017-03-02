class ChangeUserIsToUserId < ActiveRecord::Migration
  def change
    rename_column :comments, :user_is, :user_id
  end
end
