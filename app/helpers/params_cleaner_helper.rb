module ParamsCleanerHelper
  def clear_pet_params
    pet_params = params[:pet]
    return unless pet_params
    pet_params.delete(:breed_id) if pet_params[:breed_id].blank?
    check_params(pet_params, 'vaccination') if @pet.try(:vaccination_ids)
    check_params(pet_params, 'picture') if @pet.try(:picture_ids)
  end

  def clear_user_params
    return unless params[:user]
    user_params = params[:user]
    user_params.delete(:facebook_id) if user_params[:facebook_id].blank?
    user_params.delete(:google_id) if user_params[:google_id].blank?
  end

  private

  def check_params(pet_params, model)
    present_ids = @pet.send(model + '_ids')
    params_ids = retrieve_ids(pet_params[model + 's_attributes'])
    ids_for_destroy = present_ids - params_ids
    pet_params[model + 's_attributes'] ||= {}
    fill_params_with_ids(ids_for_destroy, pet_params[model + 's_attributes'])
  end

  def retrieve_ids(attributes)
    return [] unless attributes&.values
    attributes.values.map { |av| av[:id].to_i }
  end

  def fill_params_with_ids(ids_for_destroy, attributes_for_destroy)
    return if ids_for_destroy.blank?
    ids_for_destroy.each_with_index do |id, index|
      new_key = (Time.now.to_i + index).to_s
      attributes_for_destroy[new_key] = {}
      attributes_for_destroy[new_key][:id] = id
      attributes_for_destroy[new_key][:_destroy] = true
    end
  end
end
