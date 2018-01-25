module Api
  module V1
    class TermsAndConditionsController < Api::BaseController
      skip_before_action :authenticate_user

      def show
        render json: { terms_and_conditions: TermsAndCondition.first.content }
      end
    end
  end
end
