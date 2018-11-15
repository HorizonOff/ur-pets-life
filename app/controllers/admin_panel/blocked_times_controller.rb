module AdminPanel
  class BlockedTimesController < AdminPanelController
    before_action :set_blocked_time

    def update
      if @blocked_time.update(blocked_time_params)
        render json: { message: 'Schedule successfully updated' }
      else
        render json: { errors: @blocked_time.errors.full_messages }, status: 422
      end
    end

    def destroy
      if @blocked_time.destroy
        render json: { message: 'Schedule successfully deleted' }
      else
        render json: { errors: @blocked_time.errors.full_messages }, status: 422
      end
    end

    private

    def set_blocked_time
      @blocked_time = BlockedTime.find_by(id: params[:id])
    end

    def blocked_time_params
      params.permit(:start_at, :end_at)
    end
  end
end
