# frozen_string_literal: true

class AddNameAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :citext
    add_column :users, :last_name, :citext
    add_column :users, :username, :citext
  end
end
