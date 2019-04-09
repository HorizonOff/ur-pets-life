module Api
module V1
class WishlistsController < Api::BaseController
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]

  # GET /wishlists
  # GET /wishlists.json
  def index
    #render json: @user.wishlists.Item
    if (!params[:pageno].nil? and !params[:size].nil?)
      size = params[:size].to_i
      page = params[:pageno].to_i
      user_wishlist = @user.wishlists.limit(size).offset(page * size)
    else
      user_wishlist = @user.wishlists
    end
    render json: {
      wishlists: user_wishlist.as_json(
      :only => [:id],
        :include => {
          :item => {
            :only => [:id, :name, :price, :picture, :discount, :weight, :description, :unit]
          },
        },
      )
      }
    #render json: @user.as_json(
    #  :only => [],
    #  :include => {
    #    :wishlists => {
    #      :only => [:id],
    #      :include => {
    #        :item => {
    #          :only => [:id, :name, :price, :picture, :discount, :weight, :description, :unit]
    #        },
    #      },
    #    },
    #  },
    #)
    # @wishlists = Wishlist.all
  end

  # GET /wishlists/1
  # GET /wishlists/1.json
  def show
    render json: @wishlist.as_json(
      :only => [],
      :include => {
        :item => {
        :only => [:id, :name, :price, :picture, :discount, :weight, :description, :unit]
        }
      }
    )
  end

  def add_item_to_wish_list
    if Wishlist.where(:user_id => @user.id, :item_id => params[:id]).exists?
      respond_to do |format|
           format.json do
             render json: {
               Message: 'Item already exists in Wishlist',
               status: :exists
             }.to_json
           end
         end
       else
    if Item.where(:id => params[:id]).exists?
    @wishitem = Wishlist.new(:user_id => @user.id, :item_id => params[:id])
    respond_to do |format|
       if @wishitem.save
         format.json do
           render json: {
             Message: 'Item Added to Wishlist',
             status: :created,
             data: @wishitem.as_json(:only => [:id, :item_id, :user_id])
           }.to_json
         end
       else
         format.json do
           render json: {
             Message: 'Oops Something went wrong',
             status: 500
           }.to_json
         end
       end
     end
   else
     respond_to do |format|
     format.json do
       render json: {
         Message: 'Invalid Request',
         status: :unprocessable_entity
       }.to_json
     end
   end
   end
 end
  end
  # GET /wishlists/new
  def new
    @wishlist = Wishlist.new
  end

  # GET /wishlists/1/edit
  def edit
  end

  # POST /wishlists
  # POST /wishlists.json
  def create
    @wishlist = Wishlist.new(wishlist_params)

    respond_to do |format|
      if @wishlist.save
        format.html { redirect_to @wishlist, notice: 'Wishlist was successfully created.' }
        format.json { render :show, status: :created, location: @wishlist }
      else
        format.html { render :new }
        format.json { render json: @wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wishlists/1
  # PATCH/PUT /wishlists/1.json
  def update
    respond_to do |format|
      if @wishlist.update(wishlist_params)
        format.html { redirect_to @wishlist, notice: 'Wishlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @wishlist }
      else
        format.html { render :edit }
        format.json { render json: @wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wishlists/1
  # DELETE /wishlists/1.json
  def destroy
    @wishlist.destroy
    respond_to do |format|
      format.json do
        render json: {
          Message: 'Wishlist was successfully destroyed.',
          status: :deleted
        }.to_json
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wishlist
      @wishlist = Wishlist.find_by_id(params[:id])
      return render_404 unless @wishlist
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wishlist_params
      params.require(:wishlist).permit(:item_id)
    end
end
end
end
