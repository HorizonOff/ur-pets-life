class PostSerializer < BaseMethodsSerializer
  type 'post'

  attributes :id, :title, :message, :comments_count, :created_at, :user_name, :pet_type_id
end
