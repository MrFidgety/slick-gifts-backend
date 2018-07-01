# frozen_string_literal: true

class CreateBlockades < ActiveRecord::Migration[5.2]
  def change
    create_table :blockades, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :blocked, type: :uuid, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :blockades, %i[user_id blocked_id], unique: true
  end
end
