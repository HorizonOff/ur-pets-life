class PagesController < ApplicationController
  layout 'landing'

  def landing
    @contact_request = ContactRequest.new
  end

  def send_message
    @contact_request = ContactRequest.new(contact_request_params)
    @contact_request.assign_attributes(email: @user.email, user: @user) if @user
    ContactRequestMailer.send_contact_request(@contact_request).deliver if @contact_request.save
  end

  private

  def contact_request_params
    params.require(:contact_request).permit(:email, :user_name, :message)
  end
end
