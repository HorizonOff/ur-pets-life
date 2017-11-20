module Api
  module V1
    class PasswordsController < Api::BaseController
      skip_before_action :authenticate_user

      def forgot
        if @user = User.find_by_email(params[:email])
          @user.send_reset_password_instructions
          render json: { message: 'Resent password link was sent on your email' }, status: :ok
        else
          render_404
        end
      end
    end
  end
end
