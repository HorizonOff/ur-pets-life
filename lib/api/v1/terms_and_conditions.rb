module Api
  module V1
    class TermsAndConditions < ActionController::Base
      include Swagger::Blocks

      swagger_schema :TermsAndConditionsResponse do
        property :terms_and_conditions do
          key :type, :string
          key :example, 'text'
        end
      end

      swagger_path '/terms_and_conditions' do
        operation :get do
          key :description, 'Get terms and condtitions'
          key :consumes, %w[application/json]
          key :produces, %w[application/json]
          key :tags, %W[Terms\ and\ Conditions]

          response 200 do
            key :description, 'Success response'
            schema do
              key :'$ref', :TermsAndConditionsResponse
            end
          end
        end
      end
    end
  end
end
