module AdminPanel
  module ParamsHelper
    def parse_params_for(key)
      parse_picture_params(key)
      parse_options_params(key)
    end

    private

    def parse_picture_params(key)
      attachments = params[key][:attachments]
      return if attachments.blank?
      params[key][:pictures_attributes] ||= {}
      parse_attachments(attachments, key)
    end

    def parse_attachments(attachments, key)
      attachments.each_with_index do |a, index|
        new_key = (Time.now.to_i + index).to_s
        params[key][:pictures_attributes][new_key] = {}
        params[key][:pictures_attributes][new_key][:attachment] = a
      end
    end

    def parse_options_params(key)
      sod = params[key][:service_option_details_attributes]
      params[key].delete(:service_option_details_attributes) if sod.present? && sod[:service_option_id].blank?
    end
  end
end
