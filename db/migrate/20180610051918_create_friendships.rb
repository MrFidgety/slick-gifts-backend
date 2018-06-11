# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :friend, type: :uuid, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :friendships, %i[user_id friend_id], unique: true
  end
end
