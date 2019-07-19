class AddImageAndMobileImageUrlToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :mobile_image_url, :string
    add_column :comments, :image, :string
  end
end
