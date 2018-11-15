class DiagnosisSerializer < ActiveModel::Serializer
  attributes :condition, :message

  attribute :recipes do
    object.recipes.pluck(:instruction)
  end
end
