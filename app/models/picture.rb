class Picture < ApplicationRecord
  belongs_to :picturable, polymorphic: true
  # validates :attachment, file_size: { less_than: 512.kilobytes }
  mount_uploader :attachment, PhotoUploader
end
