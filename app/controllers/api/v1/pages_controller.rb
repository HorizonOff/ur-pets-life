module Api
  module V1
    class PagesController < ApplicationController
      def index
        render json: { status: 'success', message: 'Hello world' }, status: :ok
      end
    end
  end
end
