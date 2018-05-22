module AdminPanel
  module PictureParamsHelper
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
  end
end
