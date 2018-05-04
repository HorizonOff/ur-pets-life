class ServiceOptionTimeSerializer < ActiveModel::Serializer
  attributes :id, :time_range

  def time_range
    object.start_at.strftime('%l:%M %p') + ' - ' + object.end_at.strftime('%l:%M %p')
  end
end
