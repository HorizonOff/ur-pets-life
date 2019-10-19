module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    identified_by :current_session

    def connect
      self.current_session = find_verified_session
      # self.current_admin = find_verified_admin
      self.current_user = find_verified_admin
    end

    protected

    def find_verified_session
      return if env['warden'].user(:admin).present?

      session_auth_token = request.headers['Authorization']
      @session = Session.find_by_token(session_auth_token)

      @session ? @session : reject_unauthorized_connection
    end

    def find_verified_admin
      env['warden'].user(:admin)
    end
  end
end
