class PagesController < ApplicationController
  layout 'landing'

  def landing
    @contact_request = ContactRequest.new
  end

  def send_message
    @contact_request = ContactRequest.new(contact_request_params)
    @contact_request.assign_attributes(email: @user.email, user: @user) if @user
    @contact_request.save
  end

  def privacy_policy; end

  private

  def contact_request_params
    params.require(:contact_request).permit(:email, :user_name, :message)
  end
end
