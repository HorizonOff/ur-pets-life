module Api
  module V1
    class TermsAndConditionsController < Api::BaseController
      skip_before_action :authenticate_user

      def show
        render json: TermsAndCondition.first.content.to_json
      end
    end
  end
end
