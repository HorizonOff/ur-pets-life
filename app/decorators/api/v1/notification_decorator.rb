module Api
  module V1
    class NotificationDecorator < ApplicationDecorator
      decorates :notification
      delegate_all

      def created_at
        model.created_at.to_i
      end

      def viewed_at
        model.viewed_at.present? ? model.viewed_at.to_i : nil
      end

      def pet_id
        model.pet_id unless model.is_for_vaccine?
      end

      def source_type
        if model.appointment_id
          'appointment'
        elsif model.pet_id && model.is_for_vaccine?
          'pet'
        elsif model.pet_id
          'lost'
        end
      end

      def source_id
        model.appointment_id || model.pet_id
      end

      def avatar_url
        if model.pet_id
          model.pet.avatar.try(:url)
        elsif model.appointment_id
          model.appointment.bookable.picture.try(:url)
        else
          app_icon
        end
      end
    end
  end
end
