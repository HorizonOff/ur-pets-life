module AdminPanel
  class TermsAndConditionsController < AdminPanelController
    before_action :set_terms_and_conditions

    def edit; end

    def update
      @terms_and_conditions.update(terms_and_conditions_params)
      render :edit
    end

    private

    def set_terms_and_conditions
      @terms_and_conditions = TermsAndCondition.first
    end

    def terms_and_conditions_params
      params.require(:terms_and_condition).permit(:content)
    end
  end
end
