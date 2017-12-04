class AddPicturesToModels < ActiveRecord::Migration[5.1]
  def change
  	add_column :pets, :avatar, :string
    add_column :vaccinations, :picture, :string
  end
end
