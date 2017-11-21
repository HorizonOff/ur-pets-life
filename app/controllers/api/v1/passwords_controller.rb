module Api
  module V1
    class PasswordsController < Api::BaseController
      skip_before_action :authenticate_user, only: :forgot

      def forgot
        if @user = User.find_by_email(params[:email])
          @user.send_reset_password_instructions
          render json: { message: 'Resent password link was sent on your email' }, status: :ok
        else
          render_404
        end
      end

      def update
        if @user.valid_password?(params[:current_password])
          if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
            render json: { message: 'Password updated successfully' }
          else
            render_422(@user.errors.full_messages)
          end
        else
          render_422('Current password doesn\'t match')
        end
      end
    end
  end
end
