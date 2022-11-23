class RenameChechedColumnToNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :cheched, :checked
  end
end
