class AddVideoToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :video, :string
    add_column :comments, :video_duration, :integer
    add_column :comments, :mobile_video_url, :string
  end
end
