class VersionSerializer < ActiveModel::Serializer
  type 'weight'
  attribute :created_at, key: :date do
    object.created_at.to_i
  end

  attribute :weight do
    object.changeset['weight'].last
  end
end
