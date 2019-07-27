module Api
  module V1
    class SalesController < Api::BaseController
      skip_before_action :authenticate_user, only: :categories

      def categories
        render json: {
          first_month: (Time.current + 1.month).strftime('%B') + ' Expiry',
          second_month: (Time.current + 2.month).strftime('%B') + ' Expiry',
          third_month: (Time.current + 3.month).strftime('%B') + ' Expiry',
          fourth_month: (Time.current + 4.month).strftime('%B') + ' Expiry'
        }
      end
    end
  end
end
