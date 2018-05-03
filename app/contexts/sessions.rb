# frozen_string_literal: true

module Sessions
  class << self
    def create_session(*args)
      Sessions::CreateSession.perform(*args)
    end
  end
end
