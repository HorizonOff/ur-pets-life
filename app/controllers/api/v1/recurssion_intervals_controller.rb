module Api
  module V1
class RecurssionIntervalsController < ApplicationController
  before_action :set_recurssion_interval, only: [:show, :edit, :update, :destroy]

  # GET /recurssion_intervals
  # GET /recurssion_intervals.json
  def index
    @recurssion_intervals = RecurssionInterval.all
    render json: @recurssion_intervals.order(id: :asc)
  end

  # GET /recurssion_intervals/1
  # GET /recurssion_intervals/1.json
  def show
  end

  # GET /recurssion_intervals/new
  def new
    @recurssion_interval = RecurssionInterval.new
  end

  # GET /recurssion_intervals/1/edit
  def edit
  end

  # POST /recurssion_intervals
  # POST /recurssion_intervals.json
  def create
    @recurssion_interval = RecurssionInterval.new(recurssion_interval_params)

    respond_to do |format|
      if @recurssion_interval.save
        format.html { redirect_to @recurssion_interval, notice: 'Recurssion interval was successfully created.' }
        format.json { render :show, status: :created, location: @recurssion_interval }
      else
        format.html { render :new }
        format.json { render json: @recurssion_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recurssion_intervals/1
  # PATCH/PUT /recurssion_intervals/1.json
  def update
    respond_to do |format|
      if @recurssion_interval.update(recurssion_interval_params)
        format.html { redirect_to @recurssion_interval, notice: 'Recurssion interval was successfully updated.' }
        format.json { render :show, status: :ok, location: @recurssion_interval }
      else
        format.html { render :edit }
        format.json { render json: @recurssion_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recurssion_intervals/1
  # DELETE /recurssion_intervals/1.json
  def destroy
    @recurssion_interval.destroy
    respond_to do |format|
      format.html { redirect_to recurssion_intervals_url, notice: 'Recurssion interval was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recurssion_interval
      @recurssion_interval = RecurssionInterval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recurssion_interval_params
      params.require(:recurssion_interval).permit(:weeks, :days)
    end
end
end
end
