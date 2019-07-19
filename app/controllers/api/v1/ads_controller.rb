module Api
  module V1
    class AdsController < Api::BaseController
      def current
        @ad = Ad.active
        return render json: { image_url: nil }.to_json if @ad.blank?

        @ad.update_column(:view_count, @ad.view_count + 1)
        render json: { image_url: @ad.image_url }.to_json
      end
    end
  end
end
