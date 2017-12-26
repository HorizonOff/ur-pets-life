module Api
  module V1
    class TrainersController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_trainer, only: :show

      def index
        trainers = trainers_query.find_trainers
        serialized_trainers = ActiveModel::Serializer::CollectionSerializer.new(
          trainers, serializer: TrainerIndexSerializer,
                    scope: { latitude: params[:latitude], longitude: params[:longitude] }
        )

        render json: { trainers: serialized_trainers, total_count: trainers.total_count }
      end

      def show
        render json: @trainer
      end

      private

      def set_trainer
        @trainer = Trainer.find_by_id(params[:id])
        return render_404 unless @trainer
      end

      def trainers_query
        @trainers_query ||= ::Api::V1::LocationBasedQuery.new(Trainer.all, params)
      end
    end
  end
end
