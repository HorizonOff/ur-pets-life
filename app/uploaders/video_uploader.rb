class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Video
  include VideoThumbnailer

  storage Rails.env.test? ? :file : :fog
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # process encode_video: [:mp4]
  process :set_video_data

  version :thumb do
    process generate_thumb: [{ file_extension: 'jpeg' }]
    def full_filename(for_file)
      jpeg_name for_file, version_name
    end
  end

  def jpeg_name(for_file, version_name)
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.jpeg}
  end

  def set_video_data
    video_file = FFMPEG::Movie.new(file.file)
    model.video_duration = video_file.duration
  end

  def extension_whitelist
    %w[mp4]
  end
end
