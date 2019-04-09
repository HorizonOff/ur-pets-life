module Api
  module V1
class ItemReviewsController < Api::BaseController
  before_action :set_item_review, only: [:show, :edit, :update, :destroy]

  # GET /item_reviews
  # GET /item_reviews.json
  def index
    @item_reviews = @user.item_reviews
    if (!params[:pageno].nil? and !params[:size].nil?)
      size = params[:size].to_i
      page = params[:pageno].to_i
      @item_reviews = @item_reviews.limit(size).offset(page * size)
    end
    render json: {
      :Reviews => @item_reviews.as_json(
      :only => [:id, :rating, :comment],
      :include => {
        :item => {
          :only => [:id, :picture, :name, :price, :discount, :description, :weight, :unit]
        }
      }
    )
  }
  end

  def review_by_item_id
    @item = Item.find_by_id(params[:id])
    respond_to do |format|
    if @item.nil?
      format.json do
        render json: {
          Message: 'Invalid request. Item not found',
          status: :unprocessable_entity
        }
      end
    else
      if @item.item_reviews.count <= 0
        format.json do
          render json: {
            Message: 'No Reviews found.',
            status: :empty
          }
        end
      else
      format.json do
        render json: @item.item_reviews.as_json(
          :only => [:id, :rating, :comment, :created_at],
          :include => {
            :user => {
              :only => [:id, :first_name, :last_name, :email, :mobile_number, :gender]
            }
          }
        )
      end
    end
    end

    end
  end
  # GET /item_reviews/1
  # GET /item_reviews/1.json
  def show
    render json: @item_review.as_json(
      :only => [:id, :rating, :comment],
      :include => {
        :item => {
          :only => [:id, :picture, :name, :price, :discount, :description, :weight, :unit]
        }
      }
    )
  end

  # GET /item_reviews/new
  def new
    @item_review = ItemReview.new
  end

  # GET /item_reviews/1/edit
  def edit
  end

  # POST /item_reviews
  # POST /item_reviews.json
  def create
    respond_to do |format|
      if (params[:item_id].nil? or params[:orderitem_id].nil?)
        format.json do
          render json: {
            Message: 'Paramters not found. Item and Order item required',
            status: :unprocessable_entity
          }
        end
      end
    if (Item.where(:id => params[:item_id]).exists? and OrderItem.where(:id => params[:orderitem_id]).exists?)
    @item_review = ItemReview.new(:user_id => @user.id, :order_item_id => params[:orderitem_id], :item_id => params[:item_id], :rating => params[:rating], :comment => params[:comment])
      if @item_review.save
        @item = Item.where(:id => params[:item_id]).first
        @item.increment!(:review_count, 1)
        @item.increment!(:rating , params[:rating].to_f)
        @item.update!(:avg_rating => (@item.rating.to_f / @item.review_count))
        @orderitem = OrderItem.where(:id => params[:orderitem_id]).first
        @orderitem.update(:IsReviewed => true)
        format.json do
          render json: {
            Message: 'Item review was successfully created.',
            status: :created,
            data: @item_review.as_json(:only => [:id, :user_id, :item_id, :rating, :comment])
          }
        end
      else
        format.json do
          render json: {
            Message: 'Error adding review',
            status: :unprocessable_entity,
            errors: @item_review.errors
          }
        end
      end
    else
      format.json do
        render json: {
          Message: 'Item not found',
          status: :unprocessable_entity
        }
      end
    end
    end
  end

  # PATCH/PUT /item_reviews/1
  # PATCH/PUT /item_reviews/1.json
  def update
    respond_to do |format|
      if @item_review.update(:rating => params[:rating], :comment => params[:comment])
        format.json do
          render json: {
            Message: 'Item review was successfully updated.',
            status: :updated
          }
        end
      else
        format.json do
          render json: {
            Message: 'Error updating review',
            status: :unprocessable_entity,
            errors: @item_review.errors
          }
        end
      end
    end
  end

  # DELETE /item_reviews/1
  # DELETE /item_reviews/1.json
  def destroy
    @item_review.destroy
    respond_to do |format|
      format.json do
        render json: {
          Message: 'Item review was successfully destroyed.',
          status: :deleted
        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_review
      @item_review = ItemReview.find_by_id(params[:id])
      return render_404 unless @item_review
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_review_params
      params.require(:item_review).permit(:item_id, :rating, :comment)
    end
end
end
end
