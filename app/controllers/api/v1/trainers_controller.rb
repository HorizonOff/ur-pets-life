module Api
  module V1
    class TrainersController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_trainer, only: :show

      def index
        trainers = trainers_query.find_objects
        serialized_trainers = ActiveModel::Serializer::CollectionSerializer.new(
          trainers, serializer: TrainerIndexSerializer, scope: serializable_params
        )

        render json: { trainers: serialized_trainers, total_count: trainers.total_count }
      end

      def show
        favorite = @trainer.favorites.find_by(user: @user)

        render json: @trainer, scope: { favorite: favorite }
      end

      private

      def set_trainer
        @trainer = Trainer.find_by_id(params[:id])
        return render_404 unless @trainer
      end

      def trainers_query
        @trainers_query ||= ::Api::V1::LocationBasedQuery.new('Trainer', params)
      end
    end
  end
end
