# frozen_string_literal: true

module Users
  class << self
    def create_user(*args)
      Users::CreateUser.perform(*args)
    end
  end
end
