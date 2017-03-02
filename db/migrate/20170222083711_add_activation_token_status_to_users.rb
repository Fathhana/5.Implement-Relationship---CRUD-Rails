class AddActivationTokenStatusToUsers < ActiveRecord::Migration

  def change
      add_column :users, :activation_token, :string
      add_column :users, :activation_status, :string

  end

end
