module ParamsCleanerHelper
  def clear_pet_params
    return unless params[:pet]
    pet = params[:pet]
    pet[:vaccinations_attributes]&.each do |_, object|
      object.reject! { |_, v| v.blank? }
      object.delete(:picture) if object[:picture].class.is_a? String
    end
    pet[:pictures_attributes]&.each do |_, object|
      object.reject! { |_, v| v.blank? }
      object.delete(:attachment) if object[:attachment].class.is_a? String
    end
    pet.delete(:avatar) if pet[:avatar].class.is_a? String
    pet.reject! { |_, v| v.blank? }
  end

  def clear_user_params
    return unless params[:user]
    params[:user].reject! { |_, v| v.blank? }
  end
end
