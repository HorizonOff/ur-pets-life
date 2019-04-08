module Api
  module V1
class ShippingAddressesController < Api::BaseController
  before_action :set_shipping_address, only: [:show, :edit, :update, :destroy]

  # GET /shipping_addresses
  # GET /shipping_addresses.json
  def index
    @user_address = Location.where(:place_id => @user.id).first
    render json:
      @user_address.as_json(
      :only => [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number]
    )
  end

  # GET /shipping_addresses/1
  # GET /shipping_addresses/1.json
  def show
    render json: @shipping_address
  end

  # GET /shipping_addresses/new
  def new
    @shipping_address = Location.new
  end

  # GET /shipping_addresses/1/edit
  def edit
  end

  # POST /shipping_addresses
  # POST /shipping_addresses.json
  def create
    respond_to do |format|
      if Location.where(:place_id => @user.id).exists?
        format.json do
          render json: {
            Message: 'Shipping address already exist',
            status: :unprocessable_entity,
            data: Location.where(:place_id => @user.id).first.as_json(:only => [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number])
          }.to_json
        end
      else
    @shipping_address = Location.new(:latitude => params[:latitude], :longitude => params[:longitude], :city => params[:city], :area => params[:area], :street => params[:street], :building_name => params[:building_name], :unit_number => params[:unit_number], :villa_number => params[:villa_number], :building_type => params[:building_type], :place_id => @user.id, :place_type => 'User')

      if @shipping_address.save
        format.json do
          render json: {
            Message: 'Shipping address was successfully created.',
            status: :created,
            data: @shipping_address.as_json(:only => [:id, :latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number])
          }.to_json
        end
      else
        format.json do
          render json: {
            Message: 'Error creating shipping address.',
            status: :unprocessable_entity
          }.to_json
        end
      end
    end
    end
  end

  # PATCH/PUT /shipping_addresses/1
  # PATCH/PUT /shipping_addresses/1.json
  def update
    respond_to do |format|
      if @shipping_address.update(:latitude => params[:latitude], :longitude => params[:longitude], :city => params[:city], :area => params[:area], :street => params[:street], :building_name => params[:building_name], :unit_number => params[:unit_number], :villa_number => params[:villa_number], :building_type => params[:building_type])
        format.json do
          render json: {
            Message: 'Shipping address was successfully updated.',
            status: :updated,
            data: @shipping_address.as_json(),
            errors: @shipping_address.errors
          }.to_json
        end
      else
        format.json do
          render json: {
            Message: 'Error updating shipping address.',
            status: :unprocessable_entity,
            errors: @shipping_address.errors
          }.to_json
        end
      end
    end
  end

  # DELETE /shipping_addresses/1
  # DELETE /shipping_addresses/1.json
  def destroy
    @shipping_address.destroy
    respond_to do |format|
      format.json do
        render json: {
          Message: 'Shipping address was successfully destroyed.',
          status: :deleted
        }.to_json
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipping_address
      @shipping_address = Location.find_by_id(params[:id])
      return render_404 unless @shipping_address
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipping_address_params
      params.permit(:latitude, :longitude, :city, :area, :street, :building_name, :unit_number, :villa_number, :building_type)
    end
end
end
end
