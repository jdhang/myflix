class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.timestamps null:false
      t.string :name, :email
      t.text :message
      t.integer :inviter_id
      t.boolean :registered, default: false
    end
  end
end
