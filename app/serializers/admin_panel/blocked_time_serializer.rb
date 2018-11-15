module AdminPanel
  class BlockedTimeSerializer < ActiveModel::Serializer
    attributes :id, :start, :end

    attribute :blocked_time do
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
