module Api
  module V1
    class PasswordsController < Api::BaseController
      skip_before_action :authenticate_user, only: :forgot

      def forgot
        @user = User.find_by_email(params[:email])
        if @user
          @user.send_reset_password_instructions
          render json: { message: 'Resent password link was sent on your email' }, status: :ok
        else
          render_404("Such email address isn't registered. Try again")
        end
      end

      def update
        if @user.valid_password?(params[:current_password])
          if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
            render json: { message: 'Password updated successfully' }
          else
            render_422(parse_errors_messages(@user))
          end
        else
          render_422(current_password: "Current password doesn't match")
        end
      end
    end
  end
end
