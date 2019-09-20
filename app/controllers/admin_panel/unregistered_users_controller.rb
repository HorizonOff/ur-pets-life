module AdminPanel
  class UnregisteredUsersController < AdminPanelController
    before_action :check_existing_objects, only: %i[create update]

    def new
      @unregistered_user = UnregisteredUser.new
    end

    def create
      unregistered_user = @unregistered_user.new(user_params)
      if @objects.present?
        flash[:warning] = 'User already exist'
        render :new
      elsif unregistered_user.save
        flash[:success] = 'User created'
        redirect_to admin_panel_order_path(@order)
      else
        render :new
      end
    end

    def edit; end

    def update
      unregistered_user = @unregistered_user.new(user_params)
      if @objects.present?
        flash[:warning] = 'User already exist'
        render :new
      elsif unregistered_user.save
        flash[:success] = 'User created'
        redirect_to admin_panel_order_path(@order)
      else
        render :edit
      end
    end

    def destroy
    end

    private
      def check_existing_objects
        @objects = UnregisteredUser.where('name ILIKE ?', user_params[:name], user_params[:number])
                                    .where.not(id: unregistered_user&.id)
      end

      def user_params
        params.require(:unregistered_user).permit(:name, :number)
      end
  end
end
