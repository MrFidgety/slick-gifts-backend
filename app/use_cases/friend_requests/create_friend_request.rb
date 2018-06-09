# frozen_string_literal: true

module FriendRequests
  class CreateFriendRequest
    include UseCase

    attr_reader :friend_request

    def initialize(attributes)
      @attributes = attributes
    end

    def perform
      init_form
      save_friend_request
    end

    private

    attr_reader :attributes
    attr_reader :form

    def init_form
      @form = FriendRequestForm.new(FriendRequest.new)
    end

    def save_friend_request
      form.validate(attributes).tap do |success|
        @friend_request = form.model

        unless success && form.save
          add_error_to_base('Failed to save friend request', form.errors)
        end
      end
    end
  end
end
