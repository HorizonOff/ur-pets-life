module Api
  module V1
    class ContactRequests < ActionController::Base
      include Swagger::Blocks

      swagger_path '/contact_requests' do
        operation :post do
          security do
            key :api_key, []
          end

          key :summary, 'Send email to administrator'
          key :description, 'send request'
          key :produces, 'application/json'
          key :consumes, 'application/json'
          key :tags, %w[ContactRequest]

          parameter do
            key :name, :body
            key :in, :body
            key :required, true

            schema do
              property :subject do
                key :type, :string
              end
              property :message do
                key :type, :string
              end
            end
          end

          response 200 do
            key :description, 'Success response'
          end
          response 422 do
            key :description, 'Fail'
          end
        end
      end

      swagger_schema :ContactRequest do
        property :AutToken do
          key :type, :string
        end
        property :subject do
          key :type, :string
        end
        property :message do
          key :type, :string
        end
      end
    end
  end
end
