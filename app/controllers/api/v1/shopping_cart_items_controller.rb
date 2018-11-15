module Api
  module V1
class ShoppingCartItemsController < Api::BaseController
  before_action :set_shopping_cart_item, only: [:show, :edit, :update, :destroy]

  # GET /shopping_cart_items
  # GET /shopping_cart_items.json
  def index
    @itemsprice = 0
    @user.shopping_cart_items.each do |cartitem|
      @itemsprice += (cartitem.item.price * cartitem.quantity)
    end
    render :json => {
      :cartitems =>  @user.as_json(
      :only => [],
      :include => {
        :shopping_cart_items => {
          :only => [:id, :quantity, :IsRecurring],
          :include => {
            :item => {
              :only => [:id, :name, :price, :picture, :discount, :weight, :description, :unit]
            },
            :recurssion_interval => {
              :only => [:id, :days, :weeks, :label]
            }
          }
        }
      }
    ),
    :VatPercentage => 5,
    :AvailableRedeemPoints => get_user_redeem_points,
    :SubTotal => @itemsprice,
    :DeliveryCharges => @itemsprice > 100 ? 0 : 20,
    :VatCharges => (@itemsprice/100).to_f * 5,
    :Total => @itemsprice + (@itemsprice > 100 ? 0 : 20) + ((@itemsprice/100).to_f * 5)
  }
  end

  def get_user_redeem_points
    if RedeemPoint.where(:user_id => @user.id).exists?
      return RedeemPoint.where(:user_id => @user.id).first().net_worth
    else
      return 0
    end
  end

  def get_cart_stats
    wishlist_count = @user.wishlists.count
    cart_items_count = @user.shopping_cart_items.count
    render json: {
      Favorites: wishlist_count,
      CartItems: cart_items_count
    }
  end

  # GET /shopping_cart_items/1
  # GET /shopping_cart_items/1.json
  def show
    render json: @shopping_cart_item.as_json(
      :only => [:id, :quantity, :IsRecurring],
      :include => {
        :item => {
          :only => [:id, :name, :price, :picture, :discount, :weight, :description, :unit]
        },
        :recurssion_interval =>  {
          :only => [:id, :days, :weeks, :label]
        }
      }
    )
  end

  # GET /shopping_cart_items/new
  def new
    @shopping_cart_item = ShoppingCartItem.new
  end

  # GET /shopping_cart_items/1/edit
  def edit
  end

  # POST /shopping_cart_items
  # POST /shopping_cart_items.json
  def create
    if ShoppingCartItem.where(:user_id => @user.id, :item_id => params[:item_id]).exists?
      @shopping_cart_item = ShoppingCartItem.where(:user_id => @user.id, :item_id => params[:item_id]).first
      update_quantity_if_cart_has_item
      respond_to do |format|
         if @update
           format.json do
             render json: {
               Message: 'Item present in cart. Cart updated',
             }.to_json
           end
         else
           format.json do
             render json: {
               Message: 'Item present in cart. Failed to update cart',
             }.to_json
           end
         end
       end

    else
    @shopping_cart_item = ShoppingCartItem.new(:user_id => @user.id, :item_id => params[:item_id], :quantity => params[:quantity], :IsRecurring => params[:IsRecurring])

    respond_to do |format|
      if @shopping_cart_item.save
        if params[:IsRecurring] == "true"
          @shopping_cart_item.update(:recurssion_interval_id => params[:IntervalId].to_f)
        end
        format.json do
          render json: {
            Message: 'Shopping cart item was successfully created.',
            status: :created
          }.to_json
        end
      else
        format.json do
          render json: {
            Message: @shopping_cart_item.errors,
            status: :unprocessable_entity,
          }.to_json
        end
      end
    end
  end
end

  # PATCH/PUT /shopping_cart_items/1
  # PATCH/PUT /shopping_cart_items/1.json
  def update
    respond_to do |format|
      if @shopping_cart_item
      if @shopping_cart_item.update(:quantity => params[:quantity].to_f, :IsRecurring => params[:IsRecurring])
        if params[:IsRecurring] == "true"
          @shopping_cart_item.update(:recurssion_interval_id => params[:IntervalId].to_f)
        end
        format.json do
          render json: {
            Message: 'Shopping cart item was successfully updated.',
            status: :updated
          }.to_json
        end
      else
        format.json do
          render json: {
            Message: 'Error updating shopping cart item.',
            status: :unprocessable_entity
          }.to_json
        end
      end
    else
      format.json do
        render json: {
          Message: 'Invalid request',
          status: :unprocessable_entity
        }.to_json
      end
    end
    end
  end

  # DELETE /shopping_cart_items/1
  # DELETE /shopping_cart_items/1.json
  def destroy
    if @shopping_cart_item
    @shopping_cart_item.destroy
    respond_to do |format|
      format.json do
        render json: {
          Message: 'Shopping cart item was successfully destroyed.',
          status: :deleted
        }.to_json
      end
    end
  else
    respond_to do |format|
      format.json do
        render json: {
          Message: 'Invalid request',
          status: :unprocessable_entity
        }.to_json
      end
    end
  end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart_item
      if ShoppingCartItem.where(:id => params[:id]).exists?
        @shopping_cart_item = ShoppingCartItem.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shopping_cart_item_params
      params.require(:shopping_cart_item).permit(:IsRecurring, :IntervalId, :quantity, :item_id, :user_id)
    end

    def update_quantity_if_cart_has_item
      if @shopping_cart_item.increment!(:quantity, params[:quantity].to_f)
        @update = true
      else
        @update = false
      end
    end
end
end
end
