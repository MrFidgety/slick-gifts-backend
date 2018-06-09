# frozen_string_literal: true

# Defines the abstract Use Case interface that gets included in use cases
module UseCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  module ClassMethods
    # The perform method of a UseCase should always return itself
    def perform(*args)
      new(*args).tap(&:perform)
    end
  end

  # implement all the steps required to complete this use case
  def perform
    raise NotImplementedError
  end

  # inside of perform, add errors if the use case did not succeed
  def success?
    errors.none?
  end

  # Add an error to the use case
  def add_error_to_base(string = default_error_message, sub_errors = [])
    errors.add(:base, string)
    add_sub_errors(sub_errors)
  end

  def error_and_rollback(message = default_error_message, sub_errors = [])
    add_error_to_base(message, sub_errors)
    raise ActiveRecord::Rollback
  end

  private

  def add_sub_errors(sub_errors)
    return add_reform_errors(sub_errors) unless sub_errors.respond_to? :each

    sub_errors.each { |attr, message| errors.add(attr, message) }
  end

  def add_reform_errors(reform_errors)
    reform_errors.messages.each do |(attr, messages)|
      errors.add(attr, messages.first)
    end
  end
end
