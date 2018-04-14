# frozen_string_literal: true

RSpec.configure do |_c|
  class TestErrors
    include Enumerable

    def initialize(message)
      @message = message
    end

    def each(&block)
      errors.each(&block)
    end

    def errors
      [TestError.new]
    end

    def full_message(_field, _error)
      message
    end

    private

      attr_reader :message
  end

  class TestError
    def status
      "422"
    end
  end
end
