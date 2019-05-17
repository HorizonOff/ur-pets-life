class CommentSerializer < ActiveModel::Serializer
  type 'comment'

  attributes :id, :message, :created_at, :user_name, :avatar_url, :image, :video, :video_duration
  attribute :read_at, if: :appointment_comment?

  def read_at
    object.read_at.present? ? object.read_at.to_i : nil
  end

  def appointment_comment?
    object.commentable_type == 'Appointment'
  end
end
