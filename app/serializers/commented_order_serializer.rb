class CommentedOrderSerializer < ActiveModel::Serializer
  attributes :id, :booked_object, :picture_url, :last_comment, :last_comment_created_at,
             :unread_comments_count_by_user

  def picture_url
    host = ENV['ORIGINAL_URL'].present? ? 'https://' + ENV['ORIGINAL_URL'] : 'localhost:3000'
    host + '/images/AppIcon.png'
  end

  def booked_object
    'Order # ' + object.id.to_s

  end

  def last_comment
    object.last_comment.message

  end

  def last_comment_created_at
    object.last_comment.created_at.to_i

  end
end
