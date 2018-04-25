# frozen_string_literal: true

module Users
  class << self
    def create_user(*args)
      Users::CreateUser.perform(*args)
    end

    def confirm_user(*args)
      Users::ConfirmUser.perform(*args)
    end
  end
end
