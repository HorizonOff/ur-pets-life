module Api
  module V1
    class PetTypesController < Api::BaseController
      def index
        if !params[:search].nil?
          key = "%#{params[:search]}%"
          pet_types = PetType.where("lower(name) LIKE (?)", key.downcase)
        else
          pet_types = PetType.all
        end
        pet_types = pet_types.order(id: :asc)
        if (!params[:pageno].nil? and !params[:size].nil?)
          size = params[:size].to_i
          page = params[:pageno].to_i
          pet_types = pet_types.limit(size).offset(page * size)
        end
        render json: pet_types
      end

      private

      def set_pet_type
        @pet_type = PetType.find_by_id(params[:pet_type_id])
        return render_404 unless @pet_type
      end
    end
  end
end
