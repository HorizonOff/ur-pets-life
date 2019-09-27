class PagesController < ApplicationController
  layout 'new_landing'

  def landing
    @contact_request = ContactRequest.new
  end

  def new_landing
    @contact_request = ContactRequest.new
  end

  def send_message
    @contact_request = ContactRequest.new(contact_request_params)
    @contact_request.assign_attributes(email: @user.email, user: @user) if @user
    if verify_recaptcha(model: @contact_request) && @contact_request.save
      redirect_to contact_us_path, flash: { message: 'Successfully created' }
    else
      redirect_to contact_us_path, flash: { error: 'Some error' }
    end
  end

  def index; end
  def about; end
  def loyalty; end
  def pay_it_forward; end
  def sale; end
  def community; end
  def contact_us; end
  def loyalty_program; end
  def privacy_policy; end
  def term_conditions; end
  def new_privacy_policy; end
  def cancelation_policy; end

  def app_loyalty_program; end
  def app_new_privacy_policy; end
  def app_cancelation_policy; end
  def app_term_conditions; end

  def sale
    items = Item.sale
    params[:pet_type] = 'all' if params[:pet_type].blank?
    params[:sort_type] = 'discount' if params[:sort_type].blank?
    if params[:pet_type] == "all"
      sort_by_pet_type = items
    else
      sort_by_pet_type = items.where(pet_type_id: params[:pet_type])
    end
    if params[:sort_type] == 'max_price'
      filter = sort_by_pet_type.order("price DESC")
    elsif  params[:sort_type] == 'low_price'
      filter = sort_by_pet_type.order("price ASC")
    else
      filter = sort_by_pet_type.order("discount DESC")
    end
    @sorted = filter.page(params[:page]).per(8)
  end

  def contact_us
    @contact_request = ContactRequest.new
  end

  private

  def contact_request_params
    params.require(:contact_request).permit(:email, :user_name, :message)
  end
end
