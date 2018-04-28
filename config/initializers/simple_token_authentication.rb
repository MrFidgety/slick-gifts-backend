# frozen_string_literal: true

SimpleTokenAuthentication.configure do |config|
  config.identifiers = { session: 'id' }
end
