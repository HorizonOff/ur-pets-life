class CommentSerializer < BaseMethodsSerializer
  type 'comment'

  attributes :id, :message, :created_at, :user_name, :avatar_url
end
