# frozen_string_literal: true

class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :friend, type: :uuid, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :friend_requests, %i[user_id friend_id], unique: true
  end
end
