module Api
  module V1
    class AdminsController < Api::BaseController
      def index
        @admins = Admin.where(role: "driver")
        if @admins.nil? or @admins.empty?
          render :json => {
              Message: 'No Drivers found'
          }
        else
          render json: @admins.as_json(
            :only => [:id, :name]
          )
        end
      end
    end
  end
end