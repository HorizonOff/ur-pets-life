class Picture < ApplicationRecord
  belongs_to :pet
  # validates :attachment, file_size: { less_than: 512.kilobytes }
  mount_uploader :attachment, PhotoUploader
end
