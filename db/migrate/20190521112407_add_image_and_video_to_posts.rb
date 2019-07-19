class AddImageAndVideoToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :mobile_image_url, :string
    add_column :posts, :image, :string
    add_column :posts, :video, :string
    add_column :posts, :video_duration, :integer
    add_column :posts, :mobile_video_url, :string
  end
end
