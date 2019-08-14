module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    identified_by :current_session

    def connect
      self.current_session = find_verified_session
      self.current_user = find_verified_user
    end

    protected

    def find_verified_session
      return if cookies.signed[:user_id].present?

      session_auth_token = request.headers['Authorization']
      @session = Session.find_by_token(session_auth_token)

      @session ? @session : reject_unauthorized_connection
    end

    def find_verified_user
      if cookies.signed[:user_id].present?
        if current_user = User.find_by(id: cookies.signed[:user_id])
          current_user
        else
          reject_unauthorized_connection
        end
      else
        if @session
          @session.user
        else
          reject_unauthorized_connection
        end
      end
    end
  end
end

