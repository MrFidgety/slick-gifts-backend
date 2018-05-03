# frozen_string_literal: true

RSpec.configure do |_|
   def authenticate_as(user)
     allow_any_instance_of(Api::V1::ApiController)
       .to receive(:current_user) { user }
   end

   def auth_headers_for_user(user)
     auth_headers_for_session(user.sessions.first)
   end

   def auth_headers_for_session(session)
     {
       'X-Session-Id' => session.id,
       'X-Session-Token' => session.authentication_token
     }
   end
 end
