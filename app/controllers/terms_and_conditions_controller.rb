class TermsAndConditionsController < ApplicationController
  layout 'terms_layout'

  def show
    @terms = TermsAndCondition.first.content
  end
end
