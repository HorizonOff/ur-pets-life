module AdminPanel
  class CalendarSerializer < ActiveModel::Serializer
    attributes :id, :start, :end

    attribute :calendar do
      true
    end

    def start
      object.start_at
    end

    def end
      object.end_at
    end
  end
end
