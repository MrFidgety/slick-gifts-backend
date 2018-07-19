# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :citext
#  last_name              :citext
#  username               :citext
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord
  include PgSearch

  pg_search_scope :search_by_names,
                  against: { first_name: 'A', last_name: 'B', username: 'C' },
                  using: { tsearch: { prefix: true, any_word: true } }

  acts_as_sessionable

  # Include default devise modules. Others available are:
  # :lockable, :rememberable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable, :recoverable,
         :validatable

  has_many :blockades, dependent: :destroy
  has_many :blocked_users, through: :blockades, source: :blocked

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  # Force devise emails to be sent in workers
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
