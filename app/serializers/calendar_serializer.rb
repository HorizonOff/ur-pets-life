class CalendarSerializer < ActiveModel::Serializer
  attribute :id, if: :calendar?
  attributes :start, :end
  attribute :url, unless: :calendar?

  def start
    object.start_at
  end

  def end
    object.end_at
  end

  def url
    '/admin_panel/appointments/' + object.id.to_s
  end

  def calendar?
    object.is_a? Calendar
  end
end
