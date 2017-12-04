class Picture < ApplicationRecord
  belongs_to :pet
  mount_uploader :attachment, PhotoUploader
end
