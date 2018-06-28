class CommentedAppointmentSerializer < WorkingHoursSerializer
  attributes :id, :booked_object, :picture_url, :last_comment, :last_comment_created_at,
             :unread_comments_count_by_user

  def picture_url
    object.bookable.picture.try(:url)
  end

  def booked_object
    object.bookable.name
  end

  def last_comment
    object.last_comment.message
  end

  def last_comment_created_at
    object.last_comment.created_at.to_i
  end
end
