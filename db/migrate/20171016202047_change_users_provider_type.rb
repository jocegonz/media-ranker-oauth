class ChangeUsersProviderType < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :provider, :string
  end
end
