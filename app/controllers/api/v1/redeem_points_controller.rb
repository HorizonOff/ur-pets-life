module Api
  module V1
class RedeemPointsController < Api::BaseController
  before_action :set_redeem_point, only: [:show, :edit, :update, :destroy]

  # GET /redeem_points
  # GET /redeem_points.json
  def index
    @user_redeem_points = RedeemPoint.where(:user_id => @user.id).first
    if !@user_redeem_points.nil?
      render json: {
        Available: @user_redeem_points.net_worth,
        Availed: @user_redeem_points.totalavailedpoints,
        Earned: @user_redeem_points.totalearnedpoints,
        Orders: @user.orders.count,
        NoramlSpendings: OrderItem.includes(:order).where("orders.user_id = (?) AND order_items.status != (?) AND order_items.isdiscounted = false", @user.id, 'cancelled').references(:orders).sum("Total_Price"),
        DiscountedSpendings: OrderItem.includes(:order).where("orders.user_id = (?) AND order_items.status != (?) AND order_items.isdiscounted = true", @user.id, 'cancelled').references(:orders).sum("Total_Price")
      }
    else   
      render json: {
        Available: 0,
        Availed: 0,
        Earned: 0,
        Orders: @user.orders.count,
        NoramlSpendings: OrderItem.includes(:order).where(order_items: {isdiscounted: false}, orders: {user_id: @user.id}).sum(:Total_Price),
        DiscountedSpendings: OrderItem.includes(:order).where(order_items: {isdiscounted: true}, orders: {user_id: @user.id}).sum(:Total_Price)
      }
    end
  end

  # GET /redeem_points/1
  # GET /redeem_points/1.json
  def show
  end

  # GET /redeem_points/new
  def new
    @redeem_point = RedeemPoint.new
  end

  # GET /redeem_points/1/edit
  def edit
  end

  # POST /redeem_points
  # POST /redeem_points.json
  def create
    @redeem_point = RedeemPoint.new(redeem_point_params)

    respond_to do |format|
      if @redeem_point.save
        format.html { redirect_to @redeem_point, notice: 'Redeem point was successfully created.' }
        format.json { render :show, status: :created, location: @redeem_point }
      else
        format.html { render :new }
        format.json { render json: @redeem_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redeem_points/1
  # PATCH/PUT /redeem_points/1.json
  def update
    respond_to do |format|
      if @redeem_point.update(redeem_point_params)
        format.html { redirect_to @redeem_point, notice: 'Redeem point was successfully updated.' }
        format.json { render :show, status: :ok, location: @redeem_point }
      else
        format.html { render :edit }
        format.json { render json: @redeem_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeem_points/1
  # DELETE /redeem_points/1.json
  def destroy
    @redeem_point.destroy
    respond_to do |format|
      format.html { redirect_to redeem_points_url, notice: 'Redeem point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redeem_point
      @redeem_point = RedeemPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def redeem_point_params
      params.require(:redeem_point).permit(:net_worth, :last_net_worth, :last_reward_type, :last_reward_worth, :last_reward_update, :last_net_update, :user_id)
    end
end
end
end
