module Api
  module V1
    class AdsController < Api::BaseController
      def current
        @ad = Ad.active
        render json: { image_url: @ad.image_url }.to_json
      end
    end
  end
end
