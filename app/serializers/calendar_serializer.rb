class CalendarSerializer < ActiveModel::Serializer
  attribute :id, if: :show_id?
  attributes :start, :end

  def start
    object.start_at
  end

  def end
    object.end_at
  end

  def show_id?
    object.is_a? Calendar
  end
end
