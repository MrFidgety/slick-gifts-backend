# frozen_string_literal: true

class EnablePgExtensions < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'
    enable_extension 'citext'
  end
end
