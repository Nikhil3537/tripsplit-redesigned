class DropInvitations < ActiveRecord::Migration[8.1]
  def change
    drop_table :invitations
  end
end
