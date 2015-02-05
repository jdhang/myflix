class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.timestamps null:false
      t.integer :user_id, :follower_id, null:false
    end
  end
end
